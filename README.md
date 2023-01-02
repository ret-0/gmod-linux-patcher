# gmod-linux-patcher
Make native Linux Garry's Mod playable and fast.
### Requirements (mostly for DXVK):
- git
- wine 3.10 or newer
- Meson build system (at least version 0.49)
- Mingw-w64 compiler and headers (at least version 10.0)
- glslang compiler

### Installation and Usage
```
sh gmod-linux-patcher.sh
```

### Manual Patching
1. Right-click on Garry's Mod in Steam -> Properties -> Betas -> Select 'x86_64 - Chromium + 64-bit binaries'.
2. Download and apply GModCEFCodecFix.
3. Set heap size and filesystem_max_stdio_read in garrysmod/cfg/valve.rc.
```
mem_min_heapsize 256
mem_max_heapsize [memory allocation in megabytes, e.g. 8192 for 8 GiB]
mem_max_heapsize_dedicated [same as above]
filesystem_max_stdio_read [ulimit -Hn]
```
4. Replace `ulimit -n 2048` in hl2.sh with `ulimit -n [ulimit -Hn]`
5. Add `export mesa_glthread=true` before game execution in hl2.sh.
6. Find `exec ${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} "$@"` and replace it with `LD_PRELOAD=libdxvk_d3d9.so exec ${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} -malloc=system -swapcores -dxlevel 98 -vulkan "$@"`
7. Compile native DXVK.
```
git clone --recursive https://github.com/doitsujin/dxvk.git
cd dxvk
./package-native.sh master build
```
8. Copy build/usr/lib/* to GarrysMod/bin/linux64/.
