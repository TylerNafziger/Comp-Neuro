%% Housing Data Analysis
% This script upon user selection of gui output csv files and parameter number 
% will find and calculate for various information. This includes seizure duration,
% interictal interval, seizure freedom, and seizure frequency (seizures per
% day)

% To use, choose whether this is a parameter grouping of pre-fus, fus, and
% post-fus. If choose no then choose how many files are loaded. Then run
% calculations and bar graph sections.

% Ensure converted .mat file is in the same directory as gui output folder
% (eg. nmod_016_23_001_05_25_2022_2_1combined.mat). In addition ensure this
% has the exact same name with the exception of the combined.mat. For this
% example the gui output should be named
% nmod_016_23_001_05_25_2022_2_1.csv

%% Time Segment Get info
timeseglength = input('Input time length of files in days: ');
startdate = input('Input date of first file (format YYYY/MM/DD): ','s');
enddate = input('Input date of last file (format YYYY/MM/DD): ','s');
%%
startyear = double(startdate(1:4))-48;
startyear = sscanf(sprintf('%d', startyear), '%f');
startmonth = double(startdate(6:7))-48;
startmonth = sscanf(sprintf('%d', startmonth), '%f');
startday = double(startdate(9:10))-48;
startday = sscanf(sprintf('%d', startday), '%f');

startdatetime = datetime(startyear,startmonth,startday);
startdayofyear = day(startdatetime,'dayofyear');
startminuteofyear = startdayofyear*1440;

endyear = double(enddate(1:4))-48;
endyear = sscanf(sprintf('%d', endyear), '%f');
endmonth = double(enddate(6:7))-48;
endmonth = sscanf(sprintf('%d', endmonth), '%f');
endday = double(enddate(9:10))-48;
endday = sscanf(sprintf('%d', endday), '%f');

enddatetime = datetime(endyear,endmonth,endday);
enddayofyear = day(enddatetime,'dayofyear');
endminuteofyear = enddayofyear*1440 + 24*60;
%% Get File for CSV
clear
clc
% run to extract data saved from the gui as .csv

% select gui output file directory: eg. E:\Analysis\.mat files

numfiles = input("Enter the Number of Time Segments (Files) to Analyze: ");
fullpath = {};
k = 1;

for j = 1:numfiles
    disp(['Enter all animal files for time section ',num2str(j)]);
    [filename, pathname] = uigetfile("*.csv","Select Files",'MultiSelect','on');
    numanimal = length(filename);
    for animal = 1:numanimal
        fullpath{k,animal} = fullfile(pathname, filename{animal});
        csv{k,animal} = load(string(fullpath{k,animal}));
    end
    k = k+1;
end

%% Extract Seizure Time Stamps and Durations
[csvlength, csvwidth] = size(csv);
stamp = cell(size(csv));
duration = cell(size(csv));
numseizures = zeros(size(csv));
for j = 1:csvwidth
    for k = 1:csvlength
        if ~isempty(csv{k,j})
        stamp{k,j} = csv{k,j}(:,1:6);
        duration{k,j} = csv{k,j}(:,13);
        numseizures(k,j) = length(duration{k,j});
        end
    end
end
numseizures = numseizures';
%% Produce Number of Seizures Heatmap
timelabel = 1:timeseglength:length(duration)*timeseglength+1*timeseglength;

figure(1)
heatmap(numseizures,'CellLabelColor','none','Colormap',flipud(hot))
xlabel('Time (Days)')
ylabel('Animal')
set(gca,'XData',timelabel)
set(gca,'YData',1:animal)
tit = input('Input Title Name: ','s');
title(tit)
set(gcf,'color','white')

%% Produce Average Seizure Duration and Frequency Plot
% fulltimevec = 0:1/1440:enddayofyear-startdayofyear;
seizuretimestamp = {};
seizminuteofyear = {};
for j = 1:csvlength
    for k = 1:csvwidth
        if ~isempty(stamp{j,k})
            for s = 1:size(csv{j,k},1)
                seizuretimestamp{j,k}(s) = datetime(csv{j,k}(s,1), csv{j,k}(s,2), csv{j,k}(s,3), csv{j,k}(s,4), csv{j,k}(s,5), floor(csv{j,k}(s,6)));
                seizminuteofyear{j,k}(s) = day(seizuretimestamp{j,k}(s),'dayofyear')*1440 + hour(seizuretimestamp{j,k}(s))*60 + minute(seizuretimestamp{j,k}(s));
            end
        end
    end
end
minutestime = startminuteofyear:endminuteofyear;

% average seizures
kern = kern/trapz(kern);
seizminutevector = cell(1,animal);
for a = 1:animal
    for j = 1:length(seizminuteofyear)
        if ~isempty(seizminuteofyear{j,a})
                seizminutevector{a} = [seizminutevector{a}; seizminuteofyear{j,a}'];
        end
    end
    seizminutevector{a} = seizminutevector{a} - startminuteofyear;
    datvec{a} = zeros(1,length(minutestime));
    datvec{a}(seizminutevector{a}) = 1;
    kern = normpdf(-1000:1000,0,250);
    averageseizure{a} = conv(datvec{a},kern);
    averageseizure{a} = averageseizure{a}(1:length(minutestime));
    syms scale
    eqn = mean(averageseizure{a}*scale) == length(seizminutevector{a});
    S = double(solve(eqn,scale));
    averageseizure{a} = averageseizure{a}.*S/(enddayofyear-startdayofyear);
end

for j = 1:length(averageseizure)
    avevec(j,:) = averageseizure{j};
end

finalrate = mean(avevec);
finalratestd = std(avevec).*2;

% average duration
durvector = cell(1,csvlength);
stddur = cell(1,csvlength);
for j = 1:15
    for k = 1:8
    durvector{j} = [durvector{j}; duration{j,k}];
    end
    averagedur{j} = mean(durvector{j});
    stddur{j} = std(durvector{j});
    durationpower(j) = length(durvector{j});
end
averagedurmat = cell2mat(averagedur);
stddurmat = cell2mat(stddur)./sqrt(durationpower);

daystime = startminuteofyear:1440:endminuteofyear;

durationtimes = linspace(0,length(minutestime),numfiles);

figure(2)
boundedline(minutestime,finalrate,finalratestd)
Ylim = get(gca,'Ylim');
set(gca,'Ylim', [0 Ylim(2)])
xticks(linspace(startminuteofyear,endminuteofyear+1440,enddayofyear-startdayofyear))
xticklabels([0:enddayofyear-startdayofyear])
set(gcf,'color','white')
title(['Average Seizures Per Day n = (', num2str(animal),')'])
xlabel('Day')
ylabel('Seizures')
figure(3)
bar(timelabel,averagedurmat)
hold on
er = errorbar(timelabel,averagedurmat,averagedurmat-stddurmat,averagedurmat+stddurmat); 
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
xlabel('Time (Days)')
ylabel('Average Seizure Duration')
set(gcf,'color','white')