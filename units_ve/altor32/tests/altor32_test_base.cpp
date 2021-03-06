/*
 * altor32_test_base.cpp
 *
 *  Created on: Jan 11, 2014
 *      Author: ballance
 */

#include "altor32_test_base.h"
#include "svf_elf_loader.h"

altor32_test_base::altor32_test_base(const char *name) : svf_test(name) {
	// TODO Auto-generated constructor stub

}

altor32_test_base::~altor32_test_base() {
	// TODO Auto-generated destructor stub
}

void altor32_test_base::build()
{
	m_env = altor32_env::type_id.create("m_env", this);
}

void altor32_test_base::connect()
{
	const char *TB_ROOT_c;

	if (!get_config_string("TB_ROOT", &TB_ROOT_c)) {
		fprintf(stdout, "FATAL");
	}

	string TB_ROOT(TB_ROOT_c);

	// TODO: connect BFMs
}

void altor32_test_base::start()
{
	m_runthread.init(this, &altor32_test_base::run);
	m_runthread.start();
}

void altor32_test_base::run()
{
	svf_string target_exe;
	svf_string testname = "unknown";
	fprintf(stdout, "run thread\n");
	raise_objection();

	if (!cmdline().valueplusarg("TARGET_EXE=", target_exe)) {
		// TODO: fatal
	}

	cmdline().valueplusarg("TESTNAME=", testname);

}

void altor32_test_base::shutdown()
{

}

svf_test_ctor_def(altor32_test_base)

