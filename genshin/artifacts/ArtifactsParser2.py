import os
import re
from argparse import ArgumentParser
from io import BytesIO
from time import sleep
from typing import List

import numpy as np
import Quartz
import Vision
from Cocoa import NSData
from colorama import just_fix_windows_console
from cv2 import COLOR_RGB2BGR, cvtColor, destroyAllWindows, imshow, waitKey
from PIL import ImageGrab

from Profiles.RegionsPrfl import RegionsPrfl, RegionsPrfls
from Profiles.WeightsPrfl import WeightsPrfls
from SubStatsAdder import SubStatsAdder
from Utils.Constants import PCT, TailKWs, eps, fourCoe, inf, one, oneIncCoeExp, zero
from Utils.Stats import StatHitsVec, Stats, StatsN
from Utils.TextStyle import DebugStyle, InfoStyle, LevelStyle, MainStatStyle


class ArtifactsParser:
    rep_numeric = re.compile(r"[0-9]+[.,]{0,1}[0-9]*")

    def get_double(self, text):
        res = ArtifactsParser.rep_numeric.findall(text)
        if len(res) != 1:
            raise ValueError(f"Failed to get double: {text}")
        return np.double(res[0])

    def get_int(self, text):
        res = ArtifactsParser.rep_numeric.findall(text)
        if len(res) != 1:
            raise ValueError(f"Failed to get int: {text}")
        return int(res[0])

    def __init__(self, regionKey, weightsKeys, fourstars=False, debug=False):
        self.debug = debug
        self.presenting = None
        self.regionPrfl: RegionsPrfl = RegionsPrfls[regionKey]
        self.weightsPrfls: List[RegionsPrfl] = [
            wp for wp in WeightsPrfls.values() if any([key.upper() in wp.key.upper() for key in weightsKeys])
        ]
        self.fourstars = fourstars

        self.request = Vision.VNRecognizeTextRequest.alloc().init()
        self.request.setRecognitionLanguages_(["en"])

    def screenshot(self):
        shot = ImageGrab.grab(bbox=self.regionPrfl.full)
        return shot

    def debugimg(self, img):
        if self.debug:
            img = np.array(img)
            imshow("ArtifactsParser", cvtColor(img, COLOR_RGB2BGR))
            waitKey(0)
            destroyAllWindows()

    def debugtext(self, text):
        if self.debug:
            DebugStyle.println(text)

    def ocr(self, img, target=None):
        subimg = img
        if target is not None:
            region = tuple(target[i] - self.regionPrfl.full[i & 1] for i in range(4))
            subimg = subimg.crop(region)
        self.debugimg(subimg)

        with BytesIO() as dummy_io:
            subimg.save(dummy_io, format="PNG")
            nsdata = NSData.dataWithBytes_length_(dummy_io.getvalue(), len(dummy_io.getvalue()))
        cg_image = Quartz.CGImageSourceCreateImageAtIndex(Quartz.CGImageSourceCreateWithData(nsdata, None), 0, None)
        if cg_image is None:
            raise RuntimeError(f"Unable to create CGImage from subimg.")

        handler = Vision.VNImageRequestHandler.alloc().initWithCGImage_options_(cg_image, {})
        if handler.performRequests_error_([self.request], None):
            res = "\n".join([res.topCandidates_(1)[0].string() for res in self.request.results()])
            res = res.replace("Bonu:", "Bonus")
            return res
        else:
            raise RuntimeError("Error performing OCR")

    def put_stat(self, key: str, value: str, stats_vec: np.array, isMainStat: bool = False):
        if PCT not in value:
            value = value

        validated = np.array([one if stat.validate(key, value) else zero for stat in Stats], dtype=np.double)
        if np.sum(validated) == 0:
            raise ValueError(f"No stat match found for: ({key}: {value})")
        elif np.sum(validated) > 1:
            raise ValueError(f"Multiple stats matches found for: ({key}: {value})")
        elif np.fabs(stats_vec @ validated) > eps:
            raise ValueError(f"Redundant stat match found for: ({key}: {value})")

        standardized_value = -inf if isMainStat else self.get_double(value)

        self.debugtext("%s : %.2f" % (Stats[np.where(validated > one - eps)[0].flat[0]].key, standardized_value))

        if self.fourstars:
            stats_vec += validated * standardized_value * StatHitsVec / fourCoe
        else:
            stats_vec += validated * standardized_value * StatHitsVec

    def summarize(self, organic_vec: np.array, levCur: int, expVec: np.array = np.zeros(StatsN, dtype=np.double)):
        stats_vec = np.copy(organic_vec)

        if np.sum(expVec) > eps:
            stats_vec = organic_vec - SubStatsAdder.toExsists(organic_vec) * oneIncCoeExp + expVec * oneIncCoeExp

        main_key = Stats[np.where(stats_vec < -one)[0].flat[0]].key
        MainStatStyle.println(main_key)

        LevelStyle.println("+%d" % levCur)

        for i in range(StatsN):
            if stats_vec[i] < np.double(0.65):
                continue
            if self.fourstars:
                Stats[i].println(stats_vec[i] * fourCoe)
            else:
                Stats[i].println(stats_vec[i])

        InfoStyle.println("v" * 32)

        for wPrfl in self.weightsPrfls:
            wPrfl.println(stats_vec)

        InfoStyle.println(">" * 64)

    def tailing(self, text):
        for tail in TailKWs:
            if tail in text:
                return True
        return False

    def understanding(self, img):
        self.debugimg(img)
        stats_vec = np.zeros(StatsN, dtype=np.double)

        if not self.regionPrfl.single:
            # Main Stats
            main_key = self.ocr(img, self.regionPrfl.main_key)
            main_val = self.ocr(img, self.regionPrfl.main_val)
            self.put_stat(main_key, main_val, stats_vec, True)
            levMax = 4 if self.fourstars else 5
            # Level
            levCur4Str = self.ocr(img, self.regionPrfl.level)
            levCur = self.get_int(levCur4Str) // 4
            # Sub Stats
            for substat in self.regionPrfl.substats:
                sub_kv = self.ocr(img, substat)
                if self.tailing(sub_kv):
                    break
                sub_key, sub_value = None, None
                try:
                    sub_key, sub_value = sub_kv.split("+")
                except ValueError:
                    raise ValueError(f"Bad SubStat: {sub_kv}")
                self.put_stat(sub_key, sub_value, stats_vec)
        else:
            sub_num = 0
            contents = self.ocr(img).split("\n")[::-1]
            it = iter(contents)
            row = next(it)
            while "Piece Set" in row:
                row = next(it)
            while "•" not in row:
                row = next(it)
            while "•" in row:
                try:
                    sub_key, sub_value = row.split("+")
                except ValueError:
                    raise ValueError(f"Bad SubStat: {row}")
                self.put_stat(sub_key, sub_value, stats_vec)
                sub_num += 1
                row = next(it)
            levMax = 4 if self.fourstars else 5
            levCur = self.get_int(row) // 4
            main_val = next(it)
            main_key = next(it)
            self.put_stat(main_key, main_val, stats_vec, True)

        # Summarize Current
        processing = hash(stats_vec.data.tobytes())
        if processing != self.presenting:
            if not self.debug:
                os.system("clear")
            self.summarize(stats_vec, levCur)
            self.presenting = processing
            # Expecttions
            if levCur < levMax:
                subStatsAdder = SubStatsAdder(stats_vec, debug=False)
                expVec = subStatsAdder.calc(iterNum=levMax - levCur)
                self.summarize(stats_vec, levMax, expVec)

    def start(self):
        while True:
            try:
                img = self.screenshot()
                self.understanding(img)
            except Exception as e:
                DebugStyle.println(e, dynamic=True)
                sleep(4.0)
            if self.debug:
                break
            sleep(0.100)


def main():
    just_fix_windows_console()

    argument_parser = ArgumentParser(description="Genshin Impact artifacts stat parser.")
    argument_parser.add_argument("--debug", action="store_true")
    argument_parser.add_argument("--region", default="C3440X1440")
    argument_parser.add_argument("--fourstars", action="store_true")
    argument_parser.add_argument("--weights", action="extend", nargs="+")
    args = argument_parser.parse_args()

    artifacts_parser = ArtifactsParser(
        regionKey=args.region.upper(), fourstars=args.fourstars, weightsKeys=args.weights, debug=args.debug
    )
    artifacts_parser.start()


if __name__ == "__main__":
    main()
