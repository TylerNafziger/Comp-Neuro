function NeuralFeatures = method2(bins, NeuralData, Spike, SamplingRate)
    sampling_period = 1./SamplingRate; % spacing between samples
    size_NeuralData = size(NeuralData,1);
    
    samples_per_bin = size_NeuralData./bins;
    
    % Fancy code to get closest bin size for equal bin width  from desired
    % number of bins.
    if(mod(size_NeuralData, bins) ~= 0)
        factors_matrix_row_length = factor(size_NeuralData);
        A = repmat(samples_per_bin, [1 length(factors_matrix_row_length)]);
        [minVal, closestIndex] = min(abs(A-factors_matrix_row_length'));
    
        samples_per_bin = factors_matrix_row_length(closestIndex(1));
    end
    
    bin_width = samples_per_bin.*sampling_period; % in seconds
    
    spike_count = zeros(1,samples_per_bin);
    firing_rates = zeros(size_NeuralData, 6);
    r_prev = 0;
    time_constant = 10e-3; %10 ms
    
    
    % Simple algo for calculating average spike rate in a bin. Spike rate in a 
    % bin is rate_bin = total_spikes_bin/time_elapsed
    for chan = 1:6
        bin_num = 1;
        for bin = 1:samples_per_bin:size_NeuralData
            spikes_in_window = Spike(bin:bin +(samples_per_bin - 1),chan);
            spike_count(bin_num) = length(spikes_in_window(spikes_in_window == 1));
    
    %         firing_rates(bin:bin +(samples_per_bin - 1), chan) = spike_count(bin_num)./bin_width;
            r_current = (r_prev + spike_count(bin_num)).*(1-exp(-bin_width./time_constant));
            firing_rates(bin:bin +(samples_per_bin - 1), chan) = r_current;
            r_prev = r_current;
            bin_num = bin_num + 1;
        end
    end
    NeuralFeatures = firing_rates;
end