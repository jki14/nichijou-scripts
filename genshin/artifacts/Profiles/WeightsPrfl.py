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
        misscount: int,
        legendary: bool,
        normalized: bool,
        v2: bool,
    ):
        mainStatMapKeyWeight = {stat.key: stat.weight for stat in allowMainStatList}
        self.key = key
        self.mainWeightsVec = np.array([mainStatMapKeyWeight.get(s.key, -one) + one for s in statsAll], dtype=np.double)
        self.weightsVec = np.array([s.weight for s in statsWeighted], dtype=np.double)
        if not normalized:
            self.weightsVec /= np.max(self.weightsVec)
        self.textStyle = textStyle
        self.misscount = misscount
        self.legendary = legendary
        self.threshold = threshold

        if v2:
            # validate tags
            if self.misscount != 0:
                raise ValueError(f"{self.key}: misscount = {self.misscount} @ v2")
            if self.legendary != True:
                raise ValueError(f"{self.key}: legendary = {self.legendary} @ v2")
            # validate threshold
            x, y, z = sorted(self.weightsVec, reverse=True)[:3]
            bar = min((x + y) * 7.0 / 8.5 + x * 4.0 + y * 1.0, (x + y + z) * 7.0 / 8.5 + x * 3.0 + y * 1.0) * oneIncCoeExp
            if np.round(bar, 4) != self.threshold:
                raise ValueError(f"{self.key}: threshold = {self.threshold:.6f} (suggested: {bar:.6f}) @ v2")
            # validate main weights
            flats = [ATK.key, HP.key]
            for k in flats:
                if zero != mainStatMapKeyWeight.get(k, -one):
                    raise ValueError(f"{self.key}: main weight {k} = {mainStatMapKeyWeight.get(k, -one):.6f} (suggested: {zero:.6f}) @ v2")
            idx = {s.key: i for i, s in enumerate(statsAll)}
            barhig = [ATK_PCT.key, DEF_PCT.key, HP_PCT.key]
            for k in [k for k in barhig if k in mainStatMapKeyWeight]:
                excluded = idx[k]
                x, y, z = sorted([v for i, v in enumerate(self.weightsVec) if i != excluded], reverse=True)[:3]
                rhs = bar - max((x + y) * 7.0 / 8.5 + x * 3.0 + y * 1.0, (x + y + z) * 7.0 / 8.5 + x * 2.0 + y * 1.0) * oneIncCoeExp
                if np.round(rhs, 4) != mainStatMapKeyWeight.get(k):
                    raise ValueError(f"{self.key}: main weight {k} = {mainStatMapKeyWeight.get(k):.6f} (suggested: {rhs:.6f}) @ v2")
            barlow = [CRIT_RATE.key, CRIT_DMG.key, ENERGY_RECHARGE.key, ELEMENTAL_MASTERY.key, DMG_BONUS.key, HEALING_BONUS.key]
            for k in [k for k in barlow if k in mainStatMapKeyWeight]:
                excluded = idx[k]
                x, y, z = sorted([v for i, v in enumerate(self.weightsVec) if i != excluded], reverse=True)[:3]
                rhs = bar - min((x + y) * 7.0 / 8.5 + x * 3.0 + y * 1.0, (x + y + z) * 7.0 / 8.5 + x * 2.0 + y * 1.0) * oneIncCoeExp
                if np.round(rhs, 4) != mainStatMapKeyWeight.get(k):
                    raise ValueError(f"{self.key}: main weight {k} = {mainStatMapKeyWeight.get(k):.6f} (suggested: {rhs:.6f}) @ v2")

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
        if self.misscount > 0:
            self.textStyle.print(f"{self.key}: ")
            presence = (stats_vec > eps).astype(int)
            if presence.sum() <= 4:
                missed = presence @ (self.weightsVec < 0.6).astype(int)
                if missed < self.misscount:
                    WeightsPrflBase.PassStyle.print(f"-{missed}")
                else:
                    WeightsPrflBase.FailStyle.print(f"-{missed}")
                self.textStyle.println("")
        if self.threshold < eps:
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
        misscount: int = 0,
        legendary: bool = False,
        normalized: bool = True,
        v2: bool = False,
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
            v2=v2,
        )


