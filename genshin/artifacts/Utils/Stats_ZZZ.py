from copy import deepcopy
from typing import List

import numpy as np

import Utils.Stats
from Utils.Constants import one, oneIncCoeExp
from Utils.Stats import StatInfo
from Utils.TextStyle import TextStyle

HP = StatInfo(
    key="HP",
    zhTW="生命值",
    onceIncrementMax=np.double(112) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

ATK = StatInfo(
    key="ATK",
    zhTW="攻擊力",
    onceIncrementMax=np.double(19) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

DEF = StatInfo(
    key="DEF",
    zhTW="防禦力",
    onceIncrementMax=np.double(15) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("dark_grey", "on_black", []),
)

HP_PCT = StatInfo(
    key="HP%",
    zhTW="生命值",
    onceIncrementMax=np.double(3) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
)

ATK_PCT = StatInfo(
    key="ATK%",
    zhTW="攻擊力",
    onceIncrementMax=np.double(3) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("light_blue", "on_black", ["bold"]),
)

DEF_PCT = StatInfo(
    key="DEF%",
    zhTW="防禦力",
    onceIncrementMax=np.double(4.8) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("dark_grey", "on_black", []),
)

CRIT_RATE = StatInfo(
    key="CRIT Rate%",
    zhTW="暴擊率",
    onceIncrementMax=np.double(2.4) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

CRIT_DMG = StatInfo(
    key="CRIT DMG%",
    zhTW="暴擊傷害",
    onceIncrementMax=np.double(4.8) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("yellow", "on_black", ["bold"]),
)

ANOMALY_PROFICIENCY = StatInfo(
    key="Anomaly Proficiency",
    zhTW="異常精通",
    onceIncrementMax=np.double(9) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
)

PEN = StatInfo(
    key="PEN",
    zhTW="穿透值",
    onceIncrementMax=np.double(9) / oneIncCoeExp,
    appendFactor=np.double(1),
    weight=np.double(0),
    textStyle=TextStyle("light_magenta", "on_black", ["bold"]),
)

PEN_RATIO = StatInfo(
    key="PEN Ratio%",
    zhTW="穿透率",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", ["bold"]),
)

DMG_BONUS = StatInfo(
    key="DMG Bonus%",
    zhTW="傷害加成",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

ANOMALY_MASTERY = StatInfo(
    key="Anomaly Mastery%",
    zhTW="異常掌控",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

IMPACT = StatInfo(
    key="Impact%",
    zhTW="衝擊力",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

ENERGY_REGEN = StatInfo(
    key="Energy Regen%",
    zhTW="能量自動回復",
    onceIncrementMax=np.double(1),
    appendFactor=np.double(0),
    weight=np.double(0),
    textStyle=TextStyle("green", "on_black", []),
)

Stats: List[StatInfo] = [
    HP,
    ATK,
    DEF,
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

StatsN: int = len(Stats)
StatHitsVec = np.array([one / stat.onceIncrementMax for stat in Stats], dtype=np.double)
StatAppendFactorsVec = np.array([stat.appendFactor for stat in Stats], dtype=np.double)


def override() -> None:
    Utils.Stats.Stats = Stats
    Utils.Stats.StatsN = StatsN
    Utils.Stats.StatHitsVec = StatHitsVec
    Utils.Stats.StatAppendFactorsVec = StatAppendFactorsVec
