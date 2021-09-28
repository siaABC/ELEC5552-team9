%% Wave creation
clear all; 
clc; 
 
fs = 10000; %samples per second
dt = 1/fs; %inverse samples per second
stoptime = 5; %stoptime in seconds
t = (0:dt:stoptime-dt)'; 
fc = 2000; %frequency
y = (cos(2*pi*fc*t)+1)*200; 
plot(y); 
fileID = fopen('test_data.txt','w'); %opens file ; opens in read only but 'w' makes it write
fprintf(fileID,'%f\n',y); %writes value then on the next line prints the next line
fclose(fileID); 