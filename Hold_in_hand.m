clear all
close all

%% File loading and data processing
filename = '1_27_16_32_matlab.csv';
M = csvread(filename,1,0)
time = M(:,1)
X = M(:,2)
Y = M(:,3)
Z = M(:,4)
mag = sqrt(X.^2+Y.^2+Z.^2);
magNoG = mag - 9.8;
%magNoG = mag - mean(mag) %10.7233 for 4th

%% Figure
figure
plot(time,X)
title('X axis of acceleration over time')
xlabel('time/second')
ylabel('m/s^2')
saveas(gcf,'figure1.png')

figure
plot(time,Y)
title('Y axis of acceleration over time')
xlabel('time/seconds')
ylabel('m/s^2')
saveas(gcf,'figure2.png')

figure
plot(time,Z)
title('Z axis of acceleration over time')
xlabel('time/seconds')
ylabel('m/s^2')
saveas(gcf,'figure3.png')

figure
plot(time,X, time, Y, time, Z)
title('3D acceleration over time')
xlabel('time/seconds)')
ylabel('m/s^2')
legend('X', 'Y', 'Z')
saveas(gcf,'figure4.png')

figure
plot(time,magNoG)
title('Non-Gavity Magnitude acceleration over time')
xlabel('time/seconds')
ylabel('m/s^2')

%% Zero Crossing Method
%abovezero = magNoG > 0;
%zeroCrossing = diff(abovezero) == 1;
%zeroCrossingNegative = diff(abovezero) == -1;
%[zeroCrossingIndex,zeros] = find(zeroCrossing);
%[zeroCrossingNIndex,zerosN] = find(zeroCrossingNegative);
%numberOfSteps = numel(zeroCrossingIndex) + numel(zeroCrossingNIndex)

%% Low Pass Filter
B = [1 -0.95]; % 0.95 to 0.97 pre-emphasis filter
filteredMagNoG = filter(B,1,magNoG);
%{
Fs=25000; % sampling frequency
Fhp=10000; % low pass filter cutofff frequency 10 Hz
[b,a]=butter(5,Fhp/Fs,'low'); % Butter lowpass filter
filteredMagNoG = filter(b,a,magNoG); 
%}

hold on
plot(time, filteredMagNoG, 'r')
legend('Without filter','Filtered')
hold off
saveas(gcf,'figure5.png')



%% Peak Method Without Filtering
minPeakHeight = std(magNoG);
%minPeakHeight = 1;
[pks, locs] = findpeaks(magNoG, 'MINPEAKHEIGHT', minPeakHeight);

numSteps = numel(pks);

figure
plot(time, magNoG)
hold on
%plot(time(zeroCrossingIndex), zeros, 'b', 'Marker', 'v', 'LineStyle', 'none');
%plot(time(zeroCrossingNIndex), zerosN, 'b', 'Marker', 'v', 'LineStyle', 'none');
plot(time(locs), pks, 'r', 'Marker', 'v', 'LineStyle', 'none');
strNum = num2str(numSteps)
title('Non-Gavity Magnitude of accleration over time with Peak find')
xlabel('time/seconds')
ylabel('m/s^2')
legend('Original Non-Gravity Magnitude of Acceleration', ['Peak and Valley: ' strNum], 'location','northoutside')
hold off
saveas(gcf,'figure6.png')

%% Peak Method With Filtering
figure
plot(time, filteredMagNoG)
minPeakHeight = std(filteredMagNoG);
[pks, locs] = findpeaks(filteredMagNoG, 'MINPEAKHEIGHT', minPeakHeight);
numSteps = numel(pks)
strNum = num2str(numSteps)
hold on
plot(time(locs), pks, 'r', 'Marker', 'v', 'LineStyle', 'none');
title('Non-Gavity Magnitude of accleration over time with Peak find')
xlabel('time/seconds')
ylabel('m/s^2')
legend('Filtered Non-Gravity Magnitude of Acceleration', ['Peak and Valley: ' strNum], 'location','northoutside')
hold off
saveas(gcf,'figure7.png')

%% Speed Analysis
%{
velocity = 0 + cumtrapz(time,magNoG);
positions = 0 + cumtrapz(time, velocity);

figure
plot(time, velocity, time, filteredMagNoG)
figure
plot(time, positions)
%}
