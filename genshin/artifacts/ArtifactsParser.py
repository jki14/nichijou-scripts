import os
import re
from argparse import ArgumentParser
from inspect import signature
from time import sleep

from colorama import just_fix_windows_console
from cv2 import COLOR_RGB2BGR, cvtColor, destroyAllWindows, imshow, waitKey
from numpy import array, double
from PIL import ImageGrab
from pytesseract import image_to_string, pytesseract
from termcolor import cprint

pytesseract.tesseract_cmd = r"D:\\Applications\\Tesseract-OCR\\tesseract.exe"


class NAMES:
    CRIT_RATE = "CRIT Rate"
    CRIT_DMG = "CRIT DMG"
    ENERGY_RECHARGE = "Energy Recharge"
    ELEMENTAL_MASTERY = "Elemental Mastery"
    ATK_PCT = "ATK%"
    HP_PCT = "HP%"
    DEF_PCT = "DEF%"
    ATK = "ATK"
    HP = "HP"
    DEF = "DEF"
    TAILS = [
        "Sojourner",
        "Miracle",
        "serker",
        "structor",
        "Exile",
        "Will",
        "holar",
        "Finale",
        "Troupe",
        "Oblige",
        "Beloved",
        "Venerer",
        "Petra",
        "Millelith",
        "Reminiscence",
        "Fate",
        "Memories",
        "Dreams",
        "Lost",
        "Glow",
        "Hunter",
        "Troupe",
        "Past",
        "Whispers",
        "Whimsy",
        "Reverie",
    ]
    PCT = "%"
    DMG_BONUS = "DMG Bonus"
    HEALING_BONUS = "Healing Bonus"


class text_format:
    def __init__(self, color, highlight, attrs):
        self.color = color
        self.highlight = highlight
        self.attrs = attrs

    def print(self, text):
        cprint(text, self.color, self.highlight, attrs=self.attrs)


class STYLES:
    CRIT_RATE = text_format("yellow", "on_black", ["bold"])
    CRIT_DMG = text_format("yellow", "on_black", ["bold"])
    ENERGY_RECHARGE = text_format("light_magenta", "on_black", ["bold"])
    ELEMENTAL_MASTERY = text_format("light_magenta", "on_black", ["bold"])
    ATK_PCT = text_format("light_blue", "on_black", ["bold"])
    HP_PCT = text_format("light_blue", "on_black", ["bold"])
    DEF_PCT = text_format("dark_grey", "on_black", [])
    ATK = text_format("green", "on_black", [])
    HP = text_format("green", "on_black", [])
    DEF = text_format("dark_grey", "on_black", [])
    DEBUG = text_format("yellow", "on_dark_grey", ["bold"])
    INFO = text_format("blue", "on_dark_grey", ["bold"])
    MESSAGE = text_format("white", "on_black", [])
    MAIN = text_format("red", "on_black", ["bold"])
    LEVEL = text_format("white", "on_black", ["bold"])


class BASES:
    ATK = double("945.24")  # Raiden Shogun + Engulfing Lightning
    # HP = double('14695.09')  # Neuvillette
    HP = double("15307.39")  # Furina
    DEF = double("798.55")  # Noelle


class HITS:
    CRIT_RATE = double("3.89")
    CRIT_DMG = double("7.77")
    ENERGY_RECHARGE = double("6.48")
    ELEMENTAL_MASTERY = double("23.31")
    ATK_PCT = double("5.83")
    HP_PCT = double("5.83")
    DEF_PCT = double("7.29")


class ATK_WEIGHTS:
    CRIT_RATE = double("1.00")
    CRIT_DMG = double("1.00")
    ENERGY_RECHARGE = double("1.00")
    ELEMENTAL_MASTERY = double("1.00")
    ATK_PCT = double("1.00")
    HP_PCT = double("0.00")
    DEF_PCT = double("0.00")


class HP_WEIGHTS:
    CRIT_RATE = double("1.00")
    CRIT_DMG = double("1.00")
    ENERGY_RECHARGE = double("1.00")
    ELEMENTAL_MASTERY = double("0.00")
    ATK_PCT = double("0.00")
    HP_PCT = double("1.00")
    DEF_PCT = double("0.00")


class DEF_WEIGHTS:
    CRIT_RATE = double("1.00")
    CRIT_DMG = double("1.00")
    ENERGY_RECHARGE = double("1.00")
    ELEMENTAL_MASTERY = double("0.00")
    ATK_PCT = double("0.00")
    HP_PCT = double("0.00")
    DEF_PCT = double("1.00")


