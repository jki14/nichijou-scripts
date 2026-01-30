def coeff(lhs, rhs, bar):
    lhs = (lhs - bar) / bar
    rhs = (rhs - bar) / bar
    return lhs / rhs


print("\nXingqiu ATK Hig:")
print(coeff(3822.852353, max(3824.458317, 3825.816243), 3737.817955))
print("Xingqiu ATK Low:")
print(coeff(3718.64959, max(3735.597114, 3732.604847), 3649.730242))

print("\nXiangling ATK Hig:")
print(coeff(14859.20765, max(15006.06881, 15011.39692), 14666.11708))
print("Xiangling ATK Low:")
print(coeff(13451.68568, max(13607.9828, 13597.08261), 13295.18811))
print("Xiangling EM Hig:")
print(coeff(12625.60002, max(12829.13306, 12818.85674), 12534.24111))
print(coeff(19721.73417, max(19998.70901, 19982.68976), 19539.01635))
print("Xiangling EM Low:")
print(coeff(22115.25758, max(22346.03543, 22353.9697), 21839.80202))

print("\nColumbina HP Hig:")
print(coeff(804521, max(800418, 807188), 792038))
print("Columbina HP Low:")
print(coeff(759023, max(755929, 765988), 748690))
print("Columbina EM Hig:")
print(coeff(799866, max(800418, 807188), 792038))
print("Columbina EM Low:")
print(coeff(715994, max(717319, 726798), 710385))

print("\nIneffa ATK Hig:")
print(coeff(536430.9575, max(535603.979, 538292.7249), 526477.3693))
print("Ineffa ATK Low:")
print(coeff(510808.5232, max(514326.0138, 514033.262), 502542.0454))
print("Ineffa EM Hig:")
print(coeff(533058.2284, max(535603.979, 538292.7249), 526477.3693))
print("Ineffa EM Low:")
print(coeff(482541.9934, max(488369.7663, 488091.7887), 477180.4939))