ATKMissPrfl: GWeightsPrfl = GWeightsPrfl(
    key="ATK Miss",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        ELEMENTAL_MASTERY,
        ATK_PCT,
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(1) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    misscount=2,
    threshold=np.double(0),
)

HPMissPrfl: GWeightsPrfl = GWeightsPrfl(
    key="HP Miss",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP_PCT,
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(1) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    misscount=2,
    threshold=np.double(0),
)

DEFMissPrfl: GWeightsPrfl = GWeightsPrfl(
    key="DEF Miss",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        DEF_PCT,
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(1) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    misscount=2,
    threshold=np.double(0),
)

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

NeferPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Nefer Unveiling Score",
    baseATK=np.double(303.87) + np.double(542),  # Nefer + Reliquary of Truth
    baseHP=np.double(11208.37),  # Nefer
    baseDEF=np.double(705.20),  # Nefer
    allowMainStatList=[
        HP,
        ATK,
        ELEMENTAL_MASTERY.setWeight(np.double(1.5844)),
        CRIT_RATE.setWeight(np.double(2.1139)),
        CRIT_DMG.setWeight(np.double(2.1139)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.7096) / oneIncCoeExp),  # 0.7096 -> 0.9385
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    threshold=np.double(6.2314),
    legendary=True,
    v2=True,
)

SkirkPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Skirk Galleries/Hunter Score",
    baseATK=np.double(358.77) + np.double(674),  # Skirk + Azurelight
    baseHP=np.double(12417.35),  # Skirk
    baseDEF=np.double(806.21),  # Skirk
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5000)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(2.0549)),
        CRIT_DMG.setWeight(np.double(2.0549)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.6071) / oneIncCoeExp),  # 0.6071 -> 0.8380
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_cyan", "on_black", ["bold"]),
    threshold=np.double(6.1470),
    legendary=True,
    v2=True,
)

MavuikaPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Mavuika Obsidian Score",
    baseATK=np.double(558.77) + np.double(741),  # Mavuika C2 + A Thousand Blazing Suns
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.7026)),
        ELEMENTAL_MASTERY.setWeight(np.double(1.2231)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(1.4910)),
        CRIT_DMG.setWeight(np.double(1.4910)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.8531) / oneIncCoeExp),  # ATK-S: 0.8531 -> 1.5619; EM-S: 0.5943 -> 0.9919
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5822) / oneIncCoeExp),  # ATK-S: 0.5822 -> 0.7716;  EM-S: 0.6543 -> 0.8808
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(6.3496),
    legendary=True,
    v2=True,
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
    threshold=np.double(7.0),
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
        ATK_PCT.setWeight(np.double(0.7551)),
        ELEMENTAL_MASTERY.setWeight(np.double(1.2777)),
        DMG_BONUS.setWeight(np.double(1.0)),
        CRIT_RATE.setWeight(np.double(1.4292)),
        CRIT_DMG.setWeight(np.double(1.4292)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.9169) / oneIncCoeExp),  # Iansan C2 + Bennett: 0.9169 -> 1.5502
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5797) / oneIncCoeExp),  # Iansan C2 + Bennett: 0.5797 -> 0.7346
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(6.4022),
    legendary=True,
    v2=True,
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

TighnariPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Tighnari Wanderer Score",
    baseATK=np.double(267.88) + np.double(565),  # Tighnari + Scion of the Blazing Sun
    baseHP=np.double(10849.88),  # Tighnari
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ELEMENTAL_MASTERY.setWeight(np.double(1.1318)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(1.8207)),
        CRIT_DMG.setWeight(np.double(1.8207)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.6222) / oneIncCoeExp),  # 0.6222 -> 0.8825
    ATK_PCT=ATK_PCT.setWeight(np.double(0.4622) / oneIncCoeExp),  # 0.4622 -> 0.5668
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("green", "on_black", ["bold"]),
    threshold=np.double(6.1595),
    legendary=True,
    v2=True,
)

AyatoPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Ayato Gladiator Score",
    baseATK=np.double(298.97) + np.double(510),  # Ayato + The Black Sword
    baseHP=np.double(13715.42),  # Ayato
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5296)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(1.7687)),
        CRIT_DMG.setWeight(np.double(1.7687)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.6431) / oneIncCoeExp),  # 0.6431 -> 0.7895
    HP_PCT=HP_PCT.setWeight(np.double(0.3392) / oneIncCoeExp),  # 0.3392 -> 0.4167
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(6.1767),
    legendary=True,
    v2=True,
)

RaidenPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Raiden Fate Score",
    baseATK=np.double(337.24) + np.double(608),  # Raiden Shogun + Engulfing Lightning
    baseHP=np.double(15307.39),  # Furina
    baseDEF=np.double(798.55),  # Noelle
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1.0000)),
        ATK_PCT.setWeight(np.double(0.2718)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(2.2668)),
        CRIT_DMG.setWeight(np.double(2.2668)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.2752) / oneIncCoeExp),  # Durin C1: 0.2752 -> 0.3741
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.3301) / oneIncCoeExp),  # Durin C1: 0.3301 -> 0.4769
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
    threshold=np.double(5.9189),
    legendary=True,
    v2=True,
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

ColumbinaCDPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Columbina AoMaM CD Score",
    baseATK=np.double(95.67) + np.double(510),  # Columbina + Favonius Codex
    baseHP=np.double(14695.09),  # Columbina
    baseDEF=np.double(514.93),  # Columbina
    allowMainStatList=[
        HP,
        ATK,
        HP_PCT.setWeight(np.double(0.4920)),
        CRIT_RATE.setWeight(np.double(1.9447)),
        CRIT_DMG.setWeight(np.double(1.9447)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.0000) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.3417) / oneIncCoeExp),  # 0.3417 -> 0.5167
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.5974) / oneIncCoeExp),  # 0.5974 -> 0.8240
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(6.1390),
    legendary=True,
    v2=True,
)

ColumbinaERPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Columbina SMS ER Score",
    baseATK=np.double(95.67) + np.double(510),  # Columbina + Favonius Codex
    baseHP=np.double(14695.09),  # Columbina
    baseDEF=np.double(514.93),  # Columbina
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(0.5)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

IneffaPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Ineffa AoMaM Score",
    baseATK=np.double(330.07) + np.double(454),  # Ineffa + Deathmatch
    baseHP=np.double(12613.29),  # Ineffa
    baseDEF=np.double(827.73),  # Ineffa
    allowMainStatList=[
        HP,
        ATK,
        ATK_PCT.setWeight(np.double(0.5777)),
        CRIT_RATE.setWeight(np.double(1.7274)),
        CRIT_DMG.setWeight(np.double(1.7274)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.0000) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.4792) / oneIncCoeExp),  # 0.4792 -> 0.5570
    ATK_PCT=ATK_PCT.setWeight(np.double(0.7015) / oneIncCoeExp),  # 0.7015 -> 0.8424
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(6.2248),
    legendary=True,
    v2=True,
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

YelanPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Yelan Fate Score",
    baseATK=np.double(243.96) + np.double(454),  # Yelan + Favonius Warbow
    baseHP=np.double(14450.17),  # Yelan
    baseDEF=np.double(547.98),  # Yelan
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1.0000)),
        HP_PCT.setWeight(np.double(0.6862)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(1.5786)),
        CRIT_DMG.setWeight(np.double(1.5786)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5000) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.8332) / oneIncCoeExp),  # 0.8332 -> 1.0494
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
    threshold=np.double(6.3332),
    legendary=True,
    v2=True,
)

RosariaDMGPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Rosaria Noblesse DMG Score",
    baseATK=np.double(240.01) + np.double(454),  # Rosaria + Deathmatch
    baseHP=np.double(12288.65),  # Rosaria
    baseDEF=np.double(709.82),  # Rosaria
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        ATK_PCT.setWeight(np.double(0.5)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
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
        ATK_PCT.setWeight(np.double(0.4080)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(2.1477)),
        CRIT_DMG.setWeight(np.double(2.1477)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.4954) / oneIncCoeExp),  # 0.4954 -> 0.5757
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
    threshold=np.double(6.0550),
    legendary=True,
    v2=True,
)

XianglingPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Xiangling Fate Score",
    baseATK=np.double(225.14) + np.double(510),  # Xiangling + "The Catch"
    baseHP=np.double(10874.91),  # Xiangling
    baseDEF=np.double(668.87),  # Xiangling
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1.0000)),
        ATK_PCT.setWeight(np.double(0.4120)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(1.9115)),
        CRIT_DMG.setWeight(np.double(1.9115)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.3975) / oneIncCoeExp),  # 0.3975 -> 0.5357
    ATK_PCT=ATK_PCT.setWeight(np.double(0.5003) / oneIncCoeExp),  # 0.5003 -> 0.5592
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(6.0591),
    legendary=True,
    v2=True,
)

XingqiuPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Xingqiu Fate Score",
    baseATK=np.double(201.78) + np.double(454),  # Xingqiu + Sacrificial Sword
    baseHP=np.double(10222.42),  # Xingqiu
    baseDEF=np.double(757.60),  # Xingqiu
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1.0000)),
        ATK_PCT.setWeight(np.double(0.6610)),
        DMG_BONUS.setWeight(np.double(1.0000)),
        CRIT_RATE.setWeight(np.double(1.6092)),
        CRIT_DMG.setWeight(np.double(1.6092)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.8026) / oneIncCoeExp),  # 0.8026 -> 0.9663
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("light_red", "on_black", ["bold"]),
    threshold=np.double(6.3080),
    legendary=True,
    v2=True,
)

DahliaCRPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Dahlia Noblesse CR Score",
    baseATK=np.double(189.03) + np.double(454),  # Dahlia + Favonius Sword
    baseHP=np.double(12506.15),  # Dahlia
    baseDEF=np.double(559.67),  # Dahlia
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(1)),
        HP_PCT.setWeight(np.double(0.5)),
        CRIT_RATE.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(1.0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(6.0),
    legendary=True,
)

LaumaERPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Lauma Deepwood/SMS ER Score",
    baseATK=np.double(254.96) + np.double(510),  # Lauma + Etherlight Spindlelute
    baseHP=np.double(10653.94),  # Lauma
    baseDEF=np.double(668.64),  # Lauma
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(3.8235)),
        ELEMENTAL_MASTERY.setWeight(np.double(1.9118)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0.5000) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(5.7353),
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
    key="Xilonen Cinder/Noblesse CR Score",
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
    key="Xilonen Cinder/Noblesse DE𝑭 Score",
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
    key="Xianyun Gladiator/Reminiscence/RisingWinds Score",
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

ShinobuEMPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Shinobu Deepwood/Wanderer/SMS EM Score",
    baseATK=np.double(212.40) + np.double(510),  # Shinobu + Xiphos' Moonlight
    baseHP=np.double(12288.65),  # Shinobu
    baseDEF=np.double(750.77),  # Shinobu
    allowMainStatList=[
        HP,
        ATK,
        ELEMENTAL_MASTERY.setWeight(np.double(2.3235)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(0.5000) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1.0000) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.5000) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(5.1470),
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

MonaERPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Mona Noblesse ER Score",
    baseATK=np.double(287.01) + np.double(401),  # Mona + Thrilling Tales of Dragon Slayers
    baseHP=np.double(10409.02),  # Mona
    baseDEF=np.double(653.27),  # Mona
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(4)),
        ATK_PCT.setWeight(np.double(0.5)),
        CRIT_RATE.setWeight(np.double(1)),
        CRIT_DMG.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0.2) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0.2) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0.2) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(5.1),
    legendary=True,
)

SucroseSMSPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Sucrose Wanderer/SMS Score",
    baseATK=np.double(169.92) + np.double(454),  # Sucrose + Sacrificial Fragments
    baseHP=np.double(9243.68),  # Sucrose
    baseDEF=np.double(703.00),  # Sucrose
    allowMainStatList=[
        HP,
        ATK,
        ELEMENTAL_MASTERY.setWeight(np.double(1.3235)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0.5000) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1.0000) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(1.0000) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(6.0588),
    legendary=True,
)

