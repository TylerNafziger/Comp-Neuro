function [Vout,mout,hout,nout,t] = HHsim(tspan,inparam,plotstate,Iparam)
% input parameter as cell of V0, C, VNa, VK, VL, GNa, GK, GL, Iapp
% Iparam as cell of function name, function inputs
% plotstate = 1 for plot

if ~exist('Iparam')
    Imag = 0;
    Idur = 0;
    Ifunc = @stepCurrent;
else
    Imag = Iparam{3};
    Idur = Iparam{2};
    Ifunc = Iparam{1};
end


V0 = inparam{1};
C = 10;
VNa = 50;
VK = -77;
VL = -54.4;
GNa =  1200;
GK =   360;
GL = 3;

am0 = alpha_m(V0);
bm0 = beta_m(V0);
ah0 = alpha_h(V0);
bh0 = beta_h(V0);
an0 = alpha_n(V0);
bn0 = beta_n(V0);

minf0 = am0/(am0+bm0);
hinf0 = ah0/(ah0+bh0);
ninf0 = an0/(an0+bn0);

options = odeset('AbsTol', 10^-6, 'RelTol', 10^-6, 'MaxStep', 0.1);

[t,out] = ode15s(@HH_ode,tspan, [0.0529; 0.596; 0.318; -65],options);
if plotstate == 1
    figure(gcf)
    subplot(2,1,1)
    plot(t,out(:,4))
    xlabel('Time (ms)')
    ylabel('Voltage (mV)')
    title('Membrane Potential (mV)')
    subplot(2,1,2)
    plot(t,out(:,1),t,out(:,2),t,out(:,3))
    legend('m','h','n')
    xlabel('Time (ms)')
    ylabel('Probability')
    title('Channel Probabilities')
else
end

 mout = out(:,1);
 hout = out(:,2);
 nout = out(:,3);
 Vout = out(:,4);


function doutdt = HH_ode(t,x)
doutdt = zeros(4,1);
m = x(1);
h = x(2);
n = x(3);
V = x(4);
embedin{1} = t;
embedin{2} = Idur;
embedin{3} = Imag;

am = alpha_m(V);
bm = beta_m(V);
doutdt(1) = am*(1-m)-bm*m;

ah = alpha_h(V);
bh = beta_h(V);
doutdt(2) = ah*(1-h)-bh*h;

an = alpha_n(V);
bn = beta_n(V);
doutdt(3) = an*(1-n)-bn*n;

Iapp = Ifunc(embedin{:});

doutdt(4) = (GNa*m^3*h*(VNa-V) + GK*n^4*(VK-V) + GL*(VL-V) + Iapp)/C;
end

end