import copy
import os
import sys
from typing import List

import numpy as np

import Profiles.WeightsPrfl
from Profiles.WeightsPrfl import WeightsPrflBase
from Utils.Constants import eps, one, oneIncCoeExp, onePCT, zero
from Utils.Stats import StatInfo
from Utils.Stats_HSR import (ATK, ATK_PCT, BREAK_EFFECT, CRIT_DMG, CRIT_RATE, DEF, DEF_PCT, DMG_BOOST, EFFECT_HIT, EFFECT_RES,
                             ENERGY_REGENERATION, HEALING_BOOST, HP, HP_PCT, SPD, Stats)
from Utils.TextStyle import TextStyle


class HWeightsPrfl(WeightsPrflBase):
    def __init__(
        self,
        key: str,
        baseATK: np.double,
        baseHP: np.double,
        baseDEF: np.double,
        allowMainStatList: List[StatInfo],
        SPD: StatInfo,
        HP_PCT: StatInfo,
        ATK_PCT: StatInfo,
        DEF_PCT: StatInfo,
        BREAK_EFFECT: StatInfo,
        EFFECT_HIT: StatInfo,
        EFFECT_RES: StatInfo,
        CRIT_RATE: StatInfo,
        CRIT_DMG: StatInfo,
        textStyle: TextStyle,
        threshold: np.double,
        legendary: bool = False,
        normalized: bool = True,
    ):
        stats: List[StatInfo] = [
            SPD,
            HP.setWeight(HP_PCT.weight * HP.onceIncrementMax / (HP_PCT.onceIncrementMax * onePCT * baseHP)),
            ATK.setWeight(ATK_PCT.weight * ATK.onceIncrementMax / (ATK_PCT.onceIncrementMax * onePCT * baseATK)),
            DEF.setWeight(DEF_PCT.weight * DEF.onceIncrementMax / (DEF_PCT.onceIncrementMax * onePCT * baseDEF)),
            HP_PCT,
            ATK_PCT,
            DEF_PCT,
            BREAK_EFFECT,
            EFFECT_HIT,
            EFFECT_RES,
            CRIT_RATE,
            CRIT_DMG,
            ENERGY_REGENERATION,
            HEALING_BOOST,
            DMG_BOOST,
        ]
        super().__init__(key, baseATK, baseHP, baseDEF, allowMainStatList, stats, Stats, textStyle, threshold, legendary, normalized)


FireflyScorePrfl: HWeightsPrfl = HWeightsPrfl(
    key="Firefly Break Score",
    baseATK=np.double(523.91) + np.double(529),  # Firefly + On the Fall of an Aeon
    baseHP=np.double(815) + np.double(1058),  # Firefly + On the Fall of an Aeon
    baseDEF=np.double(776.16) + np.double(396),  # Firefly + On the Fall of an Aeon
    allowMainStatList=[
        SPD.setWeight(np.double(1)),
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(1)),
        BREAK_EFFECT.setWeight(np.double(1)),
    ],
    SPD=SPD.setWeight(np.double(1.0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    BREAK_EFFECT=BREAK_EFFECT.setWeight(np.double(1.0) / oneIncCoeExp),
    EFFECT_HIT=EFFECT_HIT.setWeight(np.double(0.0) / oneIncCoeExp),
    EFFECT_RES=EFFECT_RES.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_DMG.setWeight(np.double(0.0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(5.0),
    legendary=True,
)

FugueScorePrfl: HWeightsPrfl = HWeightsPrfl(
    key="Fugue Break Score",
    baseATK=np.double(582.12) + np.double(529),  # Fugue + Solitary Healing
    baseHP=np.double(1125) + np.double(1058),  # Fugue + Solitary Healing
    baseDEF=np.double(557.87) + np.double(396),  # Fugue + Solitary Healing
    allowMainStatList=[
        SPD.setWeight(np.double(1)),
        HP,
        ATK,
        HP_PCT.setWeight(np.double(1)),
        DEF_PCT.setWeight(np.double(1)),
        BREAK_EFFECT.setWeight(np.double(1)),
        EFFECT_HIT.setWeight(np.double(1)),
        ENERGY_REGENERATION.setWeight(np.double(1)),
    ],
    SPD=SPD.setWeight(np.double(1.0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    BREAK_EFFECT=BREAK_EFFECT.setWeight(np.double(1.0) / oneIncCoeExp),
    EFFECT_HIT=EFFECT_HIT.setWeight(np.double(1.0) / oneIncCoeExp),
    EFFECT_RES=EFFECT_RES.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_DMG.setWeight(np.double(0.0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(5.0),
    legendary=True,
)

LingshaScorePrfl: HWeightsPrfl = HWeightsPrfl(
    key="Lingsha Break Score",
    baseATK=np.double(679.14) + np.double(423),  # Lingsha + Quid Pro Quo
    baseHP=np.double(1358) + np.double(952),  # Lingsha + Quid Pro Quo
    baseDEF=np.double(436.59) + np.double(396),  # Lingsha + Quid Pro Quo
    allowMainStatList=[
        SPD.setWeight(np.double(1)),
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(1)),
        BREAK_EFFECT.setWeight(np.double(1)),
        ENERGY_REGENERATION.setWeight(np.double(1)),
        HEALING_BOOST.setWeight(np.double(1)),
    ],
    SPD=SPD.setWeight(np.double(1.0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    BREAK_EFFECT=BREAK_EFFECT.setWeight(np.double(1.0) / oneIncCoeExp),
    EFFECT_HIT=EFFECT_HIT.setWeight(np.double(0.0) / oneIncCoeExp),
    EFFECT_RES=EFFECT_RES.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_DMG.setWeight(np.double(0.0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(5.0),
    legendary=True,
)

RuanmeiScorePrfl: HWeightsPrfl = HWeightsPrfl(
    key="Ruanmei Break Score",
    baseATK=np.double(659) + np.double(423),  # Ruanmei + Memories of the Past
    baseHP=np.double(1086) + np.double(952),  # Ruanmei + Memories of the Past
    baseDEF=np.double(485) + np.double(396),  # Ruanmei + Memories of the Past
    allowMainStatList=[
        SPD.setWeight(np.double(1)),
        HP,
        ATK,
        HP_PCT.setWeight(np.double(1)),
        DEF_PCT.setWeight(np.double(1)),
        BREAK_EFFECT.setWeight(np.double(1)),
        ENERGY_REGENERATION.setWeight(np.double(1)),
    ],
    SPD=SPD.setWeight(np.double(1.0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    BREAK_EFFECT=BREAK_EFFECT.setWeight(np.double(1.0) / oneIncCoeExp),
    EFFECT_HIT=EFFECT_HIT.setWeight(np.double(0.0) / oneIncCoeExp),
    EFFECT_RES=EFFECT_RES.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_DMG.setWeight(np.double(0.0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(5.0),
    legendary=True,
)

WeightsPrfls = {
    FireflyScorePrfl.key: FireflyScorePrfl,
    FugueScorePrfl.key: FugueScorePrfl,
    LingshaScorePrfl.key: LingshaScorePrfl,
    RuanmeiScorePrfl.key: RuanmeiScorePrfl,
}

def override():
    Profiles.WeightsPrfl.WeightsPrfls = WeightsPrfls
