/*
 * a23_unicore_sys_smoke_test.cpp
 *
 *  Created on: Jan 28, 2014
 *      Author: ballance
 */

#include "a23_unicore_sys_smoke_test.h"
#include "svf_elf_loader.h"

a23_unicore_sys_smoke_test::a23_unicore_sys_smoke_test(const char *name) :
	a23_unicore_sys_test_base(name), tracer_port(this) {
	// TODO Auto-generated constructor stub

}

a23_unicore_sys_smoke_test::~a23_unicore_sys_smoke_test() {
	// TODO Auto-generated destructor stub
}

void a23_unicore_sys_smoke_test::build()
{
	a23_unicore_sys_test_base::build();
	m_trace_file = fopen("disasm.trc", "w");
	m_tracer = new a23_disasm_tracer(m_trace_file);
}

void a23_unicore_sys_smoke_test::connect()
{
	a23_unicore_sys_test_base::connect();

	m_env->m_core1_tracer->port.connect(tracer_port);
	m_env->m_core1_tracer->port.connect(m_tracer->port);
//	m_env->m_core2_tracer->port.connect(tracer_port);
}

void a23_unicore_sys_smoke_test::start()
{
	string target_exe;
	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		fprintf(stdout, "Error: no executable specified\n");
	} else {
		fprintf(stdout, "Note: loading %s\n", target_exe.c_str());
	}

	svf_elf_loader loader(m_env->m_mem_mgr);

	int ret = loader.load(target_exe.c_str());

	raise_objection();
}

void a23_unicore_sys_smoke_test::shutdown()
{
	if (m_trace_file) {
		fclose(m_trace_file);
	}
}

void a23_unicore_sys_smoke_test::mem_access(
		uint32_t			addr,
		bool				is_write,
		uint32_t			data)
{
//	fprintf(stdout, "MEM_ACCESS: 0x%08x\n", addr);
	if (addr == 0xF0000000) {
		fprintf(stdout, "Test Status: %d\n", data);
		/*
		fprintf(stdout, "--> end_sem.put()\n");
		m_test_status = data;
		m_end_sem.put();
		fprintf(stdout, "<-- end_sem.put()\n");
		 */
	}
}

void a23_unicore_sys_smoke_test::execute(
		uint32_t			addr,
		uint32_t			op
		)
{
//	fprintf(stdout, "EXECUTE: 0x%08x\n", addr);
}

void a23_unicore_sys_smoke_test::regchange(
		uint32_t			reg,
		uint32_t			val
		)
{

}

svf_test_ctor_def(a23_unicore_sys_smoke_test)
