% Check to ensure the housing_data main program outputs are in the current
% directory
clc, clear
param_or_mouse = menu('Is this a comparison of FUS parameters or animals?','FUS parameters','Animals');
switch param_or_mouse
    case 1
        param_length = input('Enter number of parameters being tested: ');
        for j = 1:param_length
            parameter(j) = input('Enter a parameter number: ');
        end
    case 2
        param_length = input('Enter number of animals being tested: ');
        for j = 1:param_length
            parameter(j) = input('Enter a animal ID: ');
        end
end
%%
bars_cat = {};
bars_fin = {};
switch param_or_mouse
    case 1
        for k = 1:param_length
            disp(sprintf('Load all parameter %d tx files',parameter(k)));
            [filename{k}, pathname{k}] = uigetfile("*.mat","Select Files", 'MultiSelect', 'on');
            fullpath{k} = fullfile(pathname{k}, filename{k});
            if strcmp(class(filename{k}),'cell') == 0
                fullpathtemp = fullpath{k};
                fullpath{k} = {};
                fullpath{k}{1} = fullpathtemp;
            end
            for j = 1:length(fullpath{k})
                bars_set{k}{j} = load(string(fullpath{k}{j}));
                bars{k}{j} = bars_set{k}{j}.bar_form;
            end

            disp(sprintf('Load all parameter %d sham files',parameter(k)));
            [filename{param_length + k}, pathname{param_length + k}] = uigetfile("*.mat","Select Files", 'MultiSelect', 'on');
            fullpath{param_length + k} = fullfile(pathname{param_length + k}, filename{param_length + k});
            if strcmp(class(filename{param_length + k}),'cell') == 0
                fullpathtemp = fullpath{param_length + k};
                fullpath{param_length + k} = {};
                fullpath{param_length + k}{1} = fullpathtemp;
            end
            for j = 1:length(fullpath{k})
                bars_set{param_length + k}{j} = load(string(fullpath{param_length + k}{j}));
                bars{param_length + k}{j} = bars_set{param_length + k}{j}.bar_form;
            end
            bars_cat{k} = cat(3,bars{k}{:});
            bars_fin{k} = mean(bars_cat{k},3);
            err{k} = std(bars_cat{k},1,3);

            bars_cat{param_length + k} = cat(3,bars{param_length + k}{:});
            bars_fin{param_length + k} = mean(bars_cat{param_length + k},3);
            err{param_length + k} = std(bars_cat{param_length + k},1,3);
        end
    case 2
        for k = 1:param_length
            disp(sprintf('Load all animal %d files',parameter(k)))
            [filename{k}, pathname{k}] = uigetfile("*.mat","Select Files", 'MultiSelect', 'on');
            fullpath{k} = fullfile(pathname{k}, filename{k});
            if strcmp(class(filename{k}),'cell') == 0
                fullpathtemp = fullpath{k};
                fullpath{k} = {};
                fullpath{k}{1} = fullpathtemp;
            end
            for j = 1:length(fullpath{k})
                bars_set{k}{j} = load(string(fullpath{k}{j}));
                bars{k}{j} = bars_set{k}{j}.bar_form;
            end


            for j = 1:length(fullpath{k})
                bars_set{k}{j} = load(string(fullpath{k}{j}));
                bars{k}{j} = bars_set{k}{j}.bar_form;
            end
            bars_cat{k} = cat(3,bars{k}{:});
            bars_fin{k} = mean(bars_cat{k},3);
            err{k} = std(bars_cat{k},1,3);

            bars_cat{k} = cat(3,bars{k}{:});
            bars_fin{k} = mean(bars_cat{k},3);
            err{k} = std(bars_cat{k},1,3);
        end
end

%% Setup
bar_form_tx_dur = bars_fin{1}(1,:)';
bar_form_tx_int = bars_fin{1}(2,:)';
bar_form_tx_freq = bars_fin{1}(3,:)';
bar_form_tx_freed = bars_fin{1}(4,:)'.*100;
bar_form_sham_dur = bars_fin{1}(1,:)';
bar_form_sham_int = bars_fin{1}(2,:)';
bar_form_sham_freq = bars_fin{1}(3,:)';
bar_form_sham_freed = bars_fin{1}(4,:)'.*100;
err_sham_dur = err{1}(1,:)';
err_sham_int = err{1}(2,:)';
err_sham_freq = err{1}(3,:)';
err_sham_freed = err{1}(4,:)';
err_tx_dur = err{1}(1,:)';
err_tx_int = err{1}(2,:)';
err_tx_freq = err{1}(3,:)';
err_tx_freed = err{1}(4,:)';


