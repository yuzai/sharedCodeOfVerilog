function [s] = decfra2bin(a,N)
%�򵥵Ľ�10����ת��ΪNΪ2����С��
m=10;
if nargin~=2
    error('You have to  input two arguments.')
end
if a<0 || N<0
    error('You have to input a positive number')
end
if a>=1
    error('You have to input a decimal for a')
end
if N~=fix(N)
    error('You have to input a integer for N')
end
s(1) = '0';
for i= 2: N+1
    temp=a*2;
    s(i)=int2str(floor(temp));
    a=temp-floor(temp);
end
end
