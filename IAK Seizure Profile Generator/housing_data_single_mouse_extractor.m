%% Load Files
clear
clc

mID = input('Enter mouse ID (ex. 017): ');
chann_prompt = 'Enter channel number of mouse';
chann = menu(chann_prompt,1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16');

disp('Select all files to extract mouse data from')
[filename, pathname] = uigetfile("*.mat","Select Files", 'MultiSelect', 'on');
fullpath = fullfile(pathname, filename);

%% Extract
for j = 1:length(filename)
    dat{j} = load(string(fullpath{j}));
    dat{j}.sbuf = dat{j}.sbuf(:,chann);
    dat{j}.trdata = dat{j}.trdata(chann);
    dat{j}.number_of_channels = 1;
end

%% Save
for j = 1:length(filename)
    save_name{j} = append(sprintf('nmod_%03.f_',mID),filename{j});
    saven_name{j} = append(save_name{j},'combined.mat');
    fs = dat{j}.fs;
    number_of_channels = dat{j}.number_of_channels;
    sbuf = dat{j}.sbuf;
    trdata = dat{j}.trdata;
    save(save_name{j},'fs','number_of_channels','sbuf','trdata');
end
