
#include "bidi_message_queue_drv_uth.h"
#include "uth.h"
#include "uth_coop_thread_mgr.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

extern "C" void irq_handler() { }

#define debug(...) fprintf(stdout, __VA_ARGS__); fflush(stdout);

static uth_coop_thread_mgr *thread_mgr[2] = {0, 0};
extern "C" uth_thread_mgr *uth_get_thread_mgr()
{
	uint32_t core = *((volatile uint32_t *)0xF1000004);
	if (!thread_mgr[core]) {
		thread_mgr[core] = new uth_coop_thread_mgr();
		thread_mgr[core]->init();
	}
	return thread_mgr[core];
}

extern "C" void low_level_init()
{
	// Enable cache for code/data
	// 31:27
	// Page 0 - 0x00000000-0x07FFFFFFF
	// Page 4 - 0x20000000-0x27FFFFFFF
	asm(
			"mov	r0, #0x00000011\n"
			"mcr	15, 0, r0, cr3, cr0, 0\n"
			"mov	r0, #1\n"
//			"mov	r0, #0\n"
			"mcr	15, 0, r0, cr2, cr0, 0\n"); // Enable cache

}


static uth_mutex_t			m_req;
static uth_cond_t			c_req;
static volatile bool		v_req = false;
static uth_mutex_t			m_ack;
static uth_cond_t			c_ack;
static volatile bool		v_ack = false;

volatile uint32_t c_val=0;

void producer_f(void *ud) {
	// produce values to consumer thread
	while (true) {
		uth_mutex_lock(&m_req);
		c_val++;
		v_req = true;
		uth_mutex_unlock(&m_req);

		while (true) {
			uth_mutex_lock(&m_ack);
			if (v_ack) {
				v_ack = false;
				uth_mutex_unlock(&m_ack);
				break;
			} else {
				uth_mutex_unlock(&m_ack);
			}
		}
	}
}

void consumer_f(void *ud) {
	while (true) {
		while (true) {
			uth_mutex_lock(&m_req);
			if (v_req) {
				*((volatile uint32_t *)0x80000000) = (c_val >> 0);
				v_req = false;
				uth_mutex_unlock(&m_req);
				break;
			} else {
				uth_mutex_unlock(&m_req);
			}
		}

		uth_mutex_lock(&m_ack);
		v_ack = true;
		uth_mutex_unlock(&m_ack);
	}
}

void stub_f(void *ud) {
	while (true) {
		c_val++;
		*((volatile uint32_t *)0x80000000) = (c_val >> 8);
	}
}

int main(int argc, char **argv) {
	uint32_t core = *((volatile uint32_t *)0xF1000004);
	uth_thread_t producer_t, consumer_t, stub_t;

	if (core == 0) {
		// Release core 1
		*((volatile uint32_t *)0xF100000C) = 1;

		while (true) {}
	} else {
		while (true) {
			c_val++;
			*((volatile uint32_t *)0x80000000) = (c_val >> 8);
		}
	}

	uth_get_thread_mgr();

	uth_mutex_init(&m_req);
	uth_mutex_init(&m_ack);


	uth_thread_create(&producer_t, &producer_f, 0);
	uth_thread_create(&consumer_t, &consumer_f, 0);
//	uth_thread_create(&stub_t, &stub_f, 0);

	while (true) {
		uth_thread_yield();
	}
}
