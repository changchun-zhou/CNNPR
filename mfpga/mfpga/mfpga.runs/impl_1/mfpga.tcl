proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir F:/Programdata/CNNPR/mfpga/mfpga/mfpga.cache/wt [current_project]
  set_property parent.project_path F:/Programdata/CNNPR/mfpga/mfpga/mfpga.xpr [current_project]
  set_property ip_repo_paths f:/Programdata/CNNPR/mfpga/mfpga/mfpga.cache/ip [current_project]
  set_property ip_output_repo f:/Programdata/CNNPR/mfpga/mfpga/mfpga.cache/ip [current_project]
  add_files -quiet F:/Programdata/CNNPR/mfpga/mfpga/mfpga.runs/synth_1/mfpga.dcp
  read_xdc F:/Programdata/CNNPR/mfpga/fpga.xdc
  link_design -top mfpga -part xc7z020clg484-1
  write_hwdef -file mfpga.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force mfpga_opt.dcp
  report_drc -file mfpga_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force mfpga_placed.dcp
  report_io -file mfpga_io_placed.rpt
  report_utilization -file mfpga_utilization_placed.rpt -pb mfpga_utilization_placed.pb
  report_control_sets -verbose -file mfpga_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force mfpga_routed.dcp
  report_drc -file mfpga_drc_routed.rpt -pb mfpga_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file mfpga_timing_summary_routed.rpt -rpx mfpga_timing_summary_routed.rpx
  report_power -file mfpga_power_routed.rpt -pb mfpga_power_summary_routed.pb -rpx mfpga_power_routed.rpx
  report_route_status -file mfpga_route_status.rpt -pb mfpga_route_status.pb
  report_clock_utilization -file mfpga_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force mfpga.mmi }
  write_bitstream -force mfpga.bit 
  catch { write_sysdef -hwdef mfpga.hwdef -bitfile mfpga.bit -meminfo mfpga.mmi -file mfpga.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

