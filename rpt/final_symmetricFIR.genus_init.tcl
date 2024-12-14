################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/20/2024 06:26:07
#
################################################################################

      if { ![is_common_ui_mode] } {
        error "This script must be loaded into an 'innovus -stylus' session."
      }
    


read_mmmc rpt/final_symmetricFIR.mmmc.tcl

read_physical -lef {/2tb/PDK_yedek/PDK/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef}

read_netlist rpt/final_symmetricFIR.v.gz

init_design -skip_sdc_read
