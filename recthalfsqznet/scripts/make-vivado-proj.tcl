# Copyright (C) 2017 Kaan Kara - Systems Group, ETH Zurich

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#*************************************************************************

# Creates a Vivado project ready for synthesis and launches bitstream generation
if {$argc != 4} {
  puts "Expected: <proj_name> <proj_dir> <xdc_dir> <ip_repo>"
  exit
}

# project name, target dir and FPGA part to use
set config_proj_name [lindex $argv 0]
set config_proj_dir [lindex $argv 1]
set config_proj_part "xczu3eg-sbva484-1-e"

# other project config

set xdc_dir [lindex $argv 2]
set ip_repo [lindex $argv 3]

puts "config_proj_name: ${config_proj_name}"
puts "config_proj_dir: ${config_proj_dir}"
puts "xdc_dir:  ${xdc_dir}"
puts "ip_repo: ${ip_repo}"

# set up project
create_project -force $config_proj_name $config_proj_dir -part $config_proj_part

set_property board_part em.avnet.com:ultra96v1:part0:1.2 [current_project]

# Add PYNQ XDC
# add_files -fileset constrs_1 -norecurse "${xdc_dir}/PYNQ-Z1_C.xdc"

set_property  ip_repo_paths $ip_repo [current_project]
update_ip_catalog

source "${xdc_dir}/procsys.tcl"

save_bd_design

make_wrapper -files [get_files $config_proj_dir/$config_proj_name.srcs/sources_1/bd/procsys/procsys.bd] -top
add_files -norecurse $config_proj_dir/$config_proj_name.srcs/sources_1/bd/procsys/hdl/procsys_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
# set_property STEPS.SYNTH_DESIGN.ARGS.DIRECTIVE AlternateRoutability [get_runs synth_1]
# set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]

# set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
# set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
# set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_1]
# set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_1]
# set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]

# launch_runs impl_1 -to_step write_bitstream -jobs 2
# wait_on_run impl_1

