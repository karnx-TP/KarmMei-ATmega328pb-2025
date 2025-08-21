# Create library sets
create_library_set -name scc013ull_hd_rvt_ss_v1p35_125c_basic       -timing { scc013ull_hd_rvt_ss_v1p35_125c_basic.lib }
create_library_set -name scc013ull_hd_rvt_tt_v1p5_25c_basic    -timing { scc013ull_hd_rvt_tt_v1p5_25c_basic.lib }
create_library_set -name scc013ull_hd_rvt_ff_v1p65_85c_basic      -timing { scc013ull_hd_rvt_ff_v1p65_85c_basic.lib }
create_library_set -name scc013ull_hd_rvt_ff_v1p65_-40c_basic      -timing { scc013ull_hd_rvt_ff_v1p65_-40c_basic.lib }

# Create operating conditions 
create_opcond -name ss_v1p35_125c -process 1 -voltage 1.35 -temperature 125
create_opcond -name tt_v1p5_25c   -process 1 -voltage 1.5  -temperature 25
create_opcond -name ff_v1p65_85c  -process 1 -voltage 1.65 -temperature 85
create_opcond -name ff_v1p65_-40c -process 1 -voltage 1.65 -temperature -40

# Create timing conditions
create_timing_condition -name timing_cond_ss_v1p35_125c -opcond ss_v1p35_125c -library_sets { scc013ull_hd_rvt_ss_v1p35_125c_basic  }
create_timing_condition -name timing_cond_tt_v1p5_25c   -opcond tt_v1p5_25c   -library_sets { scc013ull_hd_rvt_tt_v1p5_25c_basic    }
create_timing_condition -name timing_cond_ff_v1p65_85c  -opcond ff_v1p65_85c  -library_sets { scc013ull_hd_rvt_ff_v1p65_85c_basic   }
create_timing_condition -name timing_cond_ff_v1p65_-40c -opcond ff_v1p65_-40c -library_sets { scc013ull_hd_rvt_ff_v1p65_-40c_basic  }

# Create rc corners
# create_rc_corner -name Cmin -preRoute_res {1.0} \
# -preRoute_cap {1.0} \
# -preRoute_clkres {0.0} \
# -preRoute_clkcap {0.0} \
# -postRoute_res {1.0} \
# -postRoute_cap {1.0} \
# -postRoute_xcap {1.0} \
# -postRoute_clkres {0.0} \
# -postRoute_clkcap {0.0} 

# create_rc_corner -name Cmax -preRoute_res {1.0} \
# -preRoute_cap {1.0} \
# -preRoute_clkres {0.0} \
# -preRoute_clkcap {0.0} \
# -postRoute_res {1.0} \
# -postRoute_cap {1.0} \
# -postRoute_xcap {1.0} \
# -postRoute_clkres {0.0} \
# -postRoute_clkcap {0.0} 

#  Create delay corners
create_delay_corner -name delay_corner_ss_v1p35_125c \
-early_timing_condition timing_cond_ss_v1p35_125c -late_timing_condition timing_cond_wcl_slow \ 
# -early_rc_corner rc_corner -late_rc_corner rc_corner

create_delay_corner -name delay_corner_tt_v1p5_25c   \
-early_timing_condition timing_cond_tt_v1p5_25c   -late_timing_condition timing_cond_wcl_fast \ 
# -early_rc_corner rc_corner -late_rc_corner rc_corner

create_delay_corner -name delay_corner_ff_v1p65_85c  \
-early_timing_condition timing_cond_ff_v1p65_85c  -late_timing_condition timing_cond_wcl_fast \ 
# -early_rc_corner rc_corner -late_rc_corner rc_corner

create_delay_corner -name delay_corner_ff_v1p65_-40c \
-early_timing_condition timing_cond_ff_v1p65_-40c -late_timing_condition timing_cond_wcl_fast \ 
# -early_rc_corner rc_corner -late_rc_corner rc_corner

# Create constraint modes
create_constraint_mode -name functional_wcl_slow -sdc_files { slow.sdc }
create_constraint_mode -name functional_wcl_fast -sdc_files { fast.sdc }

# Create analysis views
create_analysis_view -name view_wcl_slow -constraint_mode functional_wcl_slow -delay_corner 
delay_corner_wcl_slow
create_analysis_view -name view_wcl_fast -constraint_mode functional_wcl_fast -delay_corner 
delay_corner_wcl_fast

# Set up analysis views
set_analysis_view -setup { view_wcl_slow view_wcl_fast view_wcl_typical}
