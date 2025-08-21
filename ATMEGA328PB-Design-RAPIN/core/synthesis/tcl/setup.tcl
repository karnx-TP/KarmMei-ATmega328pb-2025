
# *********************************************************
# * Script Name  : Genus initialization script
# *********************************************************
date

set LOCAL_DIR       "[exec pwd]/.."
set SYNTH_DIR       "${LOCAL_DIR}/work"
set TCL_PATH		"${LOCAL_DIR}/tcl $LOCAL_DIR/constraints"
set REPORTS_PATH    "${LOCAL_DIR}/work/reports" 
set RESULTS_PATH    "${LOCAL_DIR}/work/results" 
set LIB_PATH		"/home/jirath/01lib/"
set RTL_PATH		"$LOCAL_DIR/rtl"
set DESIGN 		    "ATmega328pb"

set MSGS_TO_BE_SUPRESSED {LBR-58 LBR-40 LBR-41 VLOGPT-35}


# Baseline Libraries

set LIB_LIST { \
ss_g_1v08_125c.lib \
}

set LEF_LIST { \
tsmc13fsg_8lm_tech.lef \
}

# Baseline RTL
set RTL_LIST { \
/src/core/alu_avr.sv \
/src/core/avr_core2.sv \
/src/core/bit_processor.sv \
/src/core/io_adr_dec2.sv \
/src/core/io_reg_file2.sv \
/src/core/pm_fetch_dec4.sv \
/src/core/reg_file.sv \
/src/core/fast_adders/Adder.sv \
/src/core/fast_adders/CLA16B.sv \
/src/core/fast_adders/CLA16B1x16S.sv \
/src/core/multiplier/mul8x8comb.sv \
/src/core/multiplier/avr_mul.sv  \

/src/common/synchronizer.v  \

/src/TmrCnt/mux_after_prescaler0.v \
/src/TmrCnt/prescaler0.v \
/src/TmrCnt/prescaler1.v \
/src/TmrCnt/prescaler_reset.v \
/src/TmrCnt/Timer_Counter.v \
/src/TmrCnt/Timer_Counter0_8_bit.v \
/src/TmrCnt/Timer_Counter2_8_bit.v \
/src/TmrCnt/Timer_Counter_16_bit.v \

/src/SPI/SPI_0.sv \
/src/SPI/SPI_1.v \

/src/USART/FIFO.v \
/src/USART/USART_Clk.v \
/src/USART/USARTn.v \

/src/IO_Ports/IO_Port.v \
/src/IO_Ports/Port_B.v \
/src/IO_Ports/Port_C.v \
/src/IO_Ports/Port_D.v \
/src/IO_Ports/Port_E.v \
/src/IO_Ports/rg_md.v \

/src/TWI/TWIn.v \
/src/Ext_Int/Ext_Int.v \

/src/Wrapper/ATmega328pb_synt_top.sv\
}

# set CAP_TABLE_FILE ../libraries/tsmc13fsg.capTbl

suppress_messages {LBR-30 LBR-31 LBR-40 LBR-41 LBR-72 LBR-77 LBR-162}
set_db hdl_track_filename_row_col true 
set_db lp_power_unit mW 
set_db init_lib_search_path $LIB_PATH 
set_db script_search_path $TCL_PATH 
set_db init_hdl_search_path $RTL_PATH 
set_db error_on_lib_lef_pin_inconsistency true

# set_db library $LIB_LIST
read_libs $LIB_LIST
# # PLE
# set_db lef_library $LEF_LIST 
# read_physical -lef $LEF_LIST

set_db cap_table_file $CAP_TABLE_FILE 
# set_db qrc_tech_file $QRC_TECH_FILE

