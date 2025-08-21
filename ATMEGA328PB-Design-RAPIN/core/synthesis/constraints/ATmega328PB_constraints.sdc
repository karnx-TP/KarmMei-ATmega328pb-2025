# #########################################################################
# Cadence genus synthesis design constraints
# AUTHOR : Rapin.P
# DATE : 15/11/20204
# #########################################################################


# ----------------------------------------------------------------------------
# 1. Create Clock
# ----------------------------------------------------------------------------

# Assume 1MHz
# create_clock -name CLK -period 50 [ get_ports "cp2" ]
create_clock -name CLK -period 50 [ get_ports "clk" ]

# Apply uncertainty factor on all clocks
set_clock_uncertainty -setup 0.60                           [get_clocks]
set_clock_uncertainty -hold  0.03                           [get_clocks]
# Clock properties in Max Condition
set_clock_latency    0.70 -max -source -early -dynamic 0.32 [get_clocks]
set_clock_latency    0.79 -max -source -late  -dynamic 0.43 [get_clocks]
set_clock_latency    1.00 -max                              [get_clocks]
set_clock_transition 0.50 -max                              [get_clocks]
# Clock properties in Min Condition
set_clock_latency    0.56 -min -source -early -dynamic 0.21 [get_clocks]
set_clock_latency    0.60 -min -source -late  -dynamic 0.24 [get_clocks]
set_clock_latency    1.00 -min                              [get_clocks]
set_clock_transition 0.30 -min                              [get_clocks]

# create_clock -name wdt_clk -period 50 [ get_ports wdt_clk ]

# ----------------------------------------------------------------------------
# 1.2 Create Clock for Latches
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 1.1 Identyfy Clock gating
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 1.1 Check Clock gating
# ----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# 2. Global Delay
# -----------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# 3. Ideal Network for clock
# ------------------------------------------------------------------------------
set_ideal_network -no_propagate [get_nets clk]
#set_ideal_network -no_propagate [get_nets PLS_m/SPI_m/O_CLK]
#set_ideal_network -no_propagate [get_pins "AES_Controlpath/BUF_*_CG/GC AES_Controlpath/DATA_*_CG/GC AES_Controlpath/KEY_*_CG/GC AES_Controlpath/CLK_Control_CG/GC"]
# ------------------------------------------------------------------------------
# 4. False Path and Multicycle if you have ?
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 4. Input/Output Contraints
# ------------------------------------------------------------------------------

set_input_delay  10 -clock CLK             [all_inputs ]
set_output_delay 30 -clock CLK             [all_outputs]

# Clock signals
remove_input_delay                        [get_ports "clk" ]
# Reset signals
remove_input_delay                        [get_ports "ireset"   ]
# ------------------------------------------------------------------------------
# 5. Driving Cell/Output Load Contraints
# ------------------------------------------------------------------------------

set_driving_cell -lib_cell BUFHDV8RD  [all_inputs]
remove_driving_cell [get_ports "clk"]
set_driving_cell -lib_cell CLKBUFHDV32  [get_ports "clk"]
#set_driving_cell -lib_cell BUFX12 [get_ports "ABE_CPR_RFCLK APM_CPR_PORSYS"]

#set_load -max [DQHDV0] [all_outputs]
#set_load -min [DQHDV0] [all_outputs]

set_load -max [ load_of scc013ull_hd_rvt_tt_v1p5_25c_basic/DQHDV0/D] [all_outputs]
set_load -min [ load_of scc013ull_hd_rvt_tt_v1p5_25c_basic/DQHDV0/D] [all_outputs]

#set_load -max -lib_cell DFFX4 [all_outputs]
#set_load -min -lib_cell DFFX4 [all_outputs]


# ------------------------------------------------------------------------------
# 5. List of ungrouping module
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 6. Exclusion list for clock gating
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# 7. Interclock Relation
# ------------------------------------------------------------------------------
