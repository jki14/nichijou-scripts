import copy
import os
import sys
from typing import List

import numpy as np

from Utils.Constants import eps, one, oneIncCoeExp, onePCT, zero
from Utils.Stats import (ATK, ATK_PCT, CRIT_DMG, CRIT_RATE, DEF, DEF_PCT, DMG_BONUS, ELEMENTAL_MASTERY, ENERGY_RECHARGE, HEALING_BONUS, HP,
                         HP_PCT, StatInfo, Stats)
from Utils.TextStyle import TextStyle


class WeightsPrflBase:
    PassStyle = TextStyle("white", "on_green", ["bold"])
    FailStyle = TextStyle("white", "on_red", ["bold"])

    def __init__(
        self,
        key: str,
        baseATK: np.double,
        baseHP: np.double,
        baseDEF: np.double,
        allowMainStatList: List[StatInfo],
        statsWeighted: List[StatInfo],
        statsAll: List[StatInfo],
        textStyle: TextStyle,
        threshold: np.double,
        legendary: bool = False,
        normalized: bool = True,
    ):
        mainStatMapKeyWeight = {stat.key: stat.weight for stat in allowMainStatList}
        self.key = key
        self.mainWeightsVec = np.array([mainStatMapKeyWeight.get(s.key, -one) + one for s in statsAll], dtype=np.double)
        self.weightsVec = np.array([s.weight for s in statsWeighted], dtype=np.double)
        if not normalized:
            self.weightsVec /= np.max(self.weightsVec)
        self.textStyle = textStyle
        self.legendary = legendary
        self.threshold = threshold

    def plus(self, plus_num: int) -> "WeightsPrflBase":
        cloned = copy.deepcopy(self)
        cloned.key += "+" * plus_num
        cloned.key += "-" * -plus_num
        cloned.threshold += 0.5 * plus_num
        return cloned

    def println(self, stats_vec: np.array, iterNum: int = None):
        base = (stats_vec < -one).astype(np.double) @ self.mainWeightsVec
        if base < one - eps:
            return
        vec = stats_vec * (stats_vec > -eps).astype(np.double)
        res = vec @ self.weightsVec
        self.textStyle.print(f"{self.key}: {res:.2f}    ")
        if base + res - one > self.threshold - np.double(0.01):
            WeightsPrflBase.PassStyle.print("Ｏ")
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
                WeightsPrflBase.PassStyle.print(f"{preferred:.2f}")
            else:
                WeightsPrflBase.FailStyle.print(f"{preferred:.2f}")
        self.textStyle.println("")


class GWeightsPrfl(WeightsPrflBase):
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
        super().__init__(key, baseATK, baseHP, baseDEF, allowMainStatList, stats, Stats, textStyle, threshold, legendary, normalized)


CritScorePrfl: GWeightsPrfl = GWeightsPrfl(
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

CritCountPrfl: GWeightsPrfl = GWeightsPrfl(
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

ATKCountPrfl: GWeightsPrfl = GWeightsPrfl(
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

HPCountPrfl: GWeightsPrfl = GWeightsPrfl(
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

DEFCountPrfl: GWeightsPrfl = GWeightsPrfl(
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

MavuikaPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Mavuika Obsidian Score",
    baseATK=np.double(558.77) + np.double(741),  # Mavuika + A Thousand Blazing Suns
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5)),
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

MualaniPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Mualani Obsidian Score",
    baseATK=np.double(181.78) + np.double(542),  # Mualani + Surf's Up
    baseHP=np.double(15184.93),  # Mualani
    baseDEF=np.double(570.27),  # Mualani
    allowMainStatList=[
        HP,
        ATK,
        HP_PCT.setWeight(np.double(0.5)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

GamingPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Gaming Hunter Score",
    baseATK=np.double(301.60) + np.double(674),  # Gaming + Verdict
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5)),
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

NeuvillettePrfl: GWeightsPrfl = GWeightsPrfl(
    key="Neuvillette Hunter Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(14695.09),  # Neuvillette
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        HP_PCT.setWeight(np.double(0.5)),
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

NoellePrfl: GWeightsPrfl = GWeightsPrfl(
    key="Noelle Hunter Score",
    baseATK=np.double(244.26) + np.double(510),  # Noelle + The Stringless
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        DEF_PCT.setWeight(np.double(0.5)),
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

FischlPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Fischl Troupe Score",
    baseATK=np.double(244.26) + np.double(510),  # Fischl + The String­les
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5)),
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

FurinaPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Furina Troupe Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(0.5)),
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

ChioriPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Chiori Troupe Score",
    baseATK=np.double(244.26) + np.double(510),  # Chiori + The Stringless
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(953.01),  # Chiori
    allowMainStatList=[
        HP,
        ATK,
        DEF_PCT.setWeight(np.double(0.5)),
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

EscoffierPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Escoffier Troupe Score",
    baseATK=np.double(346.81) + np.double(454),  # Escoffier + Deathmatch
    baseHP=np.double(13348.04),  # Escoffier
    baseDEF=np.double(731.66),  # Furina
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(0.5)),
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
    textStyle=TextStyle("light_cyan", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

SkirkPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Skirk Galleries/Hunter/Gladiator Score",
    baseATK=np.double(358.77) + np.double(674),  # Skirk + Azurelight
    baseHP=np.double(12417.35),  # Skirk
    baseDEF=np.double(806.21),  # Skirk
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_cyan", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

RaidenPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Raiden Fate Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(0.5)),
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

XianglingPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Xiangling Fate Score",
    baseATK=np.double(225.14) + np.double(510),  # Xiangling + "The Catch"
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(0.5)),
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

YelanPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Yelan Fate Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(14450.17),  # Yelan
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(0.5)),
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

AyatoPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Ayato Gladiator Score",
    baseATK=np.double(298.97) + np.double(510),  # Ayato + The Black Sword
    baseHP=np.double(13715.42),  # Ayato
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5)),
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

TighnariPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Tighnari Wanderer Score",
    baseATK=np.double(267.88) + np.double(565),  # Tighnari + Scion of the Blazing Sun
    baseHP=np.double(10849.88),  # Tighnari
    baseDEF=np.double(798.55),  # Noelle
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
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    threshold=np.double(7.0),
    legendary=True,
)

HutaoPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Hutao Reminiscence/Hunter Score",
    baseATK=np.double(106.43) + np.double(608),  # Hutao + Staff of Homa
    baseHP=np.double(15552.31),  # Hutao
    baseDEF=np.double(876.15),  # Hutao
    allowMainStatList=[
        HP,
        ATK,
        HP_PCT.setWeight(np.double(0.5)),
        ELEMENTAL_MASTERY.setWeight(np.double(1)),
        DMG_BONUS.setWeight(np.double(1)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.4) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.6) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(7.0),
    legendary=True,
)

CitlaliERPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Citlali Tenacity ER Score",
    baseATK=np.double(126.76) + np.double(542),  # Citlali + Starcaller's Watch
    baseHP=np.double(11633.62),  # Citlali
    baseDEF=np.double(763.17),  # Citlali
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(3)),
        ELEMENTAL_MASTERY.setWeight(np.double(2)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(5.1),
    legendary=True,
)

CitlaliEMPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Citlali Cinder EM Score",
    baseATK=np.double(126.76) + np.double(542),  # Citlali + Starcaller's Watch
    baseHP=np.double(11633.62),  # Citlali
    baseDEF=np.double(763.17),  # Citlali
    allowMainStatList=[
        HP,
        ATK,
        ELEMENTAL_MASTERY.setWeight(np.double(3)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(7.0),
    legendary=True,
)

XilonenCRPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Xilonen Cinder CR Score",
    baseATK=np.double(275.06) + np.double(454),  # Xilonen + Favonius Sword
    baseHP=np.double(12405.11),  # Xilonen
    baseDEF=np.double(929.95),  # Xilonen
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DEF_PCT.setWeight(np.double(0.5)),
        CRIT_RATE.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

XilonenDEFPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Xilonen Cinder DE𝑭 Score",
    baseATK=np.double(275.06) + np.double(454),  # Xilonen + Favonius Sword
    baseHP=np.double(12405.11),  # Xilonen
    baseDEF=np.double(929.95),  # Xilonen
    allowMainStatList=[
        HP,
        ATK,
        DEF_PCT.setWeight(np.double(3)),
        HEALING_BONUS.setWeight(np.double(3)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(1) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(7.0),
    legendary=True,
)

XianyunPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Xianyun Gladiator/Reminiscence Score",
    baseATK=np.double(334.85) + np.double(674),  # Xianyun + Skyward Atlas
    baseHP=np.double(10409.02),  # Xianyun
    baseDEF=np.double(572.57),  # Xianyun
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(2)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(1) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

ChevreusePrfl: GWeightsPrfl = GWeightsPrfl(
    key="Chevreuse Cinder Score",
    baseATK=np.double(193.28) + np.double(565),  # Chevreuse + Favonius Lance
    baseHP=np.double(11962.41),  # Chevreuse
    baseDEF=np.double(604.71),  # Chevreuse
    allowMainStatList=[
        HP,
        ATK,
        HP_PCT.setWeight(np.double(3)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(1) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(7.0),
    legendary=True,
)

CharlottePrfl: GWeightsPrfl = GWeightsPrfl(
    key="Charlotte Cinder ER Score",
    baseATK=np.double(173.10) + np.double(510),  # Charlotte + Prototype Amber
    baseHP=np.double(10766.17),  # Charlotte
    baseDEF=np.double(546.02),  # Charlotte
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(4.5)),
        ATK_PCT.setWeight(np.double(3)),
        HEALING_BONUS.setWeight(np.double(2)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

ZhongliPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Zhongli Tenacity/Vourukasha Score",
    baseATK=np.double(251.14) + np.double(354),  # Zhongli + Black Tassel
    baseHP=np.double(14695.09),  # Zhongli
    baseDEF=np.double(737.81),  # Zhongli
    allowMainStatList=[
        HP,
        ATK,
        HP_PCT.setWeight(np.double(3.3)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(1) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(4.7),
    legendary=True,
)

ShinobuPrfl: GWeightsPrfl = GWeightsPrfl(
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

NahidaPrfl: GWeightsPrfl = GWeightsPrfl(
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

ColleiPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Collei Deepwood Score",
    baseATK=np.double(199.65) + np.double(454),  # Collei + Favonius Warbow
    baseHP=np.double(9787.42),  # Collei
    baseDEF=np.double(600.62),  # Collei
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5)),
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

CitlaliPrfl: GWeightsPrfl = GWeightsPrfl(
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

XilonenPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Xilonen Count",
    baseATK=np.double(275.06) + np.double(454),  # Xilonen + Favonius Sword
    baseHP=np.double(12405.11),  # Xilonen
    baseDEF=np.double(929.95),  # Xilonen
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        DEF_PCT.setWeight(np.double(0.5)),
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

KiraraPrfl: GWeightsPrfl = GWeightsPrfl(
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

BennettPrfl: GWeightsPrfl = GWeightsPrfl(
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

JeanPrfl: GWeightsPrfl = GWeightsPrfl(
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
    MualaniPrfl.key: MualaniPrfl,
    GamingPrfl.key: GamingPrfl,
    NeuvillettePrfl.key: NeuvillettePrfl,
    NoellePrfl.key: NoellePrfl,
    FischlPrfl.key: FischlPrfl,
    FurinaPrfl.key: FurinaPrfl,
    ChioriPrfl.key: ChioriPrfl,
    EscoffierPrfl.key: EscoffierPrfl,
    SkirkPrfl.key: SkirkPrfl,
    RaidenPrfl.key: RaidenPrfl,
    XianglingPrfl.key: XianglingPrfl,
    YelanPrfl.key: YelanPrfl,
    AyatoPrfl.key: AyatoPrfl,
    TighnariPrfl.key: TighnariPrfl,
    HutaoPrfl.key: HutaoPrfl,
    CitlaliERPrfl.key: CitlaliERPrfl,
    CitlaliEMPrfl.key: CitlaliEMPrfl,
    XilonenCRPrfl.key: XilonenCRPrfl,
    XilonenDEFPrfl.key: XilonenDEFPrfl,
    XianyunPrfl.key: XianyunPrfl,
    ChevreusePrfl.key: ChevreusePrfl,
    CharlottePrfl.key: CharlottePrfl,
    ZhongliPrfl.key: ZhongliPrfl,
    ShinobuPrfl.key: ShinobuPrfl,
    NahidaPrfl.key: NahidaPrfl,
    ColleiPrfl.key: ColleiPrfl,
    CitlaliPrfl.key: CitlaliPrfl,
    XilonenPrfl.key: XilonenPrfl,
    KiraraPrfl.key: KiraraPrfl,
    BennettPrfl.key: BennettPrfl,
    JeanPrfl.key: JeanPrfl,
}


def weights_prfls() -> List[WeightsPrflBase]:
    return WeightsPrfls
