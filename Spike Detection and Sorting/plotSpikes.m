function spikeCell = plotSpikes(data, plotTitle,spike)
[~,numchannels]=size(data);
figure()
sgtitle(plotTitle)
spikeCell= cell(5,1);
for i=1:numchannels
    negWin = -3;
    posWin = 18;
    
    spikeLocations = spike(:,i);
    spikeLocations = find(spikeLocations == 1);
    spikeCount=sum(spike);
    spikes = cell(1,spikeCount(i));
    
    subplot(2,3,i)
    for j = 1: length(spikes)
        startIdx = spikeLocations(j) + negWin;
        endIdx = spikeLocations(j) + posWin;
        try
            spikes{j} = data(startIdx:endIdx,i);
            plot(0:33:700,spikes{j});
        catch
        end
        
        hold on;
        spikeCell{i} = spikes;
    end
    xlabel('Time (\mus)')
    ylabel('Voltage (\muV)')
%     xlim([])
%     ylim([])
    hold off
    title(['Channel ' num2str(i) ' spikes: ' num2str(length(spikes))])
    
    
end

end