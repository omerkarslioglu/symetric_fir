#################################################################################
#
# Created by Genus(TM) Synthesis Solution 19.14-s108_1 on Wed Nov 20 06:26:06 +03 2024
#
#################################################################################

## library_sets
create_library_set -name SV1T1 \
    -timing { /2tb/PDK_yedek/PDK/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib }
create_library_set -name SV1T2 \
    -timing { /2tb/PDK_yedek/PDK/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_n40C_1v60.lib }

## opcond
create_opcond -name SHT \
    -process 1.0 \
    -voltage 1.6 \
    -temperature 100.0
create_opcond -name SLT \
    -process 1.0 \
    -voltage 1.6 \
    -temperature -40.0

## timing_condition
create_timing_condition -name SHT \
    -opcond SHT \
    -library_sets { SV1T1 }
create_timing_condition -name SLT \
    -opcond SLT \
    -library_sets { SV1T2 }

## rc_corner
create_rc_corner -name cworst_100C \
    -temperature 100.0 \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}
create_rc_corner -name cworst_m40C \
    -temperature -40.0 \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name SHT_Cworst \
    -early_timing_condition { SHT } \
    -late_timing_condition { SHT } \
    -early_rc_corner cworst_100C \
    -late_rc_corner cworst_100C
create_delay_corner -name SLT_Cworst \
    -early_timing_condition { SLT } \
    -late_timing_condition { SLT } \
    -early_rc_corner cworst_m40C \
    -late_rc_corner cworst_m40C

## constraint_mode
create_constraint_mode -name FUNC \
    -sdc_files { rpt/final_symmetricFIR.FUNC.sdc }

## analysis_view
create_analysis_view -name SHT_Cworst_FUNC \
    -constraint_mode FUNC \
    -delay_corner SHT_Cworst
create_analysis_view -name SLT_Cworst_FUNC \
    -constraint_mode FUNC \
    -delay_corner SLT_Cworst

## set_analysis_view
set_analysis_view -setup { SLT_Cworst_FUNC } \
                  -hold { SLT_Cworst_FUNC }