BennettERPrfl: GWeightsPrfl = GWeightsPrfl(
    key="Bennett Noblesse ER Score",
    baseATK=np.double(191.16) + np.double(454),  # Bennett + Favonius Sword
    baseHP=np.double(12397.40),  # Bennett
    baseDEF=np.double(771.25),  # Bennett
    allowMainStatList=[
        HP,
        ATK,
        ENERGY_RECHARGE.setWeight(np.double(3)),
        HP_PCT.setWeight(np.double(2)),
        HEALING_BONUS.setWeight(np.double(1)),
    ],
    CRIT_RATE=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    CRIT_DMG=CRIT_RATE.setWeight(np.double(0) / oneIncCoeExp),
    ENERGY_RECHARGE=ENERGY_RECHARGE.setWeight(np.double(1) / oneIncCoeExp),
    ELEMENTAL_MASTERY=ELEMENTAL_MASTERY.setWeight(np.double(0) / oneIncCoeExp),
    ATK_PCT=ATK_PCT.setWeight(np.double(0) / oneIncCoeExp),
    HP_PCT=HP_PCT.setWeight(np.double(0.5) / oneIncCoeExp),
    DEF_PCT=DEF_PCT.setWeight(np.double(0) / oneIncCoeExp),
    textStyle=TextStyle("dark_grey", "on_black", ["bold"]),
    threshold=np.double(5.1),
    legendary=True,
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
    # General Miss
    ATKMissPrfl.key: ATKMissPrfl,
    HPMissPrfl.key: HPMissPrfl,
    DEFMissPrfl.key: DEFMissPrfl,
    # General Count
    CritScorePrfl.key: CritScorePrfl,
    CritCountPrfl.key: CritCountPrfl,
    ATKCountPrfl.key: ATKCountPrfl,
    HPCountPrfl.key: HPCountPrfl,
    DEFCountPrfl.key: DEFCountPrfl,
    # Main DPS
    NeferPrfl.key: NeferPrfl,
    SkirkPrfl.key: SkirkPrfl,
    MavuikaPrfl.key: MavuikaPrfl,
    MualaniPrfl.key: MualaniPrfl,
    GamingPrfl.key: GamingPrfl,
    NeuvillettePrfl.key: NeuvillettePrfl,
    TighnariPrfl.key: TighnariPrfl,
    AyatoPrfl.key: AyatoPrfl,
    RaidenPrfl.key: RaidenPrfl,
    HutaoPrfl.key: HutaoPrfl,
    NoellePrfl.key: NoellePrfl,
    # Sub DPS
    ColumbinaCDPrfl.key: ColumbinaCDPrfl,
    ColumbinaERPrfl.key: ColumbinaERPrfl,
    IneffaPrfl.key: IneffaPrfl,
    EscoffierPrfl.key: EscoffierPrfl,
    ChioriPrfl.key: ChioriPrfl,
    FurinaPrfl.key: FurinaPrfl,
    NahidaPrfl.key: NahidaPrfl,
    ColleiPrfl.key: ColleiPrfl,
    YelanPrfl.key: YelanPrfl,
    RosariaDMGPrfl.key: RosariaDMGPrfl,
    FischlPrfl.key: FischlPrfl,
    XianglingPrfl.key: XianglingPrfl,
    XingqiuPrfl.key: XingqiuPrfl,
    # Support
    LaumaERPrfl.key: LaumaERPrfl,
    DahliaCRPrfl.key: DahliaCRPrfl,
    CitlaliERPrfl.key: CitlaliERPrfl,
    CitlaliEMPrfl.key: CitlaliEMPrfl,
    XilonenCRPrfl.key: XilonenCRPrfl,
    XilonenDEFPrfl.key: XilonenDEFPrfl,
    XianyunPrfl.key: XianyunPrfl,
    ChevreusePrfl.key: ChevreusePrfl,
    CharlottePrfl.key: CharlottePrfl,
    ShinobuEMPrfl.key: ShinobuEMPrfl,
    ZhongliPrfl.key: ZhongliPrfl,
    MonaERPrfl.key: MonaERPrfl,
    BennettERPrfl.key: BennettERPrfl,
    # Legacy Count
    XilonenPrfl.key: XilonenPrfl,
    KiraraPrfl.key: KiraraPrfl,
    JeanPrfl.key: JeanPrfl,
    SucroseSMSPrfl.key: SucroseSMSPrfl,
    BennettPrfl.key: BennettPrfl,
}


def weights_prfls() -> List[WeightsPrflBase]:
    return WeightsPrfls
