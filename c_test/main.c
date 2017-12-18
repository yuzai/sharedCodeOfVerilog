#include <stdio.h>
#include "math.h"
//测试static函数的含义
//本质上只是界定了函数的使用范围：static，只能在函数定义的c文件中实现
//                          没有static，能够在别的函数中使用
int i=100;
int main(){
    printf("%d\r\n",count);
    printf("123\n");
    printf("%d\n",add(1,2));
}