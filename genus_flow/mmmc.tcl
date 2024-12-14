# RC corners
create_rc_corner -name "cworst_100C" -temperature 100 
create_rc_corner -name "cworst_m40C" -temperature -40

# Library sets
create_library_set -name SV1T1 -timing { \
  /2tb/PDK_yedek/PDK/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib \
}

create_library_set -name SV1T2 -timing { \
/2tb/PDK_yedek/PDK/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_n40C_1v60.lib \
}

# Operating conditions
create_opcond -name SHT -process 1 -voltage 1.6 -temperature 100
create_opcond -name SLT -process 1 -voltage 1.6 -temperature -40

create_timing_condition -name SHT -opcond SHT -library_sets { SV1T1 }
create_timing_condition -name SLT -opcond SLT -library_sets { SV1T2 }


create_constraint_mode -name FUNC -sdc_files [list ./constraints/${DESIGN}.sdc ]

# Delay corners = combinations of RC corners + timing conditions
create_delay_corner -name SHT_Cworst -timing_condition SHT -rc_corner cworst_100C
create_delay_corner -name SLT_Cworst -timing_condition SLT -rc_corner cworst_m40C


# Analysis views = combinations of delay corners + Operating mode
create_analysis_view -name SHT_Cworst_FUNC -constraint_mode FUNC -delay_corner SHT_Cworst
create_analysis_view -name SLT_Cworst_FUNC -constraint_mode FUNC -delay_corner SLT_Cworst

# Select active analysis views
#set_analysis_view -setup {SHT_Cworst_FUNC } -hold {SHT_Cworst_FUNC}
set_analysis_view -setup {SLT_Cworst_FUNC } -hold {SLT_Cworst_FUNC}