if param_length > 1
    for k = 2:param_length
        bar_form_tx_dur = [bar_form_tx_dur bars_fin{k}(1,:)'];
        bar_form_tx_int = [bar_form_tx_int bars_fin{k}(2,:)'];
        bar_form_tx_freq =[bar_form_tx_freq bars_fin{k}(3,:)'];
        bar_form_tx_freed = [bar_form_tx_freed bars_fin{k}(4,:)'.*100];
        err_tx_dur = [err_tx_dur err{k}(1,:)'];
        err_tx_int = [err_tx_int err{k}(2,:)'];
        err_tx_freq = [err_tx_freq err{k}(3,:)'];
        err_tx_freed = [err_tx_freed err{k}(4,:)'.*100];
    end
end

    

if param_length > 1
    for k = 2:param_length
        bar_form_sham_dur = [bar_form_sham_dur bars_fin{param_length + k}(1,:)'];
        bar_form_sham_int = [bar_form_sham_int bars_fin{param_length + k}(2,:)'];
        bar_form_sham_freq =[bar_form_sham_freq bars_fin{param_length + k}(3,:)'];
        bar_form_sham_freed = [bar_form_sham_freed bars_fin{param_length + k}(4,:)'.*100];
        err_sham_dur = [err_sham_dur err{param_length + k}(1,:)'];
        err_sham_int = [err_sham_int err{param_length + k}(2,:)'];
        err_sham_freq = [err_sham_freq err{param_length + k}(3,:)'];
        err_sham_freed = [err_sham_freed err{param_length + k}(4,:)'.*100];
    end
end

min_freq = min([min(bar_form_tx_freq) min(bar_form_sham_freq)]);
max_freq = max([max(bar_form_tx_freq) max(bar_form_sham_freq)]);
min_freed = min([min(bar_form_tx_freed) min(bar_form_sham_freed)]);
max_freed = max([max(bar_form_tx_freed) max(bar_form_sham_freed)]);
min_dur = min([min(bar_form_tx_dur) min(bar_form_sham_dur)]);
max_dur = max([max(bar_form_tx_dur) max(bar_form_sham_dur)]);
min_int = min([min(bar_form_tx_int) min(bar_form_sham_int)]);
max_int = max([max(bar_form_tx_int) max(bar_form_sham_int)]);

%% Plot 1
file_strng = {'Pre-48','Pre-FUS','FUS','Post-FUS','Post-48'};

f1 = figure(1);
f1.Position = [0 0 1500 700];
ngroups = size(bar_form_sham_dur,1);
nbars = size(bar_form_sham_dur,2);
groupwidth = min(0.8, nbars/(nbars + 1.5));

form_mast = '';
for j = 1:param_length
    formatspec{j} = sprintf('Parameter %d',parameter(j));
end

s1 = subplot(2,2,1);
bar(bar_form_tx_dur)
xticklabels(file_strng)
title('Seizure Duration')
ylabel('Time (sec)')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_tx_dur(:,p),err_tx_dur(:,p),'.')
end
hold off
ylim([0 max(max(bar_form_tx_dur))+max(max(err_tx_dur))+1])
legend(formatspec,'location','southoutside')

s2 = subplot(2,2,2)
bar(bar_form_tx_int)
xticklabels(file_strng)
title('Interictal Interval')
ylabel('Time (sec)')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_tx_int(:,p),err_tx_int(:,p),'.')
end
hold off
ylim([0 max(max(bar_form_tx_int))+max(max(err_tx_int))])
legend(formatspec,'location','southoutside')

s3 = subplot(2,2,3)
bar(bar_form_tx_freq)
xticklabels(file_strng)
title('Seizure Frequency')
ylabel('Seizures per Hour')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_tx_freq(:,p),err_tx_freq(:,p),'.')
end
hold off
ylim([0 max_freq*1.01])
legend(formatspec,'location','southoutside')

s4 = subplot(2,2,4)
bar(bar_form_tx_freed)
xticklabels(file_strng)
ylim([min_freed*0.98 max_freed*1.002])
title('Seizure Freedom')
ylabel('Percent')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_tx_freed(:,p),err_tx_freed(:,p),'.')
end
hold off
legend(formatspec,'location','southoutside')

sgtitle('Treatment Profile')

%% Plot 2
figure(2)
f2 = figure(2);
f2.Position = [0 0 1500 700];

ngroups = size(bar_form_sham_dur,1);
nbars = size(bar_form_sham_dur,2);
groupwidth = min(0.8, nbars/(nbars + 1.5));

s1 = subplot(2,2,1);
bar(bar_form_sham_dur)
xticklabels(file_strng)
title('Seizure Duration')
ylabel('Time (sec)')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_sham_dur(:,p),err_sham_dur(:,p),'.')
end
hold off
ylim([0 max(max(bar_form_sham_dur))+max(max(err_sham_dur))+1])
legend(formatspec,'location','southoutside')


s2 = subplot(2,2,2)
bar(bar_form_sham_int)
xticklabels(file_strng)
title('Interictal Interval')
ylabel('Time (sec)')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_sham_int(:,p),err_sham_int(:,p),'.')
end
hold off
ylim([0 max(max(bar_form_sham_int))+max(max(err_sham_int))])
legend(formatspec,'location','southoutside')


s3 = subplot(2,2,3)
bar(bar_form_sham_freq)
xticklabels(file_strng)
title('Seizure Frequency')
ylabel('Seizures per Hour')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_sham_freq(:,p),err_sham_freq(:,p),'.')
end
hold off
ylim([0 max_freq*1.01])
legend(formatspec,'location','southoutside')


s4 = subplot(2,2,4)
bar(bar_form_sham_freed)
xticklabels(file_strng)
ylim([min_freed*0.98 max_freed*1.002])
title('Seizure Freedom')
ylabel('Percent')
hold on
for p = 1:nbars
    x_bar = (1:ngroups) - groupwidth/2 + (2*p-1)*groupwidth/(2*nbars);
    errorbar(x_bar,bar_form_sham_freed(:,p),err_sham_freed(:,p),'.')
end
hold off
legend(formatspec,'location','southoutside')

sgtitle('Sham Profile')

%% Save
saveas(figure(1),'Plot1.png')
saveas(figure(2),'Plot2.png')

%% TX Separate (Only run for experimental data)
for j = 1:param_length
    mouse_size{j} = size(bars_cat{j});
    if length(mouse_size{j}) < 3
        mouse_count{j} = 1;
    else
        mouse_count{j} = mouse_size{j}(3);
    end
end
sep_dat = {};
for k = 1:param_length
    for j = 1:mouse_count{k}
        sep_dat{k}{j} = bars_cat{k}(:,:,j);
        sep_bar_form_tx_dur{k}{j} = sep_dat{k}{j}(1,:);
        sep_bar_form_tx_int{k}{j} = sep_dat{k}{j}(2,:);
        sep_bar_form_tx_freq{k}{j} = sep_dat{k}{j}(3,:);
        sep_bar_form_tx_freed{k}{j} = sep_dat{k}{j}(4,:).*100;
        sep_dat{k+3}{j} = bars_cat{k+3}(:,:,j);
        sep_bar_form_sham_dur{k}{j} = sep_dat{k+3}{j}(1,:);
        sep_bar_form_sham_int{k}{j} = sep_dat{k+3}{j}(2,:);
        sep_bar_form_sham_freq{k}{j} = sep_dat{k+3}{j}(3,:);
        sep_bar_form_sham_freed{k}{j} = sep_dat{k+3}{j}(4,:).*100;
    end
end

%% Plot Separate
clrs = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
str_param = string(parameter);

f3 = figure(3);
f3.Position = [0 0 1500 700];

subplot(2,2,1)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_tx_dur{k}{j},'color',clrs(k))
    end
    ylim([0 max_dur*3])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Time (sec)')
title('Seizure Duration')

subplot(2,2,2)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_tx_int{k}{j},'color',clrs(k))
    end
    ylim([0 max_int*3])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Time (sec)')
title('Interictal Interval')

subplot(2,2,3)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_tx_freq{k}{j},'color',clrs(k))
    end
    ylim([0 max_freq*1.01])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Seizures per Hour')
title('Seizure Frequency')

subplot(2,2,4)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_tx_freed{k}{j},'color',clrs(k))
    end
    ylim([min_freed*0.98 max_freed*1.002])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Percent')
title('Seizure Freedom')

sgtitle('Treatment Profile')

%% Plot Separate Sham
f4 = figure(4);
f4.Position = [0 0 1500 700];


subplot(2,2,1)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_sham_dur{k}{j},'color',clrs(k))
    end
    ylim([0 max_dur*3])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Time (sec)')
title('Seizure Duration')

subplot(2,2,2)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_sham_int{k}{j},'color',clrs(k))
    end
    ylim([0 max_int*3])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Time (sec)')
title('Interictal Interval')

subplot(2,2,3)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_sham_freq{k}{j},'color',clrs(k))
    end
    ylim([0 max_freq*1.01])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Seizures per Hour')
title('Seizure Frequency')

subplot(2,2,4)
hold on
for k = 1:param_length
    plot(nan,'color',clrs(k))
end
for k = 1:param_length
    for j = 1:mouse_count{k}
        plot(sep_bar_form_sham_freed{k}{j},'color',clrs(k))
    end
    ylim([min_freed*0.98 max_freed*1.002])
end
legend(str_param)
set(gca,'XTick',1:5)
xticklabels(file_strng)
ylabel('Percent')
title('Seizure Freedom')

sgtitle('Sham Profile')

%% Save
saveas(f3,'Plot3.png')
saveas(f4,'Plot4.png')