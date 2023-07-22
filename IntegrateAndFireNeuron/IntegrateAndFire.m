%% Simple Integrate and Fire Neuron Model
% Tyler Nafziger

% Models an integrate and fire neuron when given a sinusoidal or square 
% wave current input with variable frequency and amplitude
clear
clc

% Sine Varying Amplitude Test 1
param{2} = 50; % current input frequency (Hz)
param{3} = 0.5; % Current max amplitude (nA)

figure(1)
subplot(2,2,1)
MyIntegrateAndFire(@sineCurrent,param,[-10 100],-60);

% Sine Varying Amplitude Test 2
param{2} = 50; % current input frequency (Hz)
param{3} = 1; % Current max amplitude (nA)

figure(1)
subplot(2,2,1)
hold on
MyIntegrateAndFire(@sineCurrent,param,[-10 100],-60);
legend('0.5 nA','1 nA','location','northwest')
title('50 Hz sinusoid')

% Sine Varying Frequency Test 1
param{2} = 50; % current input frequency (Hz)
param{3} = 1; % Current max amplitude (nA)

figure(1)
subplot(2,2,3)
hold on
MyIntegrateAndFire(@sineCurrent,param,[-10 100],-60);


% Sine Varying Frequency Test 2
param{2} = 100; % current input frequency (Hz)
param{3} = 1; % Current max amplitude (nA)

figure(1)
subplot(2,2,3)
hold on
MyIntegrateAndFire(@sineCurrent,param,[-10 100],-60);
legend('50 Hz','100 Hz','location','northwest')
title('1 nA sinusoid')

% Square Varying Ampltiude Test 1
clear param
param{2} = 100; % set parameters for stepCurrent
param{3} = 99e-12;

figure(1)
subplot(2,2,2)
hold on
MyIntegrateAndFire(@stepCurrent,param,[-10 100],-60);

% Square Varying Ampltiude Test 2
clear param
param{2} = 100; % set parameters for stepCurrent
param{3} = 101e-12;

figure(1)
subplot(2,2,2)
hold on
MyIntegrateAndFire(@stepCurrent,param,[-10 100],-60);
legend('99 pA','101 pA','location','northwest')
title('100 ms step')

% Square Varying Frequency Test 1
clear param
param{2} = 29; % set parameters for stepCurrent
param{3} = 130e-12;

figure(1)
subplot(2,2,4)
hold on
MyIntegrateAndFire(@stepCurrent,param,[-10 100],-60);
% Square Varying Frequency Test 2
clear param
param{2} = 30; % set parameters for stepCurrent
param{3} = 130e-12;

figure(1)
subplot(2,2,4)
hold on
MyIntegrateAndFire(@stepCurrent,param,[-10 100],-60);
legend('29 ms','30 ms')
title('130 pA step')
