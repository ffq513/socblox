/*
 * axi4_svf_rom_bfm.h
 *
 *  Created on: Dec 22, 2013
 *      Author: ballance
 */

#ifndef AXI4_SVF_ROM_BFM_H_
#define AXI4_SVF_ROM_BFM_H_
#include "svf.h"
#include "svf_mem_if.h"
#include "axi4_svf_rom_dpi_mgr.h"

class axi4_svf_rom_bfm : public svf_component, public virtual svf_mem_if {

	svf_component_ctor_decl(axi4_svf_rom_bfm)

	public:
		svf_api_port<svf_mem_if>				port;

	public:

		axi4_svf_rom_bfm(const char *name, svf_component *parent);

		virtual ~axi4_svf_rom_bfm();

		virtual void write(uint64_t addr, uint8_t *data, uint32_t sz);
		virtual void write32(uint64_t addr, uint32_t data);
		virtual void write16(uint64_t addr, uint16_t data);
		virtual void write8(uint64_t addr, uint8_t data);

		virtual void read(uint64_t addr, uint8_t *data, uint32_t sz);
		virtual uint32_t read32(uint64_t addr);
		virtual uint16_t read16(uint64_t addr);
		virtual uint8_t read8(uint64_t addr);

};

#endif /* AXI4_SVF_ROM_BFM_H_ */
