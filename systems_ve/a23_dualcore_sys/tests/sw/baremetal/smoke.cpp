#include "timer_drv.h"
#include "intc_drv.h"
#include <stdint.h>

static int foo = 0;
static uint8_t tmp[8];

static timer_drv	*t_drv_p = 0;
static intc_drv		*i_drv_p = 0;

extern "C" {
	void irq_handler();
}

void irq_handler()
{
	t_drv_p->clr(0);
	foo++;
	*((volatile uint32_t *)0x80000000) = foo;
}

int main(int argc, char **) {
	timer_drv t_drv;
	intc_drv i_drv;

	t_drv_p = &t_drv;
	i_drv_p = &i_drv;

	for (int i=0; i<8; i++) {
		tmp[i] = (i+1);
	}

	for (int i=0; i<8; i++) {
		foo = tmp[i];
	}

	t_drv.init((uint32_t *)0xF0000000);
	i_drv.init((uint32_t *)0xF0001000);

	t_drv.set_load(0, 0x1000);
	t_drv.set_periodic(0, true);
	t_drv.set_enable(0, true);

	while (1) {
		;
//		foo++;
//		*((uint32_t *)0x80000000) = (foo >> 1);
//		t_drv.clr(0);
	}
}
