#!/bin/bash

cd out
xst -ifn graphics.scp
ngdbuild graphics
map graphics.ngd -p XC6SLX4-cpg196
par graphics.ncd graphics_out.ncd
