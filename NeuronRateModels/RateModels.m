%% Given a list of times a neuron spikes, we can model spiking rate in many ways
% The spikes can be binned and the number of spikes per bin size can lead
% to a frequency in Hz, a gaussian kernel can be convolved with the spike
% vector and normalized to the global average frequency, or the inverse of the
% interspike interval can be used.

% Tyler Nafziger
clear
clc

tsp = [1 83 103 123 345 374 399 438 464 508 532 576 717 740 791 822 863 894 925 951];

% bins
tbin = 0:50:1000;
binmat = zeros(1,20);
bins = zeros(1,1000);

for j = 1:20
    binmat(j) = length(find(tsp > tbin(j) & tsp < tbin(j+1)))/0.05;
    bins(tbin(j)+1:tbin(j+1)+1) = binmat(j);
end

% convolution
x = -50:50;
kern = normpdf(x,0,25);
t = zeros(1,1000);
t(tsp) = 1;

newkern = kern(51:end);
newkern = newkern/trapz(newkern)*982; % 982 gives integral closest to 20k

convmat = conv(newkern,t);
convmatsplice = convmat(1:1001);

% Interspike
for j = 1:19
    ispike(j) = (tsp(j+1) - tsp(j))^(-1);
    interout(tsp(j):tsp(j+1)) = ispike(j);
end
interout(length(interout):1001) = 0;
interout = interout*1050; %roughly scales to 20k integral

% plot
figure(600)
plot(0:1000,bins,0:1000,convmatsplice,0:1000,interout)
legend('Bins','NormConv','Interspike')

% Max spike rate per model
maxbin = max(bins);
maxconv = max(convmat);
maxi = max(interout);

out1 = ['Maximum spike rate for bins: ',num2str(maxbin)];
out2 = ['Maximum spike rate for convlution: ',num2str(maxconv)];
out3 = ['Maximum spike rate for interspike interval: ',num2str(maxi)];

disp(out1)
disp(out2)
disp(out3)

% Average Spike Rate per model
avebin = mean(bins);
aveconv = mean(convmat);
avei = mean(interout);

out4 = ['Average spike rate for bins: ',num2str(avebin)];
out5 = ['Average spike rate for convlution: ',num2str(aveconv)];
out6 = ['Average spike rate for interspike interval: ',num2str(avei)];

disp(out4)
disp(out5)
disp(out6)
