if [ "$1" == "--help" ]; then
	echo -e "\e[1mSyntax:\e[0m"
	echo -e "    ./update-minetest.sh [option]"
	echo -e "    \e[1mOption could be one of:\e[0m"
	echo -e "        \e[1;34mclone\e[0m: Perform a full recompilation of minetest instead\n            of only affected files."
	echo -e "        \e[1;34mhelp\e[0m: Show this help message then exit."
	echo -e "        \e[1;34mmtgame-upd\e[0m: Only update minetest game subgame."
	exit 0
elif [ "$1" == "--clone" ]; then
	echo -e "\e[1;31mPerforming full recompilation instead of just affected files.\e[0m"
elif [ "$1" == "--mtgame-upd" ]; then
	echo -e "\e[1;33mOnly updating minetest game.\e[0m"
elif [ -z "$1" ]; then
	echo -e "\e[1;33mRunning in normal mode.\e[0m"
else
	echo -e "\e[1;31mInvalid Arguments.\e[0m"
	exit 1
fi

if [ "$1" == "--mtgame-upd" ]; then
	cd
	cd minetest
	echo -e "\e[1mRemoving old subgame | 1 of 3\e[0m"
	rm -r --interactive=none minetest_game
	echo -e "\e[1mCloning new subgame | 2 of 3\e[0m"
	git clone https://github.com/minetest/minetest_game
	echo -e "\e[1;32mDONE!\e[0;1m | 3 of 3\e[0m"
	exit 0
fi

cd
cd minetest
echo -e "\e[1mUpdating DPKG Lists | 1 of 9\e[0m"
sudo apt-get update
echo -e "\e[1mUpdating Dependancies | 2 of 9\e[0m"
sudo apt-get -y install build-essential cmake git libirrlicht-dev libbz2-dev libgettextpo-dev libfreetype6-dev libpng12-dev libjpeg-dev libxxf86vm-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev libopenal-dev libhiredis-dev libcurl3-dev
if [ "$1" == "--clone" ]; then
	echo -e "\e[1mRemoving Old Minetest | 3 of 9 | 1 of 2\e[0m"
	cd ..
	rm -r --interactive=never minetest
	echo -e "\e[1mCloning New Minetest | 3 of 9 | 2 of 2\e[0m"
	git clone https://github.com/minetest/minetest
	cd minetest
	echo -e "\e[1mCloning Complete | 3 of 9 | \e[32mDONE!\e[0m"
else
	echo -e "\e[1mPulling Minetest | 3 of 9\e[0m"
	git pull
fi
echo -e "\e[1mRunning CMAKE | 4 of 9\e[0m"
cmake . -DENABLE_GETTEXT=1 -DENABLE_FREETYPE=1 -DENABLE_LEVELDB=1 -DENABLE_REDIS=1
echo -e "\e[1mCompiling | 5 of 9\e[0m"
make -j 4
cd games
echo -e "\e[1mRemoving old subgame | 6 of 9\e[0m"
rm --interactive=never -r minetest_game
echo -e "\e[1mGetting Subgame | 7 of 9\e[0m"
git clone https://github.com/minetest/minetest_game.git
echo -e "\e[1mRemoving Preview Clientmod | 8 of 9\e[0m"
cd ../clientmods
rm -r --interactive=never preview
echo -e "\e[1;32mDONE!\e[0;1m | 9 of 9\e[0m"
exit 0