class regions:
    # shot = (2700, 280, 3300, 660) # Char Artifacts Page, Keyboard
    shot = (2540, 360, 3160, 840)
    main_key = (2540, 360, 2880, 400)
    main_val = (2540, 400, 2760, 460)
    stars = (2540, 460, 2800, 520)
    level = (2570, 574, 2638, 606)
    subs = [(2586, 640, 3160, 690), (2586, 690, 3160, 740), (2586, 740, 3160, 790), (2586, 790, 3160, 840)]


class ArtifactsParser:
    rep_numeric = re.compile(r"[0-9]+[.,]{0,1}[0-9]*")

    def get_double(self, text):
        res = ArtifactsParser.rep_numeric.findall(text)
        if len(res) != 1:
            return None
        return double(res[0])

    def get_int(self, text):
        res = ArtifactsParser.rep_numeric.findall(text)
        if len(res) != 1:
            return None
        return int(res[0])

    def screenshot(self):
        shot = ImageGrab.grab(bbox=regions.shot)  # get RGB screenshot
        shot_np = array(shot)
        return shot_np

    def __init__(self, debug=False):
        self.debug = debug
        self.presenting = None

    def debugimg(self, img):
        if self.debug:
            imshow("ArtifactsParser", cvtColor(img, COLOR_RGB2BGR))
            waitKey(0)
            destroyAllWindows()

    def debugtext(self, text):
        if self.debug:
            STYLES.DEBUG.print(text)

    def subregion(self, img, base, target):
        subimg = img[target[1] - base[1] : target[3] - base[1], target[0] - base[0] : target[2] - base[0]]
        self.debugimg(subimg)
        text = image_to_string(subimg, config="--oem 3 --psm 7").strip()
        self.debugtext(text)
        return text

    def put_stat(self, key, value, statmap, value_override=None):
        if NAMES.PCT not in value:
            value = value.replace(".", "")

        standardized_key, standardized_value = None, None
        if NAMES.DMG_BONUS in key:
            standardized_key = NAMES.DMG_BONUS
        elif NAMES.HEALING_BONUS in key:
            standardized_key = NAMES.HEALING_BONUS
        elif NAMES.CRIT_RATE in key:
            standardized_key = NAMES.CRIT_RATE
        elif NAMES.CRIT_DMG in key:
            standardized_key = NAMES.CRIT_DMG
        elif NAMES.ENERGY_RECHARGE in key:
            standardized_key = NAMES.ENERGY_RECHARGE
        elif NAMES.ELEMENTAL_MASTERY in key:
            standardized_key = NAMES.ELEMENTAL_MASTERY
        elif NAMES.ATK in key:
            standardized_key = NAMES.ATK_PCT if NAMES.PCT in value else NAMES.ATK
        elif NAMES.HP in key:
            standardized_key = NAMES.HP_PCT if NAMES.PCT in value else NAMES.HP
        elif NAMES.DEF in key:
            standardized_key = NAMES.DEF_PCT if NAMES.PCT in value else NAMES.DEF
        standardized_value = value_override if value_override is not None else self.get_double(value)

        if standardized_key is None:
            raise ValueError("null standardized_key found for: %s" % key)
        if standardized_key in statmap:
            raise ValueError("duplicate key %s found for: %s" % (standardized_key, key))
        if standardized_value is None:
            raise ValueError("null standardized_value found for: %s" % value)

        self.debugtext("%s : %.2f" % (standardized_key, standardized_value))
        statmap[standardized_key] = standardized_value

    def summarize(self, stats, level):
        statmap = dict(stats)

        if not self.debug:
            os.system("cls")

        main_key = None
        for key in statmap:
            if statmap[key] < 1e-9:
                main_key = key
                break
        STYLES.MAIN.print(main_key)
        statmap.pop(main_key)

        STYLES.LEVEL.print("+%d" % level)

        if NAMES.ATK in statmap:
            if NAMES.ATK_PCT not in statmap:
                statmap[NAMES.ATK_PCT] = double("0.0")
            statmap[NAMES.ATK_PCT] += statmap[NAMES.ATK] / BASES.ATK * double("100.0")
            statmap.pop(NAMES.ATK)
        if NAMES.HP in statmap:
            if NAMES.HP_PCT not in statmap:
                statmap[NAMES.HP_PCT] = double("0.0")
            statmap[NAMES.HP_PCT] += statmap[NAMES.HP] / BASES.HP * double("100.0")
        if NAMES.DEF in statmap:
            if NAMES.DEF_PCT not in statmap:
                statmap[NAMES.DEF_PCT] = double("0.0")
            statmap[NAMES.DEF_PCT] += statmap[NAMES.DEF] / BASES.DEF * double("100.0")
            statmap.pop(NAMES.DEF)

        if NAMES.CRIT_RATE in statmap:
            STYLES.CRIT_RATE.print("%s: %.2f" % (NAMES.CRIT_RATE, statmap[NAMES.CRIT_RATE]))
        if NAMES.CRIT_DMG in statmap:
            STYLES.CRIT_DMG.print("%s: %.2f" % (NAMES.CRIT_DMG, statmap[NAMES.CRIT_DMG]))
        if NAMES.ENERGY_RECHARGE in statmap:
            STYLES.ENERGY_RECHARGE.print("%s: %.2f" % (NAMES.ENERGY_RECHARGE, statmap[NAMES.ENERGY_RECHARGE]))
        if NAMES.ELEMENTAL_MASTERY in statmap:
            STYLES.ELEMENTAL_MASTERY.print("%s: %.2f" % (NAMES.ELEMENTAL_MASTERY, statmap[NAMES.ELEMENTAL_MASTERY]))
        if NAMES.ATK_PCT in statmap:
            STYLES.ATK_PCT.print("%s: %.2f" % (NAMES.ATK_PCT, statmap[NAMES.ATK_PCT]))
        if NAMES.HP_PCT in statmap:
            STYLES.HP_PCT.print("%s: %.2f" % (NAMES.HP_PCT, statmap[NAMES.HP_PCT]))
        if NAMES.DEF_PCT in statmap:
            STYLES.DEF_PCT.print("%s: %.2f" % (NAMES.DEF_PCT, statmap[NAMES.DEF_PCT]))

        for i in range(len(stats), 5):
            STYLES.INFO.print(" " * 16)

        STYLES.MESSAGE.print("=" * 32)

        crit_score = statmap[NAMES.CRIT_RATE] if NAMES.CRIT_RATE in statmap else double("0.0")
        crit_score *= double("2.0")
        crit_score += statmap[NAMES.CRIT_DMG] if NAMES.CRIT_DMG in statmap else double("0.0")
        STYLES.CRIT_RATE.print(
            "CRIT SCORE: %.2f (%.2f hits)" % (crit_score, crit_score / (HITS.CRIT_DMG * double("0.85")))
        )

        atk_hits = (
            statmap.get(NAMES.CRIT_RATE, double("0.0")) / (HITS.CRIT_RATE * double("0.85")) * ATK_WEIGHTS.CRIT_RATE
        )
        atk_hits += statmap.get(NAMES.CRIT_DMG, double("0.0")) / (HITS.CRIT_DMG * double("0.85")) * ATK_WEIGHTS.CRIT_DMG
        atk_hits += (
            statmap.get(NAMES.ENERGY_RECHARGE, double("0.0"))
            / (HITS.ENERGY_RECHARGE * double("0.85"))
            * ATK_WEIGHTS.ENERGY_RECHARGE
        )
        atk_hits += (
            statmap.get(NAMES.ELEMENTAL_MASTERY, double("0.0"))
            / (HITS.ELEMENTAL_MASTERY * double("0.85"))
            * ATK_WEIGHTS.ELEMENTAL_MASTERY
        )
        atk_hits += statmap.get(NAMES.ATK_PCT, double("0.0")) / (HITS.ATK_PCT * double("0.85")) * ATK_WEIGHTS.ATK_PCT
        atk_hits += statmap.get(NAMES.HP_PCT, double("0.0")) / (HITS.HP_PCT * double("0.85")) * ATK_WEIGHTS.HP_PCT
        atk_hits += statmap.get(NAMES.DEF_PCT, double("0.0")) / (HITS.DEF_PCT * double("0.85")) * ATK_WEIGHTS.DEF_PCT
        STYLES.ATK_PCT.print("ATK HITs: %.2f" % atk_hits)

        hp_hits = statmap.get(NAMES.CRIT_RATE, double("0.0")) / (HITS.CRIT_RATE * double("0.85")) * HP_WEIGHTS.CRIT_RATE
        hp_hits += statmap.get(NAMES.CRIT_DMG, double("0.0")) / (HITS.CRIT_DMG * double("0.85")) * HP_WEIGHTS.CRIT_DMG
        hp_hits += (
            statmap.get(NAMES.ENERGY_RECHARGE, double("0.0"))
            / (HITS.ENERGY_RECHARGE * double("0.85"))
            * HP_WEIGHTS.ENERGY_RECHARGE
        )
        hp_hits += (
            statmap.get(NAMES.ELEMENTAL_MASTERY, double("0.0"))
            / (HITS.ELEMENTAL_MASTERY * double("0.85"))
            * HP_WEIGHTS.ELEMENTAL_MASTERY
        )
        hp_hits += statmap.get(NAMES.ATK_PCT, double("0.0")) / (HITS.ATK_PCT * double("0.85")) * HP_WEIGHTS.ATK_PCT
        hp_hits += statmap.get(NAMES.HP_PCT, double("0.0")) / (HITS.HP_PCT * double("0.85")) * HP_WEIGHTS.HP_PCT
        hp_hits += statmap.get(NAMES.DEF_PCT, double("0.0")) / (HITS.DEF_PCT * double("0.85")) * HP_WEIGHTS.DEF_PCT
        STYLES.HP_PCT.print("HP HITs: %.2f" % hp_hits)

        def_hits = (
            statmap.get(NAMES.CRIT_RATE, double("0.0")) / (HITS.CRIT_RATE * double("0.85")) * DEF_WEIGHTS.CRIT_RATE
        )
        def_hits += statmap.get(NAMES.CRIT_DMG, double("0.0")) / (HITS.CRIT_DMG * double("0.85")) * DEF_WEIGHTS.CRIT_DMG
        def_hits += (
            statmap.get(NAMES.ENERGY_RECHARGE, double("0.0"))
            / (HITS.ENERGY_RECHARGE * double("0.85"))
            * DEF_WEIGHTS.ENERGY_RECHARGE
        )
        def_hits += (
            statmap.get(NAMES.ELEMENTAL_MASTERY, double("0.0"))
            / (HITS.ELEMENTAL_MASTERY * double("0.85"))
            * DEF_WEIGHTS.ELEMENTAL_MASTERY
        )
        def_hits += statmap.get(NAMES.ATK_PCT, double("0.0")) / (HITS.ATK_PCT * double("0.85")) * DEF_WEIGHTS.ATK_PCT
        def_hits += statmap.get(NAMES.HP_PCT, double("0.0")) / (HITS.HP_PCT * double("0.85")) * DEF_WEIGHTS.HP_PCT
        def_hits += statmap.get(NAMES.DEF_PCT, double("0.0")) / (HITS.DEF_PCT * double("0.85")) * DEF_WEIGHTS.DEF_PCT
        STYLES.DEF_PCT.print("DEF HITs: %.2f" % def_hits)

    def tailing(self, text):
        for tail in NAMES.TAILS:
            if tail in text:
                return True
        return False

    def understanding(self, img):
        self.debugimg(img)
        statmap = {}
        # Main Stats
        main_key = self.subregion(img, regions.shot, regions.main_key)
        main_val = self.subregion(img, regions.shot, regions.main_val).replace(",", "")
        self.put_stat(main_key, main_val, statmap, value_override=double("0.0"))
        # TODO: Detect the number of stars
        self.subregion(img, regions.shot, regions.stars)
        # Level
        level_str = self.subregion(img, regions.shot, regions.level)
        level = self.get_int(level_str)
        # Sub Stats
        for sub in regions.subs:
            sub_kv = self.subregion(img, regions.shot, sub)
            if self.tailing(sub_kv):
                break
            sub_key, sub_value = None, None
            try:
                sub_key, sub_value = sub_kv.split("+")
            except ValueError:
                plust_pat = re.compile(r"t[0-9]+[.,]{0,1}[0-9]*")
                plust_sub = plust_pat.findall(sub_kv)[-1]
                before, after = sub_kv.split(plust_sub)
                fixed = before + plust_sub.replace("t", "+") + after
                sub_key, sub_value = fixed.split("+")
            self.put_stat(sub_key, sub_value, statmap)
        # Summarize Current
        processing = hash(frozenset(statmap.items()))
        if processing != self.presenting:
            self.summarize(statmap, level)
            self.presenting = processing

    def start(self):
        while True:
            img = self.screenshot()
            self.understanding(img)
            if self.debug:
                break
            sleep(0.100)


def main():
    just_fix_windows_console()

    argument_parser = ArgumentParser(description="Genshin Impact artifacts stat parser.")
    argument_parser.add_argument("--debug", action="store_true")
    args = argument_parser.parse_args()

    artifacts_parser = ArtifactsParser(debug=args.debug)
    artifacts_parser.start()


if __name__ == "__main__":
    main()
