Fs = 40000; 
N = 4096; 
N1 = 0 : 1/Fs : N/Fs-1/Fs;
s = sin(2000*2*pi*N1);                                          
fidc = fopen('E:\UWA S3\5552\Project\Design\mem1.txt','wb');    

for x = 1 : N
    A = round(s(x)*20);
   if (A >= 0)
      bin_x = dec2bin(A, 12);     
      fprintf(fidc,'%s\n',bin_x);
   else
      bin_x = dec2bin(2^8 + A, 12);
      fprintf(fidc,'%s\n',bin_x);
   end
end 

fclose(fidc);  
