import os
import sys
from typing import List

import numpy as np

from Utils.Constants import eps, one, oneIncCoeExp, onePCT, zero
from Utils.Stats import (ATK, ATK_PCT, CRIT_DMG, CRIT_RATE, DEF, DEF_PCT, DMG_BONUS, ELEMENTAL_MASTERY, ENERGY_RECHARGE, HEALING_BONUS, HP,
                         HP_PCT, StatInfo, Stats)
from Utils.TextStyle import TextStyle


class WeightsPrfl:
    PassStyle = TextStyle("white", "on_green", ["bold"])

    def __init__(
        self,
        key: str,
        baseATK: np.double,
        baseHP: np.double,
        baseDEF: np.double,
        allowMainStatList: List[StatInfo],
        CRIT_RATE: StatInfo,
        CRIT_DMG: StatInfo,
        ENERGY_RECHARGE: StatInfo,
        ELEMENTAL_MASTERY: StatInfo,
        ATK_PCT: StatInfo,
        HP_PCT: StatInfo,
        DEF_PCT: StatInfo,
        textStyle: TextStyle,
        threshold: np.double,
        legendary: bool = False,
        normalized: bool = True,
    ):
        mainStatMapKeyWeight = {stat.key: stat.weight for stat in allowMainStatList}
        stats: List[StatInfo] = [
            CRIT_RATE,
            CRIT_DMG,
            ENERGY_RECHARGE,
            ELEMENTAL_MASTERY,
            ATK_PCT,
            HP_PCT,
            DEF_PCT,
            ATK.setWeight(ATK_PCT.weight * ATK.onceIncrementMax / (ATK_PCT.onceIncrementMax * onePCT * baseATK)),
            HP.setWeight(HP_PCT.weight * HP.onceIncrementMax / (HP_PCT.onceIncrementMax * onePCT * baseHP)),
            DEF.setWeight(DEF_PCT.weight * DEF.onceIncrementMax / (DEF_PCT.onceIncrementMax * onePCT * baseDEF)),
            DMG_BONUS,
            HEALING_BONUS,
        ]
        self.key = key
        self.mainWeightsVec = np.array([mainStatMapKeyWeight.get(s.key, -one) + one for s in Stats], dtype=np.double)
        self.weightsVec = np.array([s.weight for s in stats], dtype=np.double)
        if not normalized:
            self.weightsVec /= np.max(self.weightsVec)
        self.textStyle = textStyle
        self.legendary = legendary
        self.threshold = threshold

    def println(self, stats_vec: np.array, iterNum: int = None):
        base = (stats_vec < -one).astype(np.double) @ self.mainWeightsVec
        if base < one - eps:
            return
        vec = stats_vec * (stats_vec > -eps).astype(np.double)
        res = vec @ self.weightsVec
        self.textStyle.print(f"{self.key}: {res:.2f}    ")
        if base + res - one > self.threshold - np.double(0.01):
            WeightsPrfl.PassStyle.print("Ｏ")
        if self.legendary and iterNum and iterNum > 0:
            candidates = (stats_vec > eps).astype(np.double)
            if abs(candidates.sum() - 4) < eps:
                preferred = (candidates * self.weightsVec).max() * iterNum * oneIncCoeExp
                if base + res + preferred - one > self.threshold - np.double(0.01):
                    WeightsPrfl.PassStyle.print("？")
        self.textStyle.println("")


CritScorePrfl: WeightsPrfl = WeightsPrfl(
    key="Crit Score",
    baseATK=np.double(945.24),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE,
        ELEMENTAL_MASTERY,
        ATK_PCT,
        HP_PCT,
        DEF_PCT,
        DMG_BONUS,
        CRIT_RATE,
        CRIT_DMG,
        HEALING_BONUS,
    ],
    CRIT_RATE=CRIT_RATE.setWeight(CRIT_RATE.onceIncrementMax * np.double(2)),
    CRIT_DMG=CRIT_RATE.setWeight(CRIT_DMG.onceIncrementMax),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0)),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0)),
    ATK_PCT=ATK_PCT.setWeight(np.double(0)),
    HP_PCT=HP_PCT.setWeight(np.double(0)),
    DEF_PCT=DEF_PCT.setWeight(np.double(0)),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
    threshold=np.double(100),
)

CritCountPrfl: WeightsPrfl = WeightsPrfl(
    key="Crit Count",
    baseATK=np.double(945.24),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        ATK_PCT,
        HP_PCT,
        DEF_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(2)),
        CRIT_DMG.setWeight(np.double(2)),
        HEALING_BONUS.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
    threshold=np.double(4),
)

