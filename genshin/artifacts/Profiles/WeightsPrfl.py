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
    FailStyle = TextStyle("white", "on_red", ["bold"])

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
            preferred = res
            while candidates.sum() < 4 - eps and iterNum > 0:
                blocked = (stats_vec < -one).astype(np.double)
                top = np.argmax(((candidates + blocked) < eps) * self.weightsVec)
                candidates[top] = one
                preferred += self.weightsVec[top] * oneIncCoeExp
                iterNum -= 1
            preferred += (candidates * self.weightsVec).max() * iterNum * oneIncCoeExp
            if base + preferred - one > self.threshold - np.double(0.01):
                WeightsPrfl.PassStyle.print(f"{preferred:.2f}")
            else:
                WeightsPrfl.FailStyle.print(f"{preferred:.2f}")
        self.textStyle.println("")


CritScorePrfl: WeightsPrfl = WeightsPrfl(
    key="Crit Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
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
    threshold=np.double(33),
    legendary=True,
)

CritCountPrfl: WeightsPrfl = WeightsPrfl(
    key="Crit Count",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
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
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
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
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
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
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
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

MavuikaPrfl: WeightsPrfl = WeightsPrfl(
    key="Mavuika Obsidian Score",
    baseATK=np.double(558.77) + np.double(741),  # Mavuika + A Thousand Blazing Suns
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(1)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

GamingPrfl: WeightsPrfl = WeightsPrfl(
    key="Gaming Hunter Score",
    baseATK=np.double(301.60) + np.double(674),  # Gaming + Verdict
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(1)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
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
    threshold=np.double(6.0),
    legendary=True,
)

NeuvillettePrfl: WeightsPrfl = WeightsPrfl(
    key="Neuvillette Hunter Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(14695.09),  # Neuvillette
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(1)),
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
    threshold=np.double(6.0),
    legendary=True,
)

NoellePrfl: WeightsPrfl = WeightsPrfl(
    key="Noelle Hunter Score",
    baseATK=np.double(244.26) + np.double(510),  # Noelle + The Stringless
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DEF_PCT.setWeight(np.double(1)),
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
    threshold=np.double(6.0),
    legendary=True,
)

FischlPrfl: WeightsPrfl = WeightsPrfl(
    key="Fischl Troupe Score",
    baseATK=np.double(244.26) + np.double(510),  # Fischl + The String­les
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(1)),
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
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

FurinaPrfl: WeightsPrfl = WeightsPrfl(
    key="Furina Troupe Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(1)),
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
    threshold=np.double(6.0),
    legendary=True,
)

ChioriPrfl: WeightsPrfl = WeightsPrfl(
    key="Chiori Troupe Score",
    baseATK=np.double(244.26) + np.double(510),  # Chiori + The Stringless
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(953.01),  # Chiori
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DEF_PCT.setWeight(np.double(1)),
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
    threshold=np.double(6.0),
    legendary=True,
)

RaidenPrfl: WeightsPrfl = WeightsPrfl(
    key="Raiden Fate Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

XianglingPrfl: WeightsPrfl = WeightsPrfl(
    key="Xiangling Fate Score",
    baseATK=np.double(225.14) + np.double(510),  # Xiangling + "The Catch"
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(1)),
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
    threshold=np.double(6.0),
    legendary=True,
)

YelanPrfl: WeightsPrfl = WeightsPrfl(
    key="Yelan Fate Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(14450.17),  # Yelan
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(1)),
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
    threshold=np.double(6.0),
    legendary=True,
)

AyatoPrfl: WeightsPrfl = WeightsPrfl(
    key="Ayato Gladiator Score",
    baseATK=np.double(298.97) + np.double(510),  # Ayato + The Black Sword
    baseHP=np.double(13715.42),  # Ayato
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.3) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(7.0),
    legendary=True,
)

TighnariPrfl: WeightsPrfl = WeightsPrfl(
    key="Tighnari Wanderer Score",
    baseATK=np.double(267.88) + np.double(565),  # Tighnari + Scion of the Blazing Sun
    baseHP=np.double(10849.88),  # Tighnari
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(1)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    threshold=np.double(7.0),
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
    key="Nahida Deepwood Score",
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
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.6) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.4) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

ColleiPrfl: WeightsPrfl = WeightsPrfl(
    key="Collei Deepwood Score",
    baseATK=np.double(199.65) + np.double(454),  # Collei + Favonius Warbow
    baseHP=np.double(9787.42),  # Collei
    baseDEF=np.double(600.62),  # Collei
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(1)),
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
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
    baseATK=np.double(275.06) + np.double(454),  # Xilonen + Favonius Sword
    baseHP=np.double(12405.11),  # Xilonen
    baseDEF=np.double(929.95),  # Xilonen
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

CitlaliPrfl: WeightsPrfl = WeightsPrfl(
    key="Citlali Count",
    baseATK=np.double(126.76) + np.double(542),  # Citlali + Starcaller's Watch
    baseHP=np.double(11633.62),  # Citlali
    baseDEF=np.double(763.17),  # Citlali
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_green", "on_black", ["bold"]),
    threshold=np.double(4),
)

JeanPrfl: WeightsPrfl = WeightsPrfl(
    key="Jean Count",
    baseATK=np.double(239.18) + np.double(454),  # Jean + Favonius Sword
    baseHP=np.double(14695.09),  # Jean
    baseDEF=np.double(768.55),  # Jean
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        HEALING_BONUS,
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(1) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_green", "on_black", ["bold"]),
    threshold=np.double(4),
)

WeightsPrfls = {
    CritScorePrfl.key: CritScorePrfl,
    CritCountPrfl.key: CritCountPrfl,
    ATKCountPrfl.key: ATKCountPrfl,
    HPCountPrfl.key: HPCountPrfl,
    DEFCountPrfl.key: DEFCountPrfl,
    MavuikaPrfl.key: MavuikaPrfl,
    GamingPrfl.key: GamingPrfl,
    NeuvillettePrfl.key: NeuvillettePrfl,
    NoellePrfl.key: NoellePrfl,
    FischlPrfl.key: FischlPrfl,
    FurinaPrfl.key: FurinaPrfl,
    ChioriPrfl.key: ChioriPrfl,
    RaidenPrfl.key: RaidenPrfl,
    XianglingPrfl.key: XianglingPrfl,
    YelanPrfl.key: YelanPrfl,
    AyatoPrfl.key: AyatoPrfl,
    TighnariPrfl.key: TighnariPrfl,
    ShinobuPrfl.key: ShinobuPrfl,
    NahidaPrfl.key: NahidaPrfl,
    ColleiPrfl.key: ColleiPrfl,
    KiraraPrfl.key: KiraraPrfl,
    BennettPrfl.key: BennettPrfl,
    XilonenPrfl.key: XilonenPrfl,
    CitlaliPrfl.key: CitlaliPrfl,
    JeanPrfl.key: JeanPrfl,
}
