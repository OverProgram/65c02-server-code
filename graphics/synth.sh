#!/bin/bash

cd out
xst -ifn graphics.scp
ngdbuild graphics
map graphics.ngd -w -p XC6SLX4-cpg196
par graphics.ncd -w graphics_out.ncd
bitgen -w graphics_out.ncd graphics.bit
cp graphics.bit ../graphics.bit
