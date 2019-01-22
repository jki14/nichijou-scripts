# -*- coding: utf-8 -*-

import os

def main():
    script_location = os.path.realpath(__file__)
    script_path, script_file = os.path.split(script_location)
    print 'work at ' + script_path
    wtf_path = os.path.join(script_path, 'WTF')
    print 'WTF at ' + wtf_path
    cfg_path = os.path.join(wtf_path, 'Config.wtf')
    if os.path.isfile(cfg_path):
        print cfg_path + ' found'
        raw = None
        msg = 'failed to open ' + cfg_path
        with open(cfg_path, 'r') as cfg:
            raw = cfg.read()
        if raw is not None:
            msg = 'cannot find key words'
            if 'SET textLocale "enUS"' in raw:
                raw = raw.replace('SET textLocale "enUS"', 'SET textLocale "zhCN"')
                msg = 'text language switch to zhCN'
            elif 'SET textLocale "zhCN"' in raw:
                raw = raw.replace('SET textLocale "zhCN"', 'SET textLocale "enUS"')
                msg = 'text language switch to enUS'
            with open(cfg_path, 'w') as cfg:
                cfg.write(raw)
                raw = True
            if raw is not True:
                msg = 'cannot write ' + cfg_path
        print msg
    else:
        print 'cannot find ' + cfg_path
    msg_printed = False
    try:
        while True:
            if not msg_printed:
                print 'Press Ctrl+C to continue...'
                msg_printed = True
    except KeyboardInterrupt:
        pass

if __name__ == '__main__':
    main()
