#include "timer.h"

void initInterruptSystem(){
    XScuTimer_Config *TMRConfigPtr;     //timer config

    //私有定时器初始化

     TMRConfigPtr = XScuTimer_LookupConfig(TIMER_DEVICE_ID);

     XScuTimer_CfgInitialize(&Timer, TMRConfigPtr,TMRConfigPtr->BaseAddr);

     XScuTimer_SelfTest(&Timer);

     //加载计数周期，私有定时器的时钟为CPU的一般，为333MHZ,如果计数1S,加载值为1sx(333x1000x1000)(1/s)-1=0x13D92D3F

     XScuTimer_LoadTimer(&Timer, TIMER_LOAD_VALUE);

     //自动装载

     XScuTimer_EnableAutoReload(&Timer);

     //启动定时器

     XScuTimer_Start(&Timer);

     //set up the interrupts

     SetupInterruptSystem(&Intc,&Timer,TIMER_IRPT_INTR);

}
void SetupInterruptSystem(XScuGic *GicInstancePtr,XScuTimer *TimerInstancePtr, u16 TimerIntrId){

    XScuGic_Config *IntcConfig; //GIC config

    Xil_ExceptionInit();

    //initialise the GIC

    IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);

    XScuGic_CfgInitialize(GicInstancePtr, IntcConfig,

                    IntcConfig->CpuBaseAddress);

    //connect to the hardware

    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,

                (Xil_ExceptionHandler)XScuGic_InterruptHandler,

                GicInstancePtr);

    //set up the timer interrupt

    XScuGic_Connect(GicInstancePtr, TimerIntrId,

                    (Xil_ExceptionHandler)TimerIntrHandler,

                    (void *)TimerInstancePtr);

    //enable the interrupt for the Timer at GIC

    XScuGic_Enable(GicInstancePtr, TimerIntrId);

    //enable interrupt on the timer

    XScuTimer_EnableInterrupt(TimerInstancePtr);

    // Enable interrupts in the Processor.

    Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);
}
void TimerIntrHandler(void *CallBackRef){

    static int sec = 0;   //计数

    XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;

    XScuTimer_ClearInterruptStatus(TimerInstancePtr);

    sec++;

    xil_printf(" %d Second\n\r",sec);  //每秒打印输出一次
    xil_printf(" one sec executed: %d times\r\n",count);
    count = 0;

}
