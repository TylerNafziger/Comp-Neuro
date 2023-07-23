%% Load Data
clear
clc
load('ResearchProject2') % load mat file containing the following variables
% Kinematics: This is a 9481995x2 array containing the intended kinematics 
% of the individual. 9481995 samples in time, and two degrees of freedom 
% (finger in column 1 and wrist rotate in column 2)
% unfilteredNeuralData: This is a 9481995x6 array containing 6 channels of 
% neural data from implanted Utah Slanted Electrode Arrays.
% Both datasets are sampled at 30 kHz. 
plotNeuralData(unfilteredNeuralData,'Unfiltered Neural Data')

%% Filter Properties

SamplingRate = 30e3; %sampling Frequency in Hz
CutOffFrequeqncy = 1e3; %cutoff frequency of highpass filter in Hz

% Filter Neural Data using the values you changed
%butterworth filter to use with FilterX (mex function for filtering)
[bHP,aHP] = butter(4,CutOffFrequeqncy/(SamplingRate/2),'high'); 
cHP = zeros(4,6); %initial conditions for filter for all channels
[NeuralData,~] = FilterX(bHP,aHP,unfilteredNeuralData,cHP);
% Plot Filtered Data
plotNeuralData(NeuralData,'Filtered Neural Data')

%% Spike Detection

Spike = zeros(size(NeuralData));

threshIndex = find(NeuralData >= 15);
peakindex = zeros(size(threshIndex));
spike_pad = zeros(size(NeuralData));

for i = 1:length(threshIndex)
    peakindex = find(NeuralData == max(NeuralData(threshIndex(i)-21:threshIndex(i)+21)));
    Spike(peakindex) = 1;
    spike_pad(peakindex-3:peakindex+18) = 1;
end

% Plot Spikes
spikeWaveforms=plotSpikes(NeuralData,'Recorded Action Potentials',Spike);

%% Calculate Signal to Noise Ratio

noiseband = cell(1,6);
for channelIndex = 1:6
    noiseband{channelIndex} = NeuralData(:,channelIndex) - NeuralData(:,channelIndex).*spike_pad(:,channelIndex);
    NP(channelIndex) = rms(noiseband{channelIndex})^2;
end

SNR = cell(1,6);
for channelIndex = 1:6 % go through each channel
    channelWaveforms = spikeWaveforms{channelIndex}; 
    for waveformIndex = 1:length(channelWaveforms)%go through each waveform
        waveform = channelWaveforms{waveformIndex};
        SNR{channelIndex}(waveformIndex) = rms(waveform)^2/NP(channelIndex);
    end
end

%% Generate Features

menuselect = menu('Select Method: ',"Method1", "Method2");
switch menuselect
    case 1
        NeuralFeatures = method1(Spike);
    case 2
        NeuralFeatures = method2(20, NeuralData, Spike, SamplingRate);             
end

%% Visualize Features
figure()
subplot(311)
plot(Kinematics(:,1),'-k','LineWidth',5)
hold on
plot(Kinematics(:,2),'-r','LineWidth',5)
legend('Hand Grasp Movement','Wrist Rotation Movement')
title('Kinematics')
ylabel('Range of Motion (normalized)')
xlabel('Time (samples)')
subplot(312)
plot(NeuralFeatures)
title('Neural Features')
xlabel('Time (samples)')
ylabel('Feature Value')
subplot(313)
plot(Kinematics(:,1),'-k','LineWidth',5)
hold on
plot(Kinematics(:,2),'-r','LineWidth',5)
plot(NeuralFeatures/max(max(NeuralFeatures)))
title('Normalized Neural Features & Kinematics Overlaid')
xlabel('Time (samples)')
ylabel('Normalized Value')
legend('Hand Grasp Movement','Wrist Rotation Movement')

%% Train Neural Network
% Set Neural Network Properties

learnRate=.1;
maxEpoch=3;

%  Train Neural Network
net=trainNeuralNetwork(learnRate, maxEpoch, NeuralFeatures/max(max(NeuralFeatures)), Kinematics);
%% Loading Testing Data
load('ResearchProject2TestData') 
% this loads two variables KinematicsTest, and unfilteredNeuralDataTest.
% these variables have roughly the same shape as the training versions
% above, and follow the same format for what information is stored in each
% column.
unfilteredNeuralDataTest(length(unfilteredNeuralDataTest) + 1,:) = 0;
%% Test neural network

% Filter Data 
SamplingRate = 30e3; %sampling Frequency in Hz
CutOffFrequeqncy = 1e3; %cutoff frequency of highpass filter in Hz

% butterworth filter to use with FilterX (mex function for filtering)
[bHP,aHP] = butter(4,CutOffFrequeqncy/(SamplingRate/2),'high'); 
cHP = zeros(4,6); %initial conditions for filter for all channels
[NeuralDataTest,~] = FilterX(bHP,aHP,unfilteredNeuralDataTest,cHP);
% Plot Filtered Data
plotNeuralData(NeuralDataTest,'Filtered Neural Data')

% Spike Detection

SpikeTest = zeros(size(NeuralDataTest));

threshIndex = find(NeuralDataTest >= 15);
peakindex = zeros(size(threshIndex));
spike_pad = zeros(size(NeuralDataTest));

for i = 1:length(threshIndex)
    peakindex = find(NeuralDataTest == max(NeuralDataTest(threshIndex(i)-21:threshIndex(i)+21)));
    SpikeTest(peakindex) = 1;
    spike_pad(peakindex-3:peakindex+18) = 1;
end

% Feature Generation
switch menuselect
    case 1
        NeuralFeaturesTest = method1(Spike);
    case 2
        NeuralFeaturesTest = method2(20, NeuralDataTest, SpikeTest, SamplingRate);             
end

% Test Neural Network
predictions = testNeuralNetwork(NeuralFeaturesTest/max(max(NeuralFeaturesTest)),net); % this may take a few seconds!
%% Visualize Output
figure()
subplot(211)
plot(KinematicsTest(:,1))
hold on;
plot(predictions(:,1))
title('Hand Grasp Movement')
xlabel('Time (samples)')
ylabel('Range of Motion (normalized)')
legend('Kinematics (ground truth)','Network Output (predictions)')
subplot(212)
plot(KinematicsTest(:,2))
hold on;
plot(predictions(:,2))
title('Wrist Rotation Movement')
xlabel('Time (samples)')
ylabel('Range of Motion (normalized)')
legend('Kinematics (ground truth)','Network Output (predictions)')