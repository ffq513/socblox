/*
 * axi4_master_bfm.h
 *
 *  Created on: Dec 8, 2013
 *      Author: ballance
 */

#ifndef AXI4_MASTER_BFM_H_
#define AXI4_MASTER_BFM_H_

#include "svf.h"
#include "axi4_master_bfm_if.h"
#include "axi4_master_if.h"
#include "axi4_master_bfm_dpi_mgr.h"

using namespace std;


class axi4_master_bfm: public svf_component,
	public virtual axi4_master_bfm_host_if, public virtual axi4_master_if {
	svf_component_ctor_decl(axi4_master_bfm)

	public:
		static const uint32_t					CACHE_BUFFERABLE = (1 << 0);
		static const uint32_t					CACHE_CACHEABLE  = (1 << 1);
		static const uint32_t					CACHE_READALLOC  = (1 << 2);
		static const uint32_t					CACHE_WRITEALLOC = (1 << 3);


	public:
		svf_api_export<axi4_master_if>												master_export;

		// Port to the BFM
		svf_bidi_api_port<axi4_master_bfm_host_if, axi4_master_bfm_target_if>		bfm_port;

	public:

		axi4_master_bfm(const char *name, svf_component *parent);

		virtual ~axi4_master_bfm();

		virtual void start();

		void wait_for_reset();

		virtual void write(
				uint64_t			addr,
				axi4_burst_size_t	burst_size,
				uint32_t			burst_len,
				uint32_t			*data,
				uint8_t				&resp,
				axi4_burst_type_t	burst_type);

		virtual void read(
				uint64_t			addr,
				axi4_burst_size_t	burst_size,
				uint32_t			burst_len,
				uint32_t			*data,
				uint8_t				&resp,
				axi4_burst_type_t	burst_type);

		virtual uint8_t read8(uint64_t addr);
		virtual uint16_t read16(uint64_t addr);
		virtual uint32_t read32(uint64_t addr);
		virtual uint64_t read64(uint64_t addr);

		virtual void write8(uint64_t addr, uint8_t data);
		virtual void write16(uint64_t addr, uint16_t data);
		virtual void write32(uint64_t addr, uint32_t data);
		virtual void write64(uint64_t addr, uint64_t data);

		virtual void read(uint64_t addr, uint8_t *data, uint32_t sz) {
			;
		}

		virtual void write(uint64_t addr, uint8_t *data, uint32_t sz) {
			;
		}

		void wait_clks(uint32_t clks);

		void set_cache(uint32_t cache);

		// Implementation of host API
	public:

		void bresp(uint32_t resp);

		void rresp(uint32_t resp);

		void aw_ready();

		void reset();

		void clk_ack();

	private:
		uint32_t					ADDRESS_WIDTH;
		uint32_t					DATA_WIDTH;
		uint32_t					ID_WIDTH;

		uint32_t					m_cache;

		uint32_t					m_aw_id;
		uint32_t					m_ar_id;

		svf_thread_mutex			m_mutex;
		svf_thread_mutex			m_write_mutex;
		svf_thread_mutex			m_read_mutex;

		svf_thread_mutex			m_aw_mutex;
		svf_semaphore				m_aw_sem;
		svf_semaphore				m_bresp_sem;

		svf_thread_mutex			m_ar_mutex;
		svf_semaphore				m_rresp_sem;

		svf_thread_mutex			m_b_mutex;

		svf_semaphore				m_clk_sem;

		svf_thread_mutex			m_reset_cond_mutex;
		svf_thread_cond				m_reset_cond;
		bool						m_init_reset;

};

#endif /* AXI4_MASTER_BFM_H_ */
