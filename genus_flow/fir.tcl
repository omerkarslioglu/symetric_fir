set_db init_hdl_search_path {./hdl}

set DESIGN symmetricFIR
set _REPORTS_PATH   rpt
# enable Unified Metrics
um::enable_metric -on
um::push_snapshot_stack


read_mmmc mmmc.tcl
read_physical -lef  /2tb/PDK_yedek/PDK/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef

read_hdl ${DESIGN}.v

# read the constraint file
#create_constraint_mode -name FUNC -sdc_files [list ./constraints/${DESIGN}.sdc ]

elaborate ${DESIGN}
init_design
set_analysis_view -setup SLT_Cworst_FUNC -hold SLT_Cworst_FUNC
syn_generic
syn_map
syn_opt
write_hdl > ${DESIGN}_final.v.gz
write_db ${DESIGN}.db
write_sdf -edges check_edge > ${DESIGN}.sdf.gz
write_do_lec -revised_design ${DESIGN}_final.v.gz -logfile lec.log > rtl2final_direct.lec.do

um::pop_snapshot_stack
um::create_snapshot -name syn_opt -categories all
#report_metric -format html -file ${_REPORTS_PATH}/qor.html
um::push_snapshot_stack

# reports
write_snapshot -outdir rpt -tag final -innovus
report_timing -lint -verbose                           > ${_REPORTS_PATH}/${DESIGN}_timing_lint.rpt
report_clocks                                          > ${_REPORTS_PATH}/${DESIGN}_clocks.rpt
report_clocks -generated                               >>${_REPORTS_PATH}/${DESIGN}_clocks.rpt
report_boundary_opt                                    > ${_REPORTS_PATH}/${DESIGN}_boundary_opto.rpt
report_area                                            > ${_REPORTS_PATH}/${DESIGN}_area.rpt
report_power -hier -verbose                            > ${_REPORTS_PATH}/${DESIGN}_power.rpt
report_gates -power                                    > ${_REPORTS_PATH}/${DESIGN}_gates_power.rpt
report_sequential -deleted                             > ${_REPORTS_PATH}/${DESIGN}_sequential_deleted.rpt
report_sequential -hier                                > ${_REPORTS_PATH}/${DESIGN}_sequential.rpt
report_clock_gating -detail -gated_ff -ungated_ff      > ${_REPORTS_PATH}/${DESIGN}_clock_gating_summary.rpt
report_clock_gating -detail -gated_ff                  > ${_REPORTS_PATH}/${DESIGN}_clock_gating_gated.rpt
report_clock_gating -detail -ungated_ff                > ${_REPORTS_PATH}/${DESIGN}_clock_gating_ungated.rpt
report_port [all_outputs]                              > ${_REPORTS_PATH}/${DESIGN}_outPorts.rpt
report_port [all_inputs]                               > ${_REPORTS_PATH}/${DESIGN}_inPorts.rpt
report_messages -warning -all                          > ${_REPORTS_PATH}/${DESIGN}_warnings.rpt 
report_messages -error -all                            > ${_REPORTS_PATH}/${DESIGN}_errors.rpt 
report_case_analysis                                   > ${_REPORTS_PATH}/${DESIGN}_case_analysis.rpt 
