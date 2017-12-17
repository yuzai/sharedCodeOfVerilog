#include "math.h"

int add(int a,int b){
    return add1(a,b);
}

static int add1 (int a,int b){
    return a+b;
}