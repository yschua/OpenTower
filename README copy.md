# OpenTower

Dependencies
- love
- busted (install with luarocks)
  - on windows use mingw32 compiler
  - build luajit
  - build lfs
    gcc -shared -O2 -o lfs.dll lfs.c lfs.def -I C:\Projects\luajit\src -llibluajit-5.1 -L C:\Projects\luajit\src
  - build luaterm
    gcc -shared -O2 -o core.dll core.c -I C:\Projects\luajit\src -llibluajit-5.1 -L C:\Projects\luajit\src
  - build luasystem
    modify the makefile


luajit "C:\Program Files (x86)\LuaRocks\systree\lib\luarocks\rocks-5.1\busted\2.0.0-1\bin\busted" --ignore-lua .

TODO move luarocks out of program files
