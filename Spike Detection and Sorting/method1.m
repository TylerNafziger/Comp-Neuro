function NeuralFeatures = method1(Spike)
%METHOD1 Basic Moving average of the voltage and check passing a threshold
%from below
    NeuralFeatures = movmean(Spike,10000);
end

