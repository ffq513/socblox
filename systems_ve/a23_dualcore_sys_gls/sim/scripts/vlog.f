
// -f ${SOCBLOX}/common/rtl/common_rtl.f
// +define+AXI4_SVF_ROM_NAME=axi4_rom
// ${SOCBLOX}/common/bfm/axi4_rom/axi4_svf_rom.sv
// +define+AXI4_SVF_SRAM_NAME=axi4_sram
// ${SOCBLOX}/common/bfm/axi4_svf_sram/axi4_svf_sram.sv

${COMMON_BFM}/a23_tracer/a23_tracer_bfm.sv
${COMMON_BFM}/uart/uart_bfm.sv


${COMMON_BFM}/bidi_message_queue_direct_bfm/bidi_message_queue.sv

${COMMON_BFM}/generic_sram_byte_en/generic_sram_byte_en.sv
${COMMON_BFM}/generic_rom/generic_rom.sv
${COMMON_BFM}/../sram/generic_sram_line_en_dualport.v
${COMMON_BFM}/../sram/generic_sram_byte_en_dualport.v
${COMMON_BFM}/timebase/timebase.sv
${COMMON_BFM}/axi4_monitor/axi4_monitor_bfm.sv


// ${SOCBLOX}/units/interconnects/axi4/axi4_wb_bridge.sv
// ${SOCBLOX}/units/wb_uart/wb_uart.sv

// ${SOCBLOX}/common/bfm/uart/uart_bfm.sv

-f ${SYSTEMS}/a23_dualcore_sys/a23_dualcore.f

${SOCBLOX}/systems_ve/a23_dualcore_sys/tb/a23_dualcore_sys_tb.sv


