#ifndef __MYTIMER_H_
#define __MYTIMER_H_

#include "Xscugic.h"
#include "xparameters.h"
#include "xscutimer.h"
//timer info

#define TIMER_DEVICE_ID     XPAR_XSCUTIMER_0_DEVICE_ID

#define INTC_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID

#define TIMER_IRPT_INTR     XPAR_SCUTIMER_INTR

//#define TIMER_LOAD_VALUE  0x0FFFFFFF

#define TIMER_LOAD_VALUE    0x13D92D3F

//static XAdcPs  XADCMonInst; //XADC

extern int count;
static XScuGic Intc; //GIC

static XScuTimer Timer;//timer
 void initInterruptSystem();
 void SetupInterruptSystem(XScuGic *GicInstancePtr,

        XScuTimer *TimerInstancePtr, u16 TimerIntrId);

 void TimerIntrHandler(void *CallBackRef);

#endif
