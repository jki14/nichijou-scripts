from copy import deepcopy
from typing import List

import numpy as np

from Utils.Constants import PCT, one, oneIncCoeExp
from Utils.TextStyle import TextStyle


class StatInfo:
    def __init__(
        self,
        key: str,
        zhTW: str,
        onceIncrementMax: np.double,
        appendFactor: np.double,
        weight: np.double,
        textStyle: TextStyle,
    ):
        self.key = key
        self.zhTW = zhTW
        self.onceIncrementMax = onceIncrementMax
        self.appendFactor = appendFactor
        self.weight = weight
        self.textStyle = textStyle

    def setWeight(self, value: np.double):
        res = deepcopy(self)
        res.weight = value
        return res

    def validate(self, key: str, value: str):
        return self.key.replace(PCT, "") in key and (PCT in self.key) == (PCT in value)

    def println(self, hits: np.double):
        value = hits * self.onceIncrementMax
        count = hits / oneIncCoeExp
        if PCT in self.key:
            self.textStyle.println(f"{self.key.replace(PCT, '')}: {value:.2f} % (x {count: .2f})")
        else:
            self.textStyle.println(f"{self.key}: {value:.2f} (x {count: .2f})")


CRIT_RATE = StatInfo(
    key="CRIT Rate%",
    zhTW="暴擊率",
    onceIncrementMax=np.double(3.89),
    appendFactor=np.double(75),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

CRIT_DMG = StatInfo(
    key="CRIT DMG%",
    zhTW="暴擊傷害",
    onceIncrementMax=np.double(7.77),
    appendFactor=np.double(75),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

ENERGY_RECHARGE = StatInfo(
    key="Energy Recharge%",
    zhTW="元素充能效率",
    onceIncrementMax=np.double(6.48),
    appendFactor=np.double(100),
    weight=np.double(0),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
)

ELEMENTAL_MASTERY = StatInfo(
    key="Elemental Mastery",
    zhTW="元素精通",
    onceIncrementMax=np.double(23.31),
    appendFactor=np.double(100),
    weight=np.double(0),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
)

ATK_PCT = StatInfo(
    key="ATK%",
    zhTW="攻擊力",
    onceIncrementMax=np.double(5.83),
    appendFactor=np.double(100),
    weight=np.double(0),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
)

HP_PCT = StatInfo(
    key="HP%",
    zhTW="生命值",
    onceIncrementMax=np.double(5.83),
    appendFactor=np.double(100),
    weight=np.double(0),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
)

DEF_PCT = StatInfo(
    key="DEF%",
    zhTW="防禦力",
    onceIncrementMax=np.double(7.29),
    appendFactor=np.double(100),
    weight=np.double(0),
    textStyle=TextStyle("dark_grey", "on_black", []),
)

ATK = StatInfo(
    key="ATK",
    zhTW="攻擊力",
    onceIncrementMax=np.double(19.45),
    appendFactor=np.double(150),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

HP = StatInfo(
    key="HP",
    zhTW="生命值",
    onceIncrementMax=np.double(298.75),
    appendFactor=np.double(150),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

DEF = StatInfo(
    key="DEF",
    zhTW="防禦力",
    onceIncrementMax=np.double(23.15),
    appendFactor=np.double(150),
    weight=np.double(0),
    textStyle=TextStyle("dark_grey", "on_black", []),
)

DMG_BONUS = StatInfo(
    key="DMG Bonus%",
    zhTW="傷害加成",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

HEALING_BONUS = StatInfo(
    key="Healing Bonus%",
    zhTW="治療加成",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("dark_grey", "on_black", []),
)

Stats: List[StatInfo] = [
    CRIT_RATE,
    CRIT_DMG,
    ENERGY_RECHARGE,
    ELEMENTAL_MASTERY,
    ATK_PCT,
    HP_PCT,
    DEF_PCT,
    ATK,
    HP,
    DEF,
    DMG_BONUS,
    HEALING_BONUS,
]

StatsN: int = len(Stats)
StatHitsVec = np.array([one / stat.onceIncrementMax for stat in Stats], dtype=np.double)
StatAppendFactorsVec = np.array([stat.appendFactor for stat in Stats], dtype=np.double)


def stats_list() -> List[StatInfo]:
    return Stats


def stats_num() -> int:
    return StatsN


def stats_hit() -> np.typing.NDArray[np.double]:
    return StatHitsVec


def stats_prob() -> np.typing.NDArray[np.double]:
    return StatAppendFactorsVec
