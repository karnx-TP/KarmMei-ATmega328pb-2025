# #########################################################################
# Cadence genus synthesis script
# AUTHOR : Rapin.P
# DATE : 15/11/20204
# #########################################################################

source "${TCL_PATH}/setup.tcl"

# read rtl and constriants
read_hdl   -language sv ${RTL_LIST}
elaborate
read_sdc -stop_on_errors   ${DESIGN}_constraints.sdc

# set synthesis effort
set_db  syn_generic_effort      high
set_db  syn_map_effort          high
set_db  syn_opt_effort          high

# synthesis 
syn_generic
syn_map
syn_opt

# check design
check_design -unresolved      > report/${DESIGN}_check_design_unresolved.rpt
check_design -summary         > report/${DESIGN}_check_design.rpt

# report
report_timing     -nets -path_type full        > report/${DESIGN}_report_timing.rpt
report_timing     -nets -nworst 5          > report/${DESIGN}_report_timing.rpt
report_timing     -unconstrained          > report/${DESIGN}_report_timing_unconstrained.rpt
report_power                > report/${DESIGN}_report_power.rpt
report_area                 > report/${DESIGN}_report_area.rpt
report_qor                  > report/${DESIGN}_report_qor.rpt
report_summary              > report/${DESIGN}_summary.rpt
report_design_rules         > report/${DESIGN}_design_rules.rpt
report_gates                > report/${DESIGN}_gates.rpt
report_messages             > report/${DESIGN}_messages.rpt

# results
write_netlist               > results/${DESIGN}_netlist.v
# write_hdl                   > results/${DESIGN}_netlist.v
write_sdc                   > results/${DESIGN}_sdc.sdc
write_sdf   -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > results/${DESIGN}.sdf