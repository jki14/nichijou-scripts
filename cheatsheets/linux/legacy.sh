## Importing a CMake project into Eclipse CDT
cd <project_dir>
cmake -G "Eclipse CDT4 - Unix Makefiles" ./


## ABOUT JDT
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo update-alternatives --config java
sudo update-alternatives --config javac


## ABOUT FLASH PLAYER
sudo apt-get adobe-flashplugin

## MULTI-REPLACE
(export LHS='alpha' && export RHS='beta' && sed -i "s/${LHS}/${RHS}/g" `grep "${LHS}" -rl . --exclude-dir=.git`)

## ABOUT SOGOU PINYIN
apt-get install fcitx fcitx-bin fcitx-config-common fcitx-config-gtk fcitx-data fcitx-frontend-all fcitx-module-cloudpinyin fcitx-module-dbus fcitx-module-kimpanel fcitx-module-x11 fcitx-modules fcitx-qimpanel-configtool 

## ABOUT TL-WN726N
apt-add-repository ppa:thopiekar/mt7601
apt-get update
apt-get install mt7601-sta-dkms

## g100s .profile
xinput --set-prop 11 280 1.1
xinput --set-prop 11 282 1.0

## rapoo-keyboard-driver-issue
https://github.com/kinglongmee/rapoo-keyboard-driver

## CONVERT TO UNIX FILE
find . -name '*.cpp' -exec perl -i -pe 's/\r+$//' {} \;
