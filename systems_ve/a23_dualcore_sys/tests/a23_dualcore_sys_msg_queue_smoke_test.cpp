/*
 * a23_dualcore_sys_msg_queue_smoke_test.cpp
 *
 *  Created on: Jun 19, 2014
 *      Author: ballance
 */

#include "a23_dualcore_sys_msg_queue_smoke_test.h"
#include "svf_elf_loader.h"

a23_dualcore_sys_msg_queue_smoke_test::a23_dualcore_sys_msg_queue_smoke_test(const char *name) : a23_dualcore_sys_test_base(name) {
	fprintf(stdout, "--> test::ctor(%s)\n", name);
	// TODO Auto-generated constructor stub

	fprintf(stdout, "<-- test::ctor(%s)\n", name);
}

a23_dualcore_sys_msg_queue_smoke_test::~a23_dualcore_sys_msg_queue_smoke_test() {
	// TODO Auto-generated destructor stub
}

void a23_dualcore_sys_msg_queue_smoke_test::build() {
	a23_dualcore_sys_test_base::build();
}

void a23_dualcore_sys_msg_queue_smoke_test::connect() {
	a23_dualcore_sys_test_base::connect();
}

void a23_dualcore_sys_msg_queue_smoke_test::start() {
	fprintf(stdout, "--> start()\n");
	a23_dualcore_sys_test_base::start();

	svf_string target_exe;
	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {

	}

	svf_elf_loader loader(m_env->m_mem_mgr);

	int ret = loader.load(target_exe.c_str());

	m_inbound.init(this, &a23_dualcore_sys_msg_queue_smoke_test::inbound_thread);
	m_inbound.start();

	m_outbound.init(this, &a23_dualcore_sys_msg_queue_smoke_test::outbound_thread);
	m_outbound.start();

}

void a23_dualcore_sys_msg_queue_smoke_test::inbound_thread() {
	uint32_t msg[4096];
	uint32_t msg_sz = 16;

	raise_objection();
	fprintf(stdout, "--> inbound_thread\n");
	fflush(stdout);

	for (uint32_t i=0; i<16; i++) {
		for (uint32_t j=0; j<msg_sz; j++) {
			msg[i] = (j+1);
		}

		fprintf(stdout, "--> write_message %d\n", i);
		fflush(stdout);
		m_env->m_msg_queue_0->write_message(msg_sz, msg);
		fprintf(stdout, "<-- write_message %d\n", i);
		fflush(stdout);
	}

	fprintf(stdout, "<-- inbound_thread\n");
	fflush(stdout);
	drop_objection();
}

void a23_dualcore_sys_msg_queue_smoke_test::outbound_thread() {
	uint32_t sz;
	uint32_t msg[4096];

	raise_objection();
	fprintf(stdout, "--> outbound_thread\n");
	fflush(stdout);

	for (uint32_t j=0; j<16; j++) {
		fprintf(stdout, "--> outbound: get_next_message_sz %d\n", j);
		sz = m_env->m_msg_queue_0->get_next_message_sz();
		fprintf(stdout, "<-- outbound: get_next_message_sz %d %d\n", j, sz);


		fprintf(stdout, "--> outbound: read_next_message %d\n", j);
		m_env->m_msg_queue_0->read_next_message(msg);
		fprintf(stdout, "<-- outbound: read_next_message %d\n", j);
	}

	fprintf(stdout, "<-- outbound_thread\n");
	fflush(stdout);

	drop_objection();
}

void a23_dualcore_sys_msg_queue_smoke_test::run() {
	uint32_t sz;
	uint32_t msg[4096];
	fprintf(stdout, "--> run()\n");

	for (uint32_t j=0; j<16; j++) {
	sz = m_env->m_msg_queue_0->get_next_message_sz();

	fprintf(stdout, "sz=%d\n", sz);

	m_env->m_msg_queue_0->read_next_message(msg);

	for (uint32_t i=0; i<sz; i++) {
		fprintf(stdout, "msg[%d] = %d\n", i, msg[i]);
	}
	}
//	drop_objection();

	fprintf(stdout, "<-- run()\n");
}

svf_test_ctor_def(a23_dualcore_sys_msg_queue_smoke_test)
