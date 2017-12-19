#include <reg51.h>
code unsigned char tab[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f}; //��������� 0-9 
code unsigned char tab1[]={0xBF,0x86,0xDB,0xCF,0xE6,0xED,0xFD,0x87,0xFF,0xEF} ;//���������0-9��С����
sbit key1 = P1^0;			 //��ʼ����ͣ
sbit key2 = P1^1;			 //����
sbit key3 = P1^2;			 //�Ϸ�
sbit key4 = P1^3;			 //�·�
sbit key5 = P1^4;			 //����
static unsigned char 	ms,sec;
static unsigned char Sec[8],Ms[8];
static int i ,j;
void delay(unsigned int cnt)   //��ʱ����
{
 while(--cnt);
}							
void main()
{
	unsigned char key3_flag=0,key4_flag=0;
    TMOD |=0x01;//��ʱ��0 10ms in 12M crystal ���ڼ�ʱ
	TH0=0xd8;
	TL0=0xf0;
	ET0=1;
	TR0=0;
    TMOD |=0x10; //��ʱ��1���ڶ�̬ɨ��
	TH1=0xF8;
	TL1=0xf0;
	ET1=1;
	TR1=1;
    EA =1;
	sec=0; //��ʼ��
	ms=0;
    P1=0xff;
	i=0;
	j=0;
start:
 while(1)
  {	  	//��ʼ����ͣ
  	  if(!key1)			 //�ж��Ƿ���
	  {
	   delay(50);		 //ȥ��
	   if(!key1)
	   while(!key1)		 //�ȴ������ͷ�
	   {;}	
	   TR0=!TR0;   
	   }	//��¼
	  if(!key2)			  //�ж��Ƿ���
	  {
	   delay(50);		  //ȥ��
	   if(!key2)
	   {	while(!key2)  //�ȴ������ͷ�
	        {;}					
			if(i==8)		   //8�����ݼ�¼���
			 	{TR0=0; goto start;}
	   		Sec[i]=	 sec;	  //�����ݴ�������
			Ms[i]= ms;
			i++;
	   }
	  }//�Ϸ�
	  if(!key3)	
	  {	
		delay(50);
	    if(!key3)
	     {	while(!key3)
		    {;}
			TR0=0;
			key3_flag=1;		//����3��־
			if(j==i)
			   	goto start; 
			else
				if(key4_flag)
				j+=2;
				key4_flag=0;	 
		    sec=Sec[j];ms=Ms[j];	//��ʾ�����������
		    j++;	   	
		 }
   	   }//�·�
	   if(!key4)	
	   {
	    delay(50);
		if(!key4)
		{
			while(!key4)
			{;}
			TR0=0;
			key4_flag=1;			 //����4��־
			if(j<0)
			   goto start;
			else
				 if(key3_flag)
			   		j-=2;
				key3_flag=0;
			sec=Sec[j];ms=Ms[j];		  //��ʾ�����������
			j--;
		}   
	   } //����
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
/*      ��ʱ�ж�1                */
/********************************/
void time1_isr(void) interrupt 3 using 0//��ʱ��1������̬ɨ��
{
    static unsigned char num;
    TH1=0xF8;//�����ֵ
	TL1=0xf0;
	switch(num)
	{
   	case 0:	P2=0xfe;P0=tab[sec/10];break;//��ʾ��ʮλ
   	case 1:	P2=0xfd;P0=tab1[sec%10];break; //��ʾ���λ
   	case 2:	P2=0xfb;P0=tab[ms/10];break;//��ʾʮλ
   	case 3: P2=0xf7;P0=tab[ms%10];break; //��ʾ��λ
   	default:break;
	}
	num++;
	if(num==4)
	num=0;
}/********************************/
/*      ��ʱ�ж�0                */
/********************************/
void tim(void) interrupt 1 using 1
{
TH0=0xd8;//���¸�ֵ
TL0=0xf0;
   ms++;//���뵥Ԫ��1
	 if(ms==100)
	 {
		 ms=0;//����100ʱ����
		 sec++;//���1		
		 if(sec==60)
		 {
			 sec=0;//�����60ʱ����
		 }
	 }
}