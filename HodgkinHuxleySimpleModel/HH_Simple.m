%% Simple Hodgkin-Huxley Model with Sodium, Potassium, and Leak Channels
% Simple Hodgkin-Huxley model which uses m^3h and n^4 protein models for
% Sodium and Potassium respectively. Alpha and Beta rates determined by
% rate functions listed in the folder

% Tyler Nafziger
clear
clc

%% Determine steady state values of the model with no given input current
figure(1)
sgtitle('Initial V = 0')
tspan = 0:0.1:500; % ms
inparam = num2cell([-0, 10, 60, -80, -60, 192, 48, 5]); % set cell input paramaters
% order of V0, C, VNa, VK, VL, GNa, GK, GL, Iapp
[~] = HHsim(tspan,inparam,1);

disp('Steady state voltage: -62.0601 mV')
disp('Steady state m: 0.074')
disp('Steady state h: 0.491')
disp('Steady state n: 0.364')

%% Model of Neuron with Square wave current inputs
figure(2)
tspan = 0:0.1:100;
inparam = num2cell([-65, 10, 50, -77, -54.4, 1200, 360, 3]);
Iparam{1} = @stepCurrent;
Iparam{2} = 50;
Iparam{3} = 20;

[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

hold on
Iparam{3} = 40; % Input Current Magnitude
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{3} = 60;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{3} = 80;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{3} = 100;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

title('Positive Current Membrane Potentials')
legend('20 fA/um^2','40 fA/um^2','60 fA/um^2','80 fA/um^2','100 fA/um^2')
xlabel('Time (ms)')
ylabel('Membrane Potential (mV)')

% Test negative input polarity
figure(3)
tspan = 0:0.1:100;
inparam = num2cell([-60, 10, 60, -80, -60, 192, 48, 5]);
Iparam{1} = @stepCurrent;
Iparam{2} = 50;
Iparam{3} = -10;

[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

hold on
Iparam{3} = -20;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{3} = -30;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{3} = -40;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{3} = -50;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

title('Negative Current Membrane Potentials')
legend('-10 fA/um^2','-20 fA/um^2','-30 fA/um^2','-40 fA/um^2','-50 fA/um^2','location','southeast')
xlabel('Time (ms)')
ylabel('Membrane Potential (mV)')

disp('With increasing current magnitude each signal gets more depolarized')
disp('None of the currents tested here result in rebound action potentials')


%% Determine Strength Duration Curves of the Model, Rheobase, and Chronaxie
figure(5)
Iparam{3} = 49; % Input Current Magnitude
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)
xlabel('Time (ms)')
ylabel('Membrane Potential (mV)')
title('Experimental Positive Rheobase')
hold on
Iparam{3} = 50;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{3} = 51;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)
legend('49 fA/um^2','50 fA/um^2','51 fA/um^2')

disp('Rheobase is roughly 50 fA/um^2 for positive current')

% 3B
figure(7)
Iparam{3} = 2*50;
Iparam{2} = 1.6;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)
xlabel('Time (ms)')
ylabel('Membrane Potential (mV)')
title('Experimental Positive Chronaxie')
hold on

Iparam{2} = 1.7;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

Iparam{2} = 1.8;
[Vout,~,~,~,t] = HHsim(tspan,inparam,0,Iparam);
plot(t,Vout)

legend('1.6 ms','1.7 ms','1.8 ms')
