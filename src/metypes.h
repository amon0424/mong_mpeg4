/* ///////////////////////////////////////////////////////////////////////// */
/*   File:  : metypes.h                                                      */
/*   Author : Chun-Jen Tsai                                                  */
/*   Date   : Dec/24/2002                                                    */
/* ------------------------------------------------------------------------- */
/*   Basic data type definitions.                                            */
/*   Copyright, 2002.                                                        */
/*   Multimedia Embedded Systems Lab.                                        */
/*   Department of Computer Science and Information engineering              */
/*   National Chiao Tung University, Hsinchu 300, Taiwan                     */
/* ///////////////////////////////////////////////////////////////////////// */

#ifndef __METYPES_H__
#define __METYPES_H__

/* The following two definitions are for fast, */
/*    word-size independent operations         */
typedef int xint;
#ifndef _SYS_TYPES_H
typedef unsigned int uint;
#endif

typedef char mbchar;            /* this is for multibyte,      */
                                 /* unicode-like character def. */

#ifdef WIN32                    /* 32-bit Windows Platform */

typedef char int8;
typedef short int16;
typedef long int32;
typedef __int64 int64;

typedef unsigned __int64 uint64;
typedef unsigned long uint32;
typedef unsigned short uint16;
typedef unsigned char uint8;

#else /* 32-bit Linux */

typedef char int8;
typedef short int16;
typedef long int32;
typedef long long int64;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;
typedef unsigned long long uint64;

#endif

#endif /* __METYPES_H__ */
