#include <reg51.h>
code unsigned char tab[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f}; //共阴数码管 0-9 
code unsigned char tab1[]={0xBF,0x86,0xDB,0xCF,0xE6,0xED,0xFD,0x87,0xFF,0xEF} ;//共阴数码管0-9带小数点
sbit key1 = P1^0;			 //开始、暂停
sbit key2 = P1^1;			 //记数
sbit key3 = P1^2;			 //上翻
sbit key4 = P1^3;			 //下翻
sbit key5 = P1^4;			 //清零
static unsigned char 	ms,sec;
static unsigned char Sec[8],Ms[8];
static int i ,j;
void delay(unsigned int cnt)   //延时程序
{
 while(--cnt);
}							
void main()
{
	unsigned char key3_flag=0,key4_flag=0;
    TMOD |=0x01;//定时器0 10ms in 12M crystal 用于计时
	TH0=0xd8;
	TL0=0xf0;
	ET0=1;
	TR0=0;
    TMOD |=0x10; //定时器1用于动态扫描
	TH1=0xF8;
	TL1=0xf0;
	ET1=1;
	TR1=1;
    EA =1;
	sec=0; //初始化
	ms=0;
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
	   		Sec[i]=	 sec;	  //将数据存入数组
			Ms[i]= ms;
			i++;
	   }
	  }//上翻
	  if(!key3)	
	  {	
		delay(50);
	    if(!key3)
	     {	while(!key3)
		    {;}
			TR0=0;
			key3_flag=1;		//按键3标志
			if(j==i)
			   	goto start; 
			else
				if(key4_flag)
				j+=2;
				key4_flag=0;	 
		    sec=Sec[j];ms=Ms[j];	//显示数组里的内容
		    j++;	   	
		 }
   	   }//下翻
	   if(!key4)	
	   {
	    delay(50);
		if(!key4)
		{
			while(!key4)
			{;}
			TR0=0;
			key4_flag=1;			 //按键4标志
			if(j<0)
			   goto start;
			else
				 if(key3_flag)
			   		j-=2;
				key3_flag=0;
			sec=Sec[j];ms=Ms[j];		  //显示数组里的内容
			j--;
		}   
	   } //清零
	   if(!key5)
	   {
	   	delay(50);
		if(!key5)
		while(!key5)
		{;}
		TR0=0;
		ms=0;
		sec=0;
		for(i=0;i<8;i++)
		{
			Sec[i]=0;Ms[i]=0;
		}
		i=0;
	   }
  }
}/********************************/
/*      定时中断1                */
/********************************/
void time1_isr(void) interrupt 3 using 0//定时器1用来动态扫描
{
    static unsigned char num;
    TH1=0xF8;//重入初值
	TL1=0xf0;
	switch(num)
	{
   	case 0:	P2=0xfe;P0=tab[sec/10];break;//显示秒十位
   	case 1:	P2=0xfd;P0=tab1[sec%10];break; //显示秒个位
   	case 2:	P2=0xfb;P0=tab[ms/10];break;//显示十位
   	case 3: P2=0xf7;P0=tab[ms%10];break; //显示个位
   	default:break;
	}
	num++;
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