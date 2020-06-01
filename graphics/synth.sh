#!/bin/bash

cd out
find ../src -iname "*.vhdl" -exec echo "vhdl work {}" \; > graphics.prj
cp ../graphics.ucf graphics.ucf
xst -ifn graphics.scp
ngdbuild -uc graphics.ucf graphics
map -detail graphics.ngd -w -p XC6SLX4-cpg196
par graphics.ncd -w graphics_out.ncd
bitgen -w graphics_out.ncd graphics.bit
cp graphics.bit ../graphics.bit
