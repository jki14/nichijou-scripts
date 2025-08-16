import copy
import os
import sys
from typing import List

import numpy as np

import Profiles.WeightsPrfl
from Profiles.WeightsPrfl import WeightsPrflBase
from Utils.Constants import eps, one, oneIncCoeExp, onePCT, zero
from Utils.Stats import StatInfo
from Utils.Stats_ZZZ import (ANOMALY_MASTERY, ANOMALY_PROFICIENCY, ATK, ATK_PCT, CRIT_DMG, CRIT_RATE, DEF, DEF_PCT, DMG_BONUS, ENERGY_REGEN,
                             HP, HP_PCT, IMPACT, PEN, PEN_RATIO, Stats)
from Utils.TextStyle import TextStyle


class ZWeightsPrfl(WeightsPrflBase):
    def __init__(
        self,
        key: str,
        baseATK: np.double,
        baseHP: np.double,
        baseDEF: np.double,
        allowMainStatList: List[StatInfo],
        HP_PCT: StatInfo,
        ATK_PCT: StatInfo,
        DEF_PCT: StatInfo,
        CRIT_RATE: StatInfo,
        CRIT_DMG: StatInfo,
        ANOMALY_PROFICIENCY: StatInfo,
        PEN: StatInfo,
        textStyle: TextStyle,
        threshold: np.double,
        misscount: int = 0,
        legendary: bool = False,
        normalized: bool = True,
    ):
        stats: List[StatInfo] = [
            HP.setWeight(HP_PCT.weight * HP.onceIncrementMax / (HP_PCT.onceIncrementMax * onePCT * baseHP)),
            ATK.setWeight(ATK_PCT.weight * ATK.onceIncrementMax / (ATK_PCT.onceIncrementMax * onePCT * baseATK)),
            DEF.setWeight(DEF_PCT.weight * DEF.onceIncrementMax / (DEF_PCT.onceIncrementMax * onePCT * baseDEF)),
            HP_PCT,
            ATK_PCT,
            DEF_PCT,
            CRIT_RATE,
            CRIT_DMG,
            ANOMALY_PROFICIENCY,
            PEN,
            PEN_RATIO,
            DMG_BONUS,
            ANOMALY_MASTERY,
            IMPACT,
            ENERGY_REGEN,
        ]
        super().__init__(
            key=key,
            baseATK=baseATK,
            baseHP=baseHP,
            baseDEF=baseDEF,
            allowMainStatList=allowMainStatList,
            statsWeighted=stats,
            statsAll=Stats,
            textStyle=textStyle,
            threshold=threshold,
            misscount=misscount,
            legendary=legendary,
            normalized=normalized,
        )


CritScorePrfl: ZWeightsPrfl = ZWeightsPrfl(
    key="Crit Score",
    baseATK=np.double(840) + np.double(684),  # Harumasa + The Brimstone
    baseHP=np.double(7405),  # Harumasa
    baseDEF=np.double(600),  # Harumasa
    allowMainStatList=[
        HP,
        ATK,
        DEF,
        ATK_PCT.setWeight(np.double(2)),
        CRIT_RATE.setWeight(np.double(2)),
        CRIT_DMG.setWeight(np.double(2)),
        PEN_RATIO.setWeight(np.double(2)),
        DMG_BONUS.setWeight(np.double(2)),
        IMPACT.setWeight(np.double(2)),
    ],
    HP_PCT=HP_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(1.0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_DMG.setWeight(np.double(1.0) / oneIncCoeExp),
    ANOMALY_PROFICIENCY=ANOMALY_PROFICIENCY.setWeight(np.double(0.0) / oneIncCoeExp),
    PEN=PEN.setWeight(np.double(0.34) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

AnomalyScorePrfl: ZWeightsPrfl = ZWeightsPrfl(
    key="Anomaly Score",
    baseATK=np.double(805) + np.double(713),  # Vivian + Flight of Fancy
    baseHP=np.double(7673),  # Vivian
    baseDEF=np.double(606),  # Vivian
    allowMainStatList=[
        HP,
        ATK,
        DEF,
        ATK_PCT.setWeight(np.double(2)),
        ANOMALY_PROFICIENCY.setWeight(np.double(2)),
        PEN_RATIO.setWeight(np.double(2)),
        DMG_BONUS.setWeight(np.double(2)),
        ANOMALY_MASTERY.setWeight(np.double(2)),
        ENERGY_REGEN.setWeight(np.double(2)),
    ],
    HP_PCT=HP_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(1.0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_DMG.setWeight(np.double(0.0) / oneIncCoeExp),
    ANOMALY_PROFICIENCY=ANOMALY_PROFICIENCY.setWeight(np.double(1.0) / oneIncCoeExp),
    PEN=PEN.setWeight(np.double(0.34) / oneIncCoeExp),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
    threshold=np.double(5.0),
    legendary=True,
)

MiyabiScorePrfl: ZWeightsPrfl = ZWeightsPrfl(
    key="Miyabi Score",
    baseATK=np.double(805) + np.double(743),  # Miyabi + Hailstorm Shrine
    baseHP=np.double(7673),  # Miyabi
    baseDEF=np.double(606),  # Miyabi
    allowMainStatList=[
        HP,
        ATK,
        DEF,
        ATK_PCT.setWeight(np.double(2)),
        CRIT_RATE.setWeight(np.double(2)),
        CRIT_DMG.setWeight(np.double(2)),
        PEN_RATIO.setWeight(np.double(2)),
        DMG_BONUS.setWeight(np.double(2)),
    ],
    HP_PCT=HP_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(1.0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.0) / oneIncCoeExp),
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_DMG.setWeight(np.double(1.0) / oneIncCoeExp),
    ANOMALY_PROFICIENCY=ANOMALY_PROFICIENCY.setWeight(np.double(0.5) / oneIncCoeExp),
    PEN=PEN.setWeight(np.double(0.34) / oneIncCoeExp),
    textStyle=TextStyle("light_cyan", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

WeightsPrfls = {
    CritScorePrfl.key: CritScorePrfl,
    AnomalyScorePrfl.key: AnomalyScorePrfl,
    MiyabiScorePrfl.key: MiyabiScorePrfl,
}


def override():
    Profiles.WeightsPrfl.WeightsPrfls = WeightsPrfls
