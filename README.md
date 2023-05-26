# gmod-linux-patcher
Make native Linux Garry's Mod playable and fast.

### Installation and Usage
`wget -q https://raw.githubusercontent.com/ret-0/gmod-linux-patcher/master/gmod-linux-patcher.sh && sh gmod-linux-patcher.sh`

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
4. Replace `ulimit -n 2048` in hl2.sh with `ulimit -n [Output of ulimit -Hn]`
5. Add `export mesa_glthread=true` before game execution in hl2.sh.
6. Find `exec ${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} "$@"` and replace it with `exec ${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} -malloc=system -swapcores -dxlevel 98 -vulkan "$@"`
