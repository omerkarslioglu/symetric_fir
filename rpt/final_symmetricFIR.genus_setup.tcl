################################################################################
#
# Genus(TM) Synthesis Solution setup file
# Created by Genus(TM) Synthesis Solution 19.14-s108_1
#   on 11/20/2024 06:26:07
#
# This file can only be run in Genus Common UI mode.
#
################################################################################


# This script is intended for use with Genus(TM) Synthesis Solution version 19.14-s108_1


# Remove Existing Design
################################################################################
if {[::legacy::find -design design:symmetricFIR] ne ""} {
  puts "** A design with the same name is already loaded. It will be removed. **"
  delete_obj design:symmetricFIR
}


# To allow user-readonly attributes
################################################################################
::legacy::set_attribute -quiet force_tui_is_remote 1 /


# Source INIT Setup file
################################################################################
source rpt/final_symmetricFIR.genus_init.tcl

phys::read_script rpt/final_symmetricFIR.g.gz
puts "\n** Restoration Completed **\n"


# Data Integrity Check
################################################################################
# program version
if {"[string_representation [::legacy::get_attribute program_version /]]" != "19.14-s108_1"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden program_version: 19.14-s108_1  current program_version: [string_representation [::legacy::get_attribute program_version /]]"
}
# license
if {"[string_representation [::legacy::get_attribute startup_license /]]" != "Genus_Synthesis"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden license: Genus_Synthesis  current license: [string_representation [::legacy::get_attribute startup_license /]]"
}
# slack
set _slk_ [::legacy::get_attribute slack design:symmetricFIR]
if {[regexp {^-?[0-9.]+$} $_slk_]} {
  set _slk_ [format %.1f $_slk_]
}
if {$_slk_ != "-3761.1"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden slack: -3761.1,  current slack: $_slk_"
}
unset _slk_
# multi-mode slack
if {"[string_representation [::legacy::get_attribute slack_by_mode design:symmetricFIR]]" != "{{mode:symmetricFIR/SLT_Cworst_FUNC -3761.1}}"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden slack_by_mode: {{mode:symmetricFIR/SLT_Cworst_FUNC -3761.1}}  current slack_by_mode: [string_representation [::legacy::get_attribute slack_by_mode design:symmetricFIR]]"
}
# tns
set _tns_ [::legacy::get_attribute tns design:symmetricFIR]
if {[regexp {^-?[0-9.]+$} $_tns_]} {
  set _tns_ [format %.0f $_tns_]
}
if {$_tns_ != "56234"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden tns: 56234,  current tns: $_tns_"
}
unset _tns_
# cell area
set _cell_area_ [::legacy::get_attribute cell_area design:symmetricFIR]
if {[regexp {^-?[0-9.]+$} $_cell_area_]} {
  set _cell_area_ [format %.0f $_cell_area_]
}
if {$_cell_area_ != "55995"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden cell area: 55995,  current cell area: $_cell_area_"
}
unset _cell_area_
# net area
set _net_area_ [::legacy::get_attribute net_area design:symmetricFIR]
if {[regexp {^-?[0-9.]+$} $_net_area_]} {
  set _net_area_ [format %.0f $_net_area_]
}
if {$_net_area_ != "47862"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden net area: 47862,  current net area: $_net_area_"
}
unset _net_area_
# library domain count
if {[llength [::legacy::find /libraries -library_domain *]] != "1"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden # library domains: 1  current # library domains: [llength [::legacy::find /libraries -library_domain *]]"
}
