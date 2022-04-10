# check
pmset -g | grep hibernatemode

# set
sudo pmset -a sleep 0
sudo pmset -a hibernatemode 0
sudo pmset -a disablesleep 1

# unset
sudo pmset -a sleep 1
sudo pmset -a hibernatemode 3
sudo pmset -a disablesleep 0
