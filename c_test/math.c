#include "math.h"
#include <stdio.h>

int count;
int add(int a,int b){
    count = 1000;
    printf("%d\r\n",count);
    return add1(a,b);
}

static int add1 (int a,int b){
    return a+b;
}