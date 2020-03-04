# -*- coding: utf-8 -*-

def main():
    intel, criti, haste, maste, versa = [int(x) for x in raw_input('intel, crit, haste, maste, versa: ').split()]
    masmu = 1.6

    print 'intel = %.9f%%' % ((100.0/intel) * 100.0)
    print 'criti = %.9f%%' % (((100.0/400.0) / ((criti/400.0)+105.0)) * 100.0)
    print 'haste = %.9f%%' % (((100.0/375.0) / ((haste/375.0)+100.0)) * 100.0)
    print 'maste = %.9f%%' % (((100.0/666.0) * masmu / (((maste/666.0) + 4.8) * masmu +100.0)) * 100.0)
    print 'versa = %.9f%%' % (((100.0/475.0) / ((versa/475.0)+100.0)) * 100.0)

    print 'intel *%.9f' % (intel/7326.0)
    summary = intel/7326.0
    print 'criti *%.9f' % (criti/40000.0 + 1.05)
    summary *= criti/40000.0 + 1.05
    print 'haste *%.9f' % (haste/37500.0 + 1.00)
    summary *= haste/37500.0 + 1.00
    print 'maste *%.9f' % ((maste/66600.0 + 0.048) * masmu + 1.00)
    summary *= (maste/66600.0 + 0.048) * masmu + 1.00
    print 'versa *%.9f' % (versa/47500.0 + 1.00)
    summary *= versa/47500.0 + 1.00
    print 'summary = %.9f' % (summary)

    try:
        intel0, criti0, haste0, maste0, versa0 = [int(x) for x in raw_input('intel, crit, haste, maste, versa: ').split()]
        intel1, criti1, haste1, maste1, versa1 = [int(x) for x in raw_input('intel, crit, haste, maste, versa: ').split()]
        intel += intel1 - intel0
        criti += criti1 - criti0
        haste += haste1 - haste0
        maste += maste1 - maste0
        versa += versa1 - versa0
        print 'intel\' *%.9f' % (intel/7326.0)
        summary = intel/7326.0
        print 'criti\' *%.9f' % (criti/40000.0 + 1.05)
        summary *= criti/40000.0 + 1.05
        print 'haste\' *%.9f' % (haste/37500.0 + 1.00)
        summary *= haste/37500.0 + 1.00
        print 'maste\' *%.9f' % ((maste/66600.0 + 0.048) * masmu + 1.00)
        summary *= (maste/66600.0 + 0.048) * masmu + 1.00
        print 'versa\' *%.9f' % (versa/47500.0 + 1.00)
        summary *= versa/47500.0 + 1.00
        print 'summary\' = %.9f' % (summary)
    except KeyboardInterrupt:
        print 'done.'
        
if __name__ == '__main__':
    main()
