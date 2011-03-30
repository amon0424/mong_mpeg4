/* /////////////////////////////////////////////////////////////////// */
/*  Program : timer_isr.c                                              */
/*  Author  : Chun-Jen Tsai                                            */
/*  Date    : 08/20/2007                                               */
/* ------------------------------------------------------------------- */
/*     This program shows you how to install an ISR under eCos.        */
/*  A timer ISR with millisecond resolution is used as an example.     */
/* ------------------------------------------------------------------- */
/* This program is designed for the class "Embedded Firmware and       */
/* Hardware/Software Co-design" in Spring, 2007.                       */
/*                                                                     */
/* Department of Computer Science                                      */
/* National Chiao Tung University                                      */
/* 1001 Ta-Hsueh Rd., Hsinchu, 30010, Taiwan                           */
/* /////////////////////////////////////////////////////////////////// */

#include <stdio.h>
#include <cyg/kernel/kapi.h>
#include <cyg/hal/hal_io.h>

#define TICKS_PER_MS 40000 /* 40 MHz per second / 1000 */

/* The interrupt number can be obtained by typing 'info sys'  */
/* command in GRMON and look for the Modular Timer Unit       */
/* The IRQ value '8' displayed in 'info sys' is for the first */
/* timer, which is used by eCos. We will use the 2nd timer.   */
/* Therefore, the interrupt number is 9.                      */
#define CYGNUM_HAL_INTERRUPT_TIMER2 (8+1)

/* The base address of timer registers is again obtained by   */
/* 'info sys'. The usage of the timer is described in detail  */
/* in the GRLIB IP Core User's Manual.                        */
#define TIMER_BASE           0x80000300
#define SCALER_RELOAD_VALUE  TIMER_BASE + 0x04
#define TIMER2_RELOAD_VALUE  TIMER_BASE + 0x24
#define TIMER2_CTRL_REGISTER TIMER_BASE + 0x28

long f[2801];

cyg_uint32
my_isr(cyg_vector_t vector, cyg_addrword_t data)
{
    long *counter = (long *) data;

    (*counter)++;
    cyg_interrupt_acknowledge(vector);
    return CYG_ISR_HANDLED;
}

cyg_handle_t
install_timer_isr(cyg_addrword_t data)
{
    static cyg_interrupt isr_struct;
    cyg_handle_t handle;
    cyg_uint32   ctrl_reg, prescaler_value;

    cyg_interrupt_create(CYGNUM_HAL_INTERRUPT_TIMER2,
        0, data, my_isr, NULL, &handle, &isr_struct);
    cyg_interrupt_attach(handle);
    cyg_interrupt_unmask(CYGNUM_HAL_INTERRUPT_TIMER2);

    /* read the system default prescaler value */
    HAL_READ_UINT32(SCALER_RELOAD_VALUE, prescaler_value);
    if (prescaler_value == 0 ||         /* eCos did not set prescalar. */
        prescaler_value > TICKS_PER_MS) /* clock resolution too low.   */
    {
        prescaler_value = 16;
    }

    /* initialize the timer to 1 ms per tick. For a 40MHz system */
    /* clock, 40000/prescaler_value equals 1 ms.                 */
    HAL_WRITE_UINT32(TIMER2_RELOAD_VALUE, TICKS_PER_MS/prescaler_value);

    /* set the control register */
    HAL_READ_UINT32(TIMER2_CTRL_REGISTER, ctrl_reg);
    ctrl_reg |= 0xA; /* enable the interrupt */
    ctrl_reg |= 0x1; /* start ticking */
    HAL_WRITE_UINT32(TIMER2_CTRL_REGISTER, ctrl_reg);

    return handle;
}

void
uninstall_timer_isr(cyg_handle_t handle)
{
    cyg_interrupt_mask(CYGNUM_HAL_INTERRUPT_TIMER2);
    cyg_interrupt_detach(handle);
    cyg_interrupt_delete(handle);
}

void
do_some_calculation()
{
     long a = 10000, b = 0, c = 2800, d, e = 0, g;

     for (; b-c; ) f[b++] = a/5;

     for (; d = 0, g = c*2; c -= 14, e = d%a)
     {
         for (b=c; d+=f[b]*a, f[b]=d%--g, d/=g--, --b; d*=b) ;
         if (c==2800) { printf("%5.3f", e+d/(1000.0*a)-0.0005); }
         else { printf("%.4ld", e+d/a); }
     }
     printf("\b \b");
}

int
main(int arc, char *arv[])
{
    cyg_handle_t timer_handle;
    long time_tick, counter = 0;

    /* install timer ISR */
    timer_handle = install_timer_isr((cyg_addrword_t) &counter);

    /* do something useful here! */
    time_tick = counter;
    printf("\nComputing ...\n\n");
    do_some_calculation();
    printf("\n\n");
    time_tick = counter - time_tick;

    /* uninstall timer ISR */
    uninstall_timer_isr(timer_handle);

    printf("The computation took %ld ms.\n", time_tick);
    return 0;
}
