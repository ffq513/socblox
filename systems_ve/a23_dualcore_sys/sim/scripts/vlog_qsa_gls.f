
// -f ${SOCBLOX}/common/rtl/common_rtl.f
// +define+AXI4_SVF_ROM_NAME=axi4_rom
+incdir+${COMMON_RTL}/axi4
${SOCBLOX}/common/bfm/axi4_rom/axi4_svf_rom.sv
// +define+AXI4_SVF_SRAM_NAME=axi4_sram
${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv

+define+GLS

${COMMON_RTL}/uart/uart_if.sv
${COMMON_BFM}/uart/uart_bfm.sv


${COMMON_BFM}/timebase/timebase.sv
${COMMON_BFM}/axi4_monitor/axi4_monitor_bfm.sv


// ${SOCBLOX}/units/interconnects/axi4/axi4_wb_bridge.sv
// ${SOCBLOX}/units/wb_uart/wb_uart.sv

// ${SOCBLOX}/common/bfm/uart/uart_bfm.sv

${BUILD_DIR}/a23_dualcore_sys_synth/simulation/modelsim/a23_dualcore_sys_top.vo
${SYSTEMS}/a23_dualcore_sys/a23_dualcore_sys_top_w.sv

-f ${COMMON_DIR}/fpga/altera_cyclonev_libs.f

${SOCBLOX}/systems_ve/a23_dualcore_sys/tb/a23_dualcore_sys_tb.sv


