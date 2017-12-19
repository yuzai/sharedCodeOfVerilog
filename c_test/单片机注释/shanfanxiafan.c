#include <reg51.h>
//数码管的原理见图片1
code unsigned char tab[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f}; //共阴数码管 0-9 
code unsigned char tab1[]={0xBF,0x86,0xDB,0xCF,0xE6,0xED,0xFD,0x87,0xFF,0xEF} ;//共阴数码管0-9带小数点

//sbit是声明，声明这一个信号的长度是1bit，就是一个二进制数字，P1^0表示是P1的1号引脚
//一般单片机有好几个p口，p1-p4，每个p一般有8个端口，此处就是声明硬件上key1-key5对应的端口
sbit key1 = P1^0;			 //开始、暂停
sbit key2 = P1^1;			 //记数
sbit key3 = P1^2;			 //上翻
sbit key4 = P1^3;			 //下翻
sbit key5 = P1^4;			 //清零

//此处定义一些变量
//unsigned char表示无符号的字符类型，占8个bit
//static无所谓，可以不加，加了之后表示只能在本文件中使用
static unsigned char 	ms,sec;
static unsigned char Sec[8],Ms[8];
static int i ,j;
//定义一个延时程序
void delay(unsigned int cnt)   //延时程序
{
 while(--cnt);//让cnt一直减，直到为0，此时就会退出循环，因为一直在执行cnt--，所以占用了时间，达到了延时的效果
}							
void main()
{
	unsigned char key3_flag=0,key4_flag=0;//定义一些无符号字符型变量
	//tmod|=0x01
	//等价于tmod = tmod|0x01,也就是最低位不管是0还是1，执行这一条语句之后，tmod的最低位都是1
	//tmod为1，表示定时器0采用工作模式1，也就是TH0和TH1共同配合，形成16位计数器进行定时
    TMOD |=0x01;//定时器0 10ms in 12M crystal 用于计时
	//给定时器1装入初值
	//为什么是d8,f0,10ms，需要经历10000个1us,所以TH0 = (65536-10000)/256,TL0 = (65536-10000)%256
	TH0=0xd8;
	TL0=0xf0;
	//ET0表示中断开关，1表示打开，打开了中断开关才能在计时结束后执行中断程序
	ET0=1;
	//TR0表示定时器0的开关，为0不计时，为1开始计时
	TR0=0;
    
	//设置定时器1的工作模式也为16位计时器
    TMOD |=0x10; //定时器1用于动态扫描
	//定时的时间为1808us,也就是1.808ms,TH1 = (65536-1808)/256,TL1 = (65536-2048)%256
	//此处的定时时间个人认为1ms-10ms可以
	TH1=0xF8;
	TL1=0xf0;

	//开启定时器1的中断
	ET1=1;
	//开启定时器2的中断
	TR1=1;

	//EA是定时器的总开关，要使用定时器，这个开关必须打开
    EA =1;

	//初始化分秒都是0
	sec=0; //初始化
	ms=0;
	//初始化P1口全部为高电平
    P1=0xff;

	i=0;
	j=0;
start:
 while(1)
  {	  	//开始、暂停
  	  if(!key1)			 //判断是否按下
	  {
	   delay(50);		 //去抖
	   if(!key1)
	   while(!key1)		 //等待按键释放
	   {;}	
	   //此处将TR0进行翻转，也就是按下按键，打开定时器，再次按下，关闭定时器，从而实现了暂停和开始功能
	   TR0=!TR0;   
	   }	//记录
	  if(!key2)			  //判断是否按下
	  {
	   delay(50);		  //去抖
	   if(!key2)
	   {	while(!key2)  //等待按键释放
	        {;}					
			if(i==8)		   //8组数据记录完毕
			 	{TR0=0; goto start;}
		    //每次按键2按下，就将当前时间存储到Sec和Ms数组中，一共存储8组
	   		Sec[i]=	 sec;	  //将数据存入数组
			Ms[i]= ms;
			i++;  //每次存储一个数字，就将i加1
	   }
	  }//上翻
	  if(!key3)	
	  {	
		delay(50); //消除抖动
	    if(!key3)
	     {	while(!key3)  //等待按键松开
		    {;}
			TR0=0;//停止定时器0,也就是停止了计时
			key3_flag=1;		//按键3标志，按下按键3，将该标志置为1
			if(j==i) //如果读取到最大的存储数字，就不继续读取了，直接返回start
			   	goto start; 
			else
				if(key4_flag) //如果此时key4的标志也按下了，就将j加上2
				j+=2;
				key4_flag=0; //将key4的标志清除
			//读出存储的时间	 
		    sec=Sec[j];ms=Ms[j];	//显示数组里的内容
		    j++;	   	//将j加1，这样，下次按下key3,就会显示下一个存储的数字
		 }
   	   }//下翻
	   if(!key4)	
	   {
	    delay(50);
		if(!key4)
		{
			while(!key4)
			{;}
			TR0=0;//停止定时器0,也就是停止了计时
			key4_flag=1;			 //按键4标志
			if(j<0)   //如果此时的j小于0，就不执行，直接返回start处
			   goto start;
			else
				 if(key3_flag) //如果key3按下，就将j减去2
			   		j-=2;
				key3_flag=0;//key3标志清零
		    //读出之前存储的时间
			sec=Sec[j];ms=Ms[j];		  //显示数组里的内容
			j--;//每次读取当前数据之后将j-1,这样，下次就会显示上一个存储的数字，同时这里也是key3按下之后j要加上2的原因
		}   
	   } //清零
	   if(!key5)
	   {
	   	delay(50);
		if(!key5)
		while(!key5)
		{;}
		//关闭定时器，清零ms,sec
		TR0=0;
		ms=0;
		sec=0;
		//将数组中存储的也清零
		for(i=0;i<8;i++)
		{
			Sec[i]=0;Ms[i]=0;
		}
		i=0;//将存储的数据量也清零
	   }
  }
}/********************************/
/*      定时中断1                */
/********************************/
//interrupt 3表示使用定时器1的内部定时中断，
//using 0表示使用第0组寄存器，可以不写，会默认分配
void time1_isr(void) interrupt 3 using 0//定时器1用来动态扫描
{
    static unsigned char num;
    TH1=0xF8;//重入初值，计算方法见上面第一次置初值的地方
	TL1=0xf0;
	//动态扫描数码管，实现数字的显示
	switch(num)
	{
	//P2=0xfe,也就是P2 = 1111_1110,最低位为0，表示最低的那个数码管亮，下面同理
   	case 0:	P2=0xfe;P0=tab[sec/10];break;//显示秒十位
   	case 1:	P2=0xfd;P0=tab1[sec%10];break; //显示秒个位
   	case 2:	P2=0xfb;P0=tab[ms/10];break;//显示十位
   	case 3: P2=0xf7;P0=tab[ms%10];break; //显示个位
   	default:break;
	}
	num++;  //每次都将num+1，如果大于4就清零，从而实现动态的扫描
	if(num==4)
	num=0;
}/********************************/
/*      定时中断0                */
/********************************/
void tim(void) interrupt 1 using 1
{
TH0=0xd8;//重新赋值
TL0=0xf0;
   ms++;//毫秒单元加1
	 if(ms==100)
	 {
		 ms=0;//等于100时归零
		 sec++;//秒加1		
		 if(sec==60)
		 {
			 sec=0;//秒等于60时归零
		 }
	 }
}