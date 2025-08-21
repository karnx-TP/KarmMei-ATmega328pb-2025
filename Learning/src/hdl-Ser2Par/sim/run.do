##
quit -sim
vlib work

#--------------------------------#
#--      Compile Source        --#
#--------------------------------#
vlog -cover bcse -work work ../ser2par.sv

#--------------------------------#
#--     Compile Package        --#
#--------------------------------#

#--------------------------------#
#--   	Compile Test Bench     --#
#--------------------------------#
vlog -work work ../ser2par_tb.sv

vsim -t 100ps -novopt work.ser2par_tb

view wave

do wave.do

view structure
view signals

run -all

