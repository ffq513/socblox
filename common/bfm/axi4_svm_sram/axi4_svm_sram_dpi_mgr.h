/*
 * axi4_svm_sram_dpi_mgr.h
 *
 *  Created on: Dec 13, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_BFM_DPI_MGR_H_
#define AXI4_MASTER_BFM_DPI_MGR_H_
#include "svm.h"
#include "svm_mem_if.h"
#include <map>
#include <string>

using namespace std;

class axi4_svm_sram_dpi_mgr;

class axi4_svm_sram_dpi_closure : public svm_api_export<svm_mem_if>, virtual svm_mem_if {

	public:

		typedef svm_api_export<svm_mem_if>	port_t;

		axi4_svm_sram_dpi_closure(const string &target) :
			svm_api_export(this), m_target(target) {
		}

		void write8(uint64_t addr, uint8_t data);
		void write16(uint64_t addr, uint16_t data);
		void write32(uint64_t addr, uint32_t data);

		uint8_t read8(uint64_t addr);
		uint16_t read16(uint64_t addr);
		uint32_t read32(uint64_t addr);

	private:
		string								m_target;

};

class axi4_svm_sram_dpi_mgr {

	public:

		static void connect(
				const string 					&target,
				svm_api_port<svm_mem_if>		&port);

		static void register_bfm(const string &target);

		static axi4_svm_sram_dpi_closure *get_closure(const string &target);

	private:

		static map<string, axi4_svm_sram_dpi_closure *>				m_closure_map;

};



#endif /* AXI4_MASTER_BFM_DPI_MGR_H_ */
