#!/bin/bash

###############################################################################
# self-updater
###############################################################################

printf "\033[96mChecking for script updates...\033[0m"
cd /home/memryx/.memx_updater

# check for updates
git fetch origin
reslog=$(git log HEAD..origin/main --oneline)
if [[ "${reslog}" != "" ]]; then
	printf "\033[92mUpdate found! Downloading and restarting myself...\033[0m"
	# update available
	git pull origin main
	# restart myself
	./memx_updater.sh
	exit $?
else
	echo -e "No script updates found.\n"
fi



###############################################################################
# pip updater
###############################################################################

printf "\033[96mCheck for update the SDK Python tools?\033[0m "
read -n 1 -p " [Y]/N:  " pipcheck
pipcheck=${pipcheck:-Y}

if [[ $pipcheck == "Y" ]] || [[ $pipcheck == "y" ]]; then
	. ~/mx/bin/activate &&
	pip install --upgrade --extra-index-url https://developer.memryx.com/pip memryx
	if [ $? -ne 0 ]; then
		echo -e "\n\n\033[91mError\033[0m: something failed. Please see error logs above.\n"
		read "Press ENTER to close this window..." junk
		exit 1
	fi
fi

echo -e "\n\n"


###############################################################################
# apt updater
###############################################################################

printf "\033[96mCheck for and update Driver and C++ Runtimes?\033[0m " aptcheck
read -n 1 -p " [Y]/N:  " aptcheck
aptcheck=${aptcheck:-Y}

if [[ $aptcheck == "Y" ]] || [[ $aptcheck == "y" ]]; then
	sudo apt update &&
	sudo apt install memx-drivers memx-accl memx-accl-plugins memx-accl-plugins-u24 memx-utils-gui memx-utils-gui-cv46
	if [ $? -ne 0 ]; then
		echo -e "\n\n\033[91mError\033[0m: something failed. Please see error logs above.\n"
		read "Press ENTER to close this window..." junk
		exit 1
	fi
fi

echo -e "\n\n"


###############################################################################
# examples puller
###############################################################################

printf "\033[96m'git pull' the latest examples in ~/memryx_examples?\033[0m " gitcheck
read -n 1 -p " [Y]/N:  " gitcheck
gitcheck=${gitcheck:-Y}

if [[ $gitcheck == "Y" ]] || [[ $gitcheck == "y" ]]; then
	cd ~/memryx_examples &&
	git pull
	if [ $? -ne 0 ]; then
		echo -e "\n\n\033[91mError\033[0m: something failed. Please see error logs above.\n"
		read "Press ENTER to close this window..." junk
		exit 1
	fi
fi



printf "\n\n\033[92mDone!\033[0m "
read -p "Press ENTER to close this window..." junk
exit 0
