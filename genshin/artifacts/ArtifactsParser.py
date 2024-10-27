import os
import re
from argparse import ArgumentParser
from time import sleep
from typing import List

import numpy as np
from colorama import just_fix_windows_console
from cv2 import COLOR_RGB2BGR, cvtColor, destroyAllWindows, imshow, waitKey
from PIL import ImageGrab
from pytesseract import image_to_string, pytesseract

from Profiles.RegionsPrfl import RegionsPrfl, RegionsPrfls
from Profiles.WeightsPrfl import WeightsPrfls
from SubStatsAdder import SubStatsAdder
from Utils.Constants import PCT, TailKWs, eps, fourCoe, inf, one, oneIncCoeExp, zero
from Utils.Stats import StatHitsVec, Stats, StatsN
from Utils.TextStyle import DebugStyle, InfoStyle, LevelStyle, MainStatStyle

# pytesseract.tesseract_cmd = r"D:\\Applications\\Tesseract-OCR\\tesseract.exe"
pytesseract.tesseract_cmd = "/opt/homebrew/bin/tesseract"


class ArtifactsParser:
    rep_numeric = re.compile(r"[0-9]+[.,]{0,1}[0-9]*")
    rep_plust = re.compile(r"t[0-9]+[.,]{0,1}[0-9]*")

    def get_double(self, text):
        res = ArtifactsParser.rep_numeric.findall(text.replace("..", "."))
        if len(res) != 1:
            raise ValueError(f"Failed to get double: {text}")
        return np.double(res[0])

    def get_int(self, text):
        res = ArtifactsParser.rep_numeric.findall(text.replace("..", "."))
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

    def screenshot(self):
        shot = ImageGrab.grab(bbox=self.regionPrfl.full)  # get RGB screenshot
        shot_np = np.array(shot)
        return shot_np

    def debugimg(self, img):
        if self.debug:
            imshow("ArtifactsParser", cvtColor(img, COLOR_RGB2BGR))
            waitKey(0)
            destroyAllWindows()

    def debugtext(self, text):
        if self.debug:
            DebugStyle.println(text)

    def ocr(self, img, target):
        subimg = img[
            target[1] - self.regionPrfl.full[1] : target[3] - self.regionPrfl.full[1],
            target[0] - self.regionPrfl.full[0] : target[2] - self.regionPrfl.full[0],
        ]
        self.debugimg(subimg)
        text = image_to_string(subimg, config="--oem 3 --psm 7").strip()
        self.debugtext(text)
        return text.replace(",", "")

    def put_stat(self, key: str, value: str, stats_vec: np.array, isMainStat: bool = False):
        if PCT not in value:
            value = value.replace(".", "")

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
        # Main Stats
        main_key = self.ocr(img, self.regionPrfl.main_key)
        main_key = main_key.replace("Bonu:", "Bonus")
        main_val = self.ocr(img, self.regionPrfl.main_val).replace(",", "")
        self.put_stat(main_key, main_val, stats_vec, True)
        # TODO: Detect the number of stars
        self.ocr(img, self.regionPrfl.stars)
        levMax = 4 if self.fourstars else 5
        # Level
        levCur4Str = self.ocr(img, self.regionPrfl.level)
        levCur4 = 0
        try:
            levCur4 = self.get_int(levCur4Str)
        except ValueError:
            levCur4 = self.get_int(levCur4Str.replace("+O", "+0").strip("."))
        levCur = levCur4 // 4
        # Sub Stats
        for substat in self.regionPrfl.substats:
            sub_kv = self.ocr(img, substat)
            if self.tailing(sub_kv):
                break
            sub_key, sub_value = None, None
            sub_kv = sub_kv.replace("DEFHI9", "DEF+19")
            try:
                sub_key, sub_value = sub_kv.split("+")
            except ValueError:
                plust_sub = None
                try:
                    plust_sub = ArtifactsParser.rep_plust.findall(sub_kv)[-1]
                except IndexError:
                    os.system("clear")
                    DebugStyle.println("Bad SubStat: %s" % sub_kv)
                    sleep(4.0)
                    return
                before, after = sub_kv.split(plust_sub)
                fixed = before + plust_sub.replace("t", "+") + after
                sub_key, sub_value = fixed.split("+")
            self.put_stat(sub_key, sub_value, stats_vec)
        # Summarize Current
        processing = hash(stats_vec.data.tobytes())
        if processing != self.presenting:
            if not self.debug:
                # os.system("cls")
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
                if not self.debug:
                    # os.system("cls")
                    os.system("clear")
                DebugStyle.println(e)
                sleep(2.0)
            if self.debug:
                break
            sleep(0.100)


def main():
    just_fix_windows_console()

    argument_parser = ArgumentParser(description="Genshin Impact artifacts stat parser.")
    argument_parser.add_argument("--debug", action="store_true")
    argument_parser.add_argument("--region", default="K3440X1440")
    argument_parser.add_argument("--fourstars", action="store_true")
    argument_parser.add_argument("--weights", action="extend", nargs="+")
    args = argument_parser.parse_args()

    artifacts_parser = ArtifactsParser(regionKey=args.region.upper(), fourstars=args.fourstars, weightsKeys=args.weights, debug=args.debug)
    artifacts_parser.start()


if __name__ == "__main__":
    main()
