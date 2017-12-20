width = 24;
depth = 2048;
x = linspace(0,2*pi,depth);
y_sin = (sin(x)+1)/2;
fid = fopen('./run_test.coe', 'w');
fprintf(fid,'%s\n','memory_initialization_radix = 2;');
fprintf(fid,'%s\n','memory_initialization_vector = ');
for i=1:depth-1
    fprintf(fid,'%s,\n',decfra2bin(y_sin(i),23));  %向.coe文件中写入数据
end
fprintf(fid,'%s;\n',decfra2bin(y_sin(depth),23)); 
fclose(fid);  %关闭.coe文件
