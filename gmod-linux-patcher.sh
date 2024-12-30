#!/bin/sh -e

DIRECTORY="$1"
if [ "$#" -ne 1 ]; then
	read -p "Enter Garry's Mod directory (e.g: /home/hermes/.steam/steam/steamapps/common/GarrysMod/): " DIRECTORY
fi

if ! [ -d "$DIRECTORY" ]; then
	echo 'Directory not found!'
	echo ''
	exit 1
fi

read -p "How much memory should Garry's Mod allocate in megabytes? (4096 for 4GiB, 8192 for 8GiB, 16384 for 16GiB, etc.): " HEAPSIZE
echo ''

echo "Before continuing please make sure Garry's Mod is on the 64-bit branch!"
echo "Right-click on Garry's Mod in Steam -> Properties -> Betas -> Select 'x86_64 - Chromium + 64-bit binaries'."
echo 'Press enter to continue.'
echo ''
read

echo "> Patching $DIRECTORY!"

echo '> Downloading and applying GModCEFCodecFix...'
wget -q https://github.com/solsticegamestudios/GModCEFCodecFix/releases/latest/download/GModCEFCodecFix-Linux -O /tmp/GModCEFCodecFix-Linux
chmod +x /tmp/GModCEFCodecFix-Linux
script -qefc '/tmp/GModCEFCodecFix-Linux' /dev/null < <(printf 'no\n\n')

if ! grep -q 'gmod-linux-patcher' "$DIRECTORY/garrysmod/cfg/valve.rc"; then
	echo '> Setting mem_max_heapsize and filesystem_max_stdio_read in garrysmod/cfg/valve.rc...'
	echo "// gmod-linux-patcher
mem_min_heapsize 256
mem_max_heapsize $HEAPSIZE
mem_max_heapsize_dedicated $HEAPSIZE
filesystem_max_stdio_read $(ulimit -Hn)
" | cat - "$DIRECTORY/garrysmod/cfg/valve.rc" > /tmp/valve.rc
	mv /tmp/valve.rc "$DIRECTORY/garrysmod/cfg/valve.rc"
fi

if ! grep -q 'gmod-linux-patcher' "$DIRECTORY/hl2.sh"; then
	echo "> Replacing 'ulimit -n 2048' in hl2.sh with 'ulimit -n $(ulimit -Hn)'..."
	echo "> Adding 'export mesa_glthread=true' to hl2.sh..."
	sed -i "s/ulimit -n 2048/# gmod-linux-patcher\nulimit -n $(ulimit -Hn)\nexport mesa_glthread=true/g" "$DIRECTORY/hl2.sh"

	echo '> Modifying game arguments...'
	NEW='exec \${GAME_DEBUGGER} "\${GAMEROOT}"/\${GAMEEXE} -malloc=system -swapcores -vulkan "\$@"'
	sed -i 's/exec ${GAME_DEBUGGER} "${GAMEROOT}"\/${GAMEEXE} "$@"/# gmod-linux-patcher\n        exec ${GAME_DEBUGGER} "${GAMEROOT}"\/${GAMEEXE} -malloc=system -swapcores -dxlevel 98 -vulkan "$@"/g' "$DIRECTORY/hl2.sh"
fi

echo '> Done!'
