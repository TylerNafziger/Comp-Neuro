% GUI Combine code. Load GUI files you wish to combine in chronological
% order, run script to combine. Ensure the converted .mat file from the
% data colelction system is also in the same folder. This should be named
% exactly as the name of the GUI output and ending in combined.mat instead
% of .csv
clear, clc
is_param = menu('Is this used for experimental analysis or just housing?','Experimental','Housing');
switch is_param
    case 1
        fileoutname = input('Input Mouse ID, Parameter Number, and Pre or Post 48 (eg. nmod_016_23_pre_48): ','s');
    case 2
        fileoutname = input('Enter name for output file: ','s');
end
combdat = [];
combdat_orig = [];

[filename, pathname] = uigetfile("*.csv","Select Files",'MultiSelect','on');
filecount = length(filename);

for j = 1:filecount
     fullpath{j} = fullfile(pathname, filename{j});
     dat{j} = readmatrix(string(fullpath{j}));
     original_dat_str{j} = filename{j}(1:length(filename{j})-4);
     original_dat_str{j} = append(original_dat_str{j},'combined.mat');
     original_dat{j} = load(original_dat_str{j});
     combdat = [combdat; dat{j}];
     combdat_orig = [combdat_orig; original_dat{j}.sbuf];
end

exportname = append(fileoutname,'.mat');
save(exportname,'combdat','combdat_orig','-v7.3');