ATKCountPrfl: WeightsPrfl = WeightsPrfl(
    key="ATK Count",
    baseATK=np.double(945.24),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        ATK_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
        HEALING_BONUS.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(1) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(5),
)

HPCountPrfl: WeightsPrfl = WeightsPrfl(
    key="HP Count",
    baseATK=np.double(945.24),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
        HEALING_BONUS.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(1) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(5),
)

DEFCountPrfl: WeightsPrfl = WeightsPrfl(
    key="DEF Count",
    baseATK=np.double(945.24),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DEF_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
        HEALING_BONUS.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(1) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    threshold=np.double(5),
)

RaidenPrfl: WeightsPrfl = WeightsPrfl(
    key="Raiden Score",
    baseATK=np.double(945.24),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
    threshold=np.double(5.8),
    legendary=True,
)

XianglingPrfl: WeightsPrfl = WeightsPrfl(
    key="Xiangling Score",
    baseATK=np.double(735.14),  # Xiangling + "The Catch"
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(5.8),
    legendary=True,
)

YelanPrfl: WeightsPrfl = WeightsPrfl(
    key="Yelan Score",
    baseATK=np.double(945.24),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(14450.17),  # Yelan
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(5.8),
    legendary=True,
)

ChioriPrfl: WeightsPrfl = WeightsPrfl(
    key="Chiori Score",
    baseATK=np.double(244.26) + np.double(510),  # Chiori + The Stringless
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(953.01),  # Chiori
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DEF_PCT,
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
    threshold=np.double(5.8),
    legendary=True,
)

ShinobuPrfl: WeightsPrfl = WeightsPrfl(
    key="Shinobu Count",
    baseATK=np.double(212.40) + np.double(510),  # Shinobu + Xiphos' Moonlight
    baseHP=np.double(12288.65),  # Shinobu
    baseDEF=np.double(750.77),  # Shinobu
    allowMainStatList=[
        HP,
        ATK,
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(1) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
    threshold=np.double(5),
)

NahidaPrfl: WeightsPrfl = WeightsPrfl(
    key="Nahida Count",
    baseATK=np.double(298.97) + np.double(542),  # Nahida + A Thousand Floating Dreams
    baseHP=np.double(10360.04),  # Nahida
    baseDEF=np.double(630.21),  # Nahida
    allowMainStatList=[
        HP,
        ATK,
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_green", "on_black", ["bold"]),
    threshold=np.double(5),
)

KiraraPrfl: WeightsPrfl = WeightsPrfl(
    key="Kirara Count",
    baseATK=np.double(223.02) + np.double(454),  # Kirara + Favonius Sword
    baseHP=np.double(12179.90),  # Kirara
    baseDEF=np.double(546.02),  # Kirara
    allowMainStatList=[
        HP,
        ATK,
        HP_PCT.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(1) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_green", "on_black", ["bold"]),
    threshold=np.double(4),
)

BennettPrfl: WeightsPrfl = WeightsPrfl(
    key="Bennett Count",
    baseATK=np.double(191.16) + np.double(454),  # Bennett + Favonius Sword
    baseHP=np.double(12397.40),  # Bennett
    baseDEF=np.double(771.25),  # Bennett
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        HEALING_BONUS,
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(1) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_green", "on_black", ["bold"]),
    threshold=np.double(4),
)

XilonenPrfl: WeightsPrfl = WeightsPrfl(
    key="Xilonen Count",
    baseATK=np.double(275) + np.double(454),  # Xilonen + Favonius Sword
    baseHP=np.double(12405),  # Xilonen
    baseDEF=np.double(930),  # Xilonen
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DEF_PCT.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        HEALING_BONUS,
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(1) / oneIncCoeExp),
    textStyle=TextStyle("light_green", "on_black", ["bold"]),
    threshold=np.double(4),
)

WeightsPrfls = {
    CritScorePrfl.key: CritScorePrfl,
    CritCountPrfl.key: CritCountPrfl,
    ATKCountPrfl.key: ATKCountPrfl,
    HPCountPrfl.key: HPCountPrfl,
    DEFCountPrfl.key: DEFCountPrfl,
    RaidenPrfl.key: RaidenPrfl,
    XianglingPrfl.key: XianglingPrfl,
    YelanPrfl.key: YelanPrfl,
    ChioriPrfl.key: ChioriPrfl,
    ShinobuPrfl.key: ShinobuPrfl,
    NahidaPrfl.key: NahidaPrfl,
    KiraraPrfl.key: KiraraPrfl,
    BennettPrfl.key: BennettPrfl,
    XilonenPrfl.key: XilonenPrfl,
}
