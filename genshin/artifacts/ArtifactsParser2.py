import os
import re
from argparse import ArgumentParser
from io import BytesIO
from time import sleep
from typing import List

import cv2
import numpy as np
import Quartz
import Vision
from Cocoa import NSData
from colorama import just_fix_windows_console
from PIL import ImageGrab

import Profiles.WeightsPrfl_HSR
import Utils.Stats_HSR
from Profiles.RegionsPrfl import RegionsPrfl, RegionsPrfls
from Profiles.WeightsPrfl import weights_prfls
from SubStatsAdder import SubStatsAdder
from Utils.Constants import PCT, TailKWs, eps, fourCoe, inf, one, oneIncCoeExp, zero
from Utils.Stats import stats_hit, stats_list, stats_num
from Utils.TextStyle import DebugStyle, InfoStyle, LevelStyle, MainStatStyle, clear


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

    def __init__(self, regionKey, weightsKeys, fourstars=False, hsr=False, debug=False):
        self.fourstars = fourstars
        self.hsr = hsr
        self.debug = debug
        self.lastocr = ""
        self.presenting = None
        self.regionPrfl: RegionsPrfl = RegionsPrfls[regionKey]
        # self.weightsPrfls: List[WeightsPrfl] = [
        #     wp for wp in WeightsPrfls.values() if any([key.upper() in wp.key.upper() for key in weightsKeys])
        # ]
        self.weightsPrfls: List[WeightsPrflBase] = [
            wp.plus(next((key.count("+") for key in reversed(weightsKeys) if key.rstrip("+").upper() in wp.key.upper()), 0))
            for wp in weights_prfls().values()
            if any([key.rstrip("+").upper() in wp.key.upper() for key in weightsKeys])
        ]

        self.request = Vision.VNRecognizeTextRequest.alloc().init()
        self.request.setRecognitionLanguages_(["zh-TW", "en"] if not hsr else ["zh-TW"])
        self.request.setRecognitionLevel_(Vision.VNRequestTextRecognitionLevelAccurate)

    def screenshot(self):
        shot = ImageGrab.grab(bbox=self.regionPrfl.full)
        return shot

    def debugimg(self, img):
        if self.debug:
            img = np.array(img)
            cv2.imshow("ArtifactsParser", cv2.cvtColor(img, cv2.COLOR_RGB2BGR))
            cv2.waitKey(0)
            cv2.destroyAllWindows()

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
            responses = self.request.results()
            res = "\n".join([res.topCandidates_(1)[0].string() for res in responses])
            # zhTW to en
            for stat in stats_list():
                res = res.replace(stat.zhTW, stat.key.strip("%"))
            res = res.replace("＋", "+")
            res = res.replace("生之花", "Flower of Life")
            res = res.replace("死之羽", "Plume of Death")
            res = res.replace("時之沙", "Sands of Eon")
            res = res.replace("空之杯", "Goblet of Eonothem")
            res = res.replace("理之冠", "Circlet of Logos")
            # Corner Case
            res = res.replace("AT+", "ATK+")
            res = res.replace("Bonu:", "Bonus")
            res = res.replace("CRIT DG", "CRIT DMG")
            res = res.replace(",", "")
            res = res.replace(chr(1040), chr(65))  # А -> A
            # 6 vs. 9
            only69 = lambda s: "".join(filter(str.isdigit, s)) in ["6", "9"]
            if only69(res):
                bbox = [observation.boundingBox() for observation in responses if only69(observation.topCandidates_(1)[0].string())][0]
                bbox = (
                    int((target[2] - target[0]) * bbox.origin.x),
                    int((target[3] - target[1]) * (1.0 - bbox.origin.y - bbox.size.height)),
                    int((target[2] - target[0]) * bbox.size.width),
                    int((target[3] - target[1]) * bbox.size.height)
                ) if "+" not in res else (
                    int((target[2] - target[0]) * (bbox.origin.x + bbox.size.width * 0.5)),
                    int((target[3] - target[1]) * (1.0 - bbox.origin.y - bbox.size.height)),
                    int((target[2] - target[0]) * bbox.size.width * 0.5),
                    int((target[3] - target[1]) * bbox.size.height)
                )
                bbox = (target[0] + bbox[0], target[1] + bbox[1], target[0] + bbox[0] + bbox[2], target[1] + bbox[1] + bbox[3])
                with BytesIO() as dummy_io:
                    region = tuple(bbox[i] - self.regionPrfl.full[i & 1] for i in range(4))
                    img.crop(region).save(dummy_io, format="PNG")
                    iimg = cv2.imdecode(np.frombuffer(dummy_io.getvalue(), np.uint8), cv2.IMREAD_GRAYSCALE)
                _, iimg = cv2.threshold(iimg, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
                cols = np.where(np.any(iimg > 0, axis=0))[0]
                iimg = iimg[:, cols[0]:cols[-1] + 1]
                mid = iimg.shape[1] * 1 // 2
                self.debugimg(iimg[:, :mid])
                self.debugimg(iimg[:, -mid:])
                lhs = cv2.countNonZero(iimg[:, :mid])
                rhs = cv2.countNonZero(iimg[:, -mid:])
                if lhs > rhs:
                    res = res.replace("9", "6")
                else:
                    res = res.replace("6", "9")
            self.lastocr = res
            return res
        else:
            raise RuntimeError("Error performing OCR")

    def put_stat(self, key: str, value: str, stats_vec: np.array, isMainStat: bool = False):
        validated = np.array([one if stat.validate(key, value) else zero for stat in stats_list()], dtype=np.double)
        if np.sum(validated) == 0:
            raise ValueError(f"No stat match found for: ({key}: {value})")
        elif np.sum(validated) > 1:
            raise ValueError(f"Multiple stats matches found for: ({key}: {value})")
        elif np.fabs(stats_vec @ validated) > eps:
            raise ValueError(f"Redundant stat match found for: ({key}: {value})")

        standardized_value = -inf if isMainStat else self.get_double(value)

        self.debugtext("%s : %.2f" % (stats_list()[np.where(validated > one - eps)[0].flat[0]].key, standardized_value))

        if self.fourstars:
            stats_vec += validated * standardized_value * stats_hit() / fourCoe
        else:
            stats_vec += validated * standardized_value * stats_hit()

    def summarize(self, organic_vec: np.array, levCur: int, expVec: np.array = None):
        if expVec is None:
            expVec = np.zeros(stats_num(), dtype=np.double)

        stats_vec = np.copy(organic_vec)

        if np.sum(expVec) > eps:
            stats_vec = organic_vec - SubStatsAdder.toExsists(organic_vec) * oneIncCoeExp + expVec * oneIncCoeExp

        main_key = stats_list()[np.where(stats_vec < -one)[0].flat[0]].key
        MainStatStyle.println(main_key)

        LevelStyle.println("+%d" % levCur)
        iterNum = (4 if self.fourstars else 5) - levCur

        for i in range(stats_num()):
            if stats_vec[i] < np.double(0.65):
                continue
            if self.fourstars:
                stats_list()[i].println(stats_vec[i] * fourCoe)
            else:
                stats_list()[i].println(stats_vec[i])

        InfoStyle.println("v" * 32)

        for wPrfl in self.weightsPrfls:
            wPrfl.println(stats_vec, iterNum)

        InfoStyle.println(">" * 64)

    def tailing(self, text):
        for tail in TailKWs:
            if tail in text:
                return True
        return False

    def understanding(self, img):
        self.debugimg(img)
        stats_vec = np.zeros(stats_num(), dtype=np.double)

        if not self.regionPrfl.single:
            # Main Stats
            main_key = self.ocr(img, self.regionPrfl.main_key)
            main_val = self.ocr(img, self.regionPrfl.main_val)
            self.put_stat(main_key, main_val, stats_vec, True)
            levMax = 4 if self.fourstars else 5
            # Level
            levCur4Str = self.ocr(img, self.regionPrfl.level)
            levCur = self.get_int(levCur4Str) // (4 if not self.hsr else 3)
            # Sub Stats
            for substat in self.regionPrfl.substats:
                sub_key, sub_value = None, None
                if len(substat) == 4:
                    sub_kv = self.ocr(img, substat)
                    if self.tailing(sub_kv):
                        break
                    sub_key, sub_value = None, None
                    try:
                        sub_key, sub_value = sub_kv.split("+")
                    except ValueError:
                        raise ValueError(f"Bad SubStat: {sub_kv}")
                else:
                    sub_key = self.ocr(img, substat[:2] + substat[4:5] + substat[3:4])
                    sub_value = self.ocr(img, substat[4:5] + substat[1:4]).strip(" +")
                    if sub_key == "" and sub_value == "":
                        break
                    elif sub_key == "SPD" and sub_value == "":
                        # lef = (substat[2] + substat[4]) // 2
                        # sub_value = self.ocr(img, (lef,) + substat[1:4]).strip(" +")
                        sub_value = "5"
                self.put_stat(sub_key, sub_value, stats_vec)
        else:
            sub_num = 0
            contents = self.ocr(img).split("\n")[::-1]
            it = iter(contents)
            row = next(it)
            while "Piece Set" in row or "•" not in row:
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
            if "Flower of Life" in main_key and "HP" in main_val:
                main_key, main_val = "HP", "9999"
            elif "Plume of Death" in main_key and "ATK" in main_val:
                main_key, main_val = "ATK", "9999"
            elif "Sands of Eon" in main_key and "Energy Recharge" in main_val:
                main_key, main_val = "Energy Recharge", "99.99%"
            elif "Sands of Eon" in main_key and "Elemental Mastery" in main_val:
                main_key, main_val = "Elemental Mastery", "9999"
            elif "Sands of Eon" in main_key and "ATK" in main_val:
                main_key, main_val = "ATK", "99.99%"
            elif "Sands of Eon" in main_key and "HP" in main_val:
                main_key, main_val = "HP", "99.99%"
            elif "Sands of Eon" in main_key and "DEF" in main_val:
                main_key, main_val = "DEF", "99.99%"
            elif "Goblet of Eonothem" in main_key and "Elemental Mastery" in main_val:
                main_key, main_val = "Elemental Mastery", "9999"
            elif "Goblet of Eonothem" in main_key and "ATK" in main_val:
                main_key, main_val = "ATK", "99.99%"
            elif "Goblet of Eonothem" in main_key and "HP" in main_val:
                main_key, main_val = "HP", "99.99%"
            elif "Goblet of Eonothem" in main_key and "DEF" in main_val:
                main_key, main_val = "DEF", "99.99%"
            elif "Goblet of Eonothem" in main_key and "DMG Bonus" in main_val:
                main_key, main_val = "DMG Bonus", "99.99%"
            elif "Circlet of Logos" in main_key and "CRIT Rate" in main_val:
                main_key, main_val = "CRIT Rate", "99.99%"
            elif "Circlet of Logos" in main_key and "CRIT DMG" in main_val:
                main_key, main_val = "CRIT DMG", "99.99%"
            elif "Circlet of Logos" in main_key and "Elemental Mastery" in main_val:
                main_key, main_val = "Elemental Mastery", "9999"
            elif "Circlet of Logos" in main_key and "ATK" in main_val:
                main_key, main_val = "ATK", "99.99%"
            elif "Circlet of Logos" in main_key and "HP" in main_val:
                main_key, main_val = "HP", "99.99%"
            elif "Circlet of Logos" in main_key and "DEF" in main_val:
                main_key, main_val = "DEF", "99.99%"
            elif "Circlet of Logos" in main_key and "Healing Bonus" in main_val:
                main_key, main_val = "Healing Bonus", "99.99%"
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
        clear()
        while True:
            try:
                img = self.screenshot()
                self.understanding(img)
            except Exception as e:
                DebugStyle.println("\n".join([str(e), "********HEAD********", self.lastocr, "********TAIL********"]), dynamic=True)
                sleep(0.1)
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
    argument_parser.add_argument("--hsr", action="store_true")
    args = argument_parser.parse_args()

    if args.hsr:
        Utils.Stats_HSR.override()
        Profiles.WeightsPrfl_HSR.override()

    artifacts_parser = ArtifactsParser(
        regionKey=args.region.upper(), fourstars=args.fourstars, weightsKeys=args.weights, hsr=args.hsr, debug=args.debug
    )
    artifacts_parser.start()


if __name__ == "__main__":
    main()
