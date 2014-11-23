/*
 * a23_dualcore_sys_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_test_base.h"

a23_dualcore_sys_test_base::a23_dualcore_sys_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

a23_dualcore_sys_test_base::~a23_dualcore_sys_test_base() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_test_base::build()
{
	m_env = a23_dualcore_sys_env::type_id.create("m_env", this);

//	m_axi4_trace_fp = fopen("axi4_tracer.log", "w");
	m_axi4_trace_fp = stdout;
	m_core12ic_logger = new axi4_monitor_stream_logger("core12ic", m_axi4_trace_fp);
	m_core02ic_logger = new axi4_monitor_stream_logger("core02ic", m_axi4_trace_fp);
	m_ic2ram_logger = new axi4_monitor_stream_logger("ic2ram", m_axi4_trace_fp);
	m_core2ic_logger = new axi4_monitor_stream_logger("core2ic", m_axi4_trace_fp);
}

void a23_dualcore_sys_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);
	string D_ROOT(TB_ROOT + ".u_a23_sys");

	generic_rom_dpi_mgr::connect(D_ROOT + ".u_rom.u_rom", m_env->m_bootrom->bfm_port);
	generic_sram_byte_en_dpi_mgr::connect(D_ROOT + ".u_ram.ram_w.ram", m_env->m_sram->bfm_port);
	generic_sram_byte_en_dpi_mgr::connect(D_ROOT + ".u_gbl.ram_w.ram", m_env->m_gbl->bfm_port);
	uart_bfm_dpi_mgr::connect(TB_ROOT + ".u_uart_bfm", m_env->m_uart->bfm_port);


	a23_tracer_bfm_dpi_mgr::connect(D_ROOT + ".u_core.u_core0.u_tracer.u_tracer_bfm",
			m_env->m_core1_tracer->bfm_port);
	a23_tracer_bfm_dpi_mgr::connect(D_ROOT + ".u_core.u_core1.u_tracer.u_tracer_bfm",
			m_env->m_core2_tracer->bfm_port);

	timebase_dpi_mgr::connect(TB_ROOT + ".u_time", m_env->m_timebase->bfm_port);

	bidi_message_queue_direct_bfm_dpi_mgr::connect(
			D_ROOT + ".u_msg_queue_0",
			m_env->m_msg_queue_0->bfm_port);

	axi4_monitor_bfm_dpi_mgr::connect(
			D_ROOT + ".u_core.core12ic_monitor.u_monitor_bfm",
			m_env->m_core12ic_monitor->bfm_port);
	axi4_monitor_bfm_dpi_mgr::connect(
			D_ROOT + ".u_core.core02ic_monitor.u_monitor_bfm",
			m_env->m_core02ic_monitor->bfm_port);
	axi4_monitor_bfm_dpi_mgr::connect(
			D_ROOT + ".ic2ram_monitor.u_monitor_bfm",
			m_env->m_ic2ram_monitor->bfm_port);
	axi4_monitor_bfm_dpi_mgr::connect(
			D_ROOT + ".core2ic_monitor.u_monitor_bfm",
			m_env->m_core2ic_monitor->bfm_port);

//	m_env->m_core12ic_monitor->ap.connect(m_core12ic_logger->api_export);
//	m_env->m_core02ic_monitor->ap.connect(m_core02ic_logger->api_export);
//	m_env->m_ic2ram_monitor->ap.connect(m_ic2ram_logger->api_export);
//	m_env->m_core2ic_monitor->ap.connect(m_core2ic_logger->api_export);

	m_core12ic_logger->set_timebase(m_env->m_timebase);
	m_core02ic_logger->set_timebase(m_env->m_timebase);
	m_ic2ram_logger->set_timebase(m_env->m_timebase);
	m_core2ic_logger->set_timebase(m_env->m_timebase);

	/*
	bidi_message_queue_direct_bfm_dpi_mgr::connect(
			D_ROOT + ".u_msg_queue_1",
			m_env->m_msg_queue_1->bfm_port);
			*/
}

void a23_dualcore_sys_test_base::shutdown()
{

}

svf_test_ctor_def(a23_dualcore_sys_test_base)

