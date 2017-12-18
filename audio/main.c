#include <stdio.h>
#include <xil_io.h>
#include <sleep.h>  //引入根编译器的头文件
#include "xiicps.h" //引入相对路径的头文件
#include <xil_printf.h>
#include <xparameters.h>
#include "xuartps.h"
#include "stdlib.h"
#include "audio.h"
#include "timer.h"

int main(void){
	initAudio();
    initInterruptSystem();
    while(1){
        read_superpose_play();
    }
    return 0;
}
