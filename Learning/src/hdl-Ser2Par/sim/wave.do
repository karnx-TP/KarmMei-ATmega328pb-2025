onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ser2par_tb/TT
add wave -noupdate /ser2par_tb/RstB
add wave -noupdate /ser2par_tb/Clk
add wave -noupdate /ser2par_tb/SerDataIn
add wave -noupdate /ser2par_tb/SerDataEn
add wave -noupdate /ser2par_tb/ParDataOut
add wave -noupdate -radix hexadecimal /ser2par_tb/ParDataOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {17900 ps}
