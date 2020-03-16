Randomize
KeyDown "Space", 1
T = Int(96 + 32 * Rnd)
Delay T
KeyUp "Space", 1
T = Int(96 + 32 * Rnd)
Delay T
KeyDown "Alt", 1
T = Int(96 + 32 * Rnd)
Delay T
KeyDown "Q", 1
T = Int(96 + 32 * Rnd)
Delay T
KeyUp "Q", 1
T = Int(96 + 32 * Rnd)
Delay T
KeyUp "Alt", 1
T = Int(30 + 3 * Rnd) * 1000
Delay T

For 150
IfColor 16, 64, "FF", 2 Then
KeyDown "R", 1
T = Int(96 + 32 * Rnd)
Delay T
KeyUp "R", 1
T = Int(96 + 32 * Rnd)
Delay T
MoveTo 1597, 434
T = Int(96 + 32 * Rnd)
Delay T
LeftDown 1
T = Int(96 + 32 * Rnd)
Delay T
LeftUp 1
T = Int(30 + 3 * Rnd) * 1000
Delay T
EndScript
Else 
KeyDown "Tab", 1
T = Int(96 + 32 * Rnd)
Delay T
KeyUp "Tab", 1
T = Int(96 + 32 * Rnd)
Delay T
End If
Next
