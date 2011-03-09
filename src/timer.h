#ifndef _ENCORE_TIMER_H
#define _ENCORE_TIMER_H
#include "metypes.h"

#if defined(_PROFILING_)

extern unsigned long count_frames;

extern void start_timer(void);
extern void start_global_timer(void);
extern void stop_idct_timer(void);
extern void stop_comp_timer(void);
extern void stop_edges_timer(void);
extern void stop_inter_timer(void);
extern void stop_iquant_timer(void);
extern void stop_conv_timer(void);
extern void stop_transfer_timer(void);
extern void stop_coding_timer(void);
extern void stop_prediction_timer(void);
extern void stop_global_timer(void);
extern void init_timer(void);
extern void cleanup_timer(void);
extern void write_timer(void);

#else

static __inline void
start_timer(void)
{
}
static __inline void
start_global_timer(void)
{
}
static __inline void
stop_idct_timer(void)
{
}
static __inline void
stop_comp_timer(void)
{
}
static __inline void
stop_edges_timer(void)
{
}
static __inline void
stop_inter_timer(void)
{
}
static __inline void
stop_iquant_timer(void)
{
}
static __inline void
stop_conv_timer(void)
{
}
static __inline void
stop_transfer_timer(void)
{
}
static __inline void
init_timer(void)
{
}
static __inline void
cleanup_timer(void)
{
}
static __inline void
write_timer(void)
{
}
static __inline void
stop_coding_timer(void)
{
}
static __inline void
stop_prediction_timer(void)
{
}
static __inline void
stop_global_timer(void)
{
}

#endif

#endif /* _TIMER_H_ */
