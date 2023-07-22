    for l = 1:length(day{j})
        if day{j}(l) > start_day{j}
           dat{j}(l,4) = dat{j}(l,4) + 24;
           start_day{j} = day{j}(l);
        end
    end
    
    
        for l = 1:length(dat{j})
        if dat{j}(l) == 1
            month_sec = 0;
        elseif dat{j}(l) == 2
            month_sec = 86400*31;
        elseif dat{j}(l) == 3
            month_sec = 86400*59;
        elseif dat{j}(l) == 4
            month_sec = 86400*90;
        elseif dat{j}(l) == 5
            month_sec = 86400*120;
        elseif dat{j}(l) == 6
            month_sec = 86400*151;
        elseif dat{j}(l) == 7
            month_sec = 86400*181;
        elseif dat{j}(l) == 8
            month_sec = 86400*212;
        elseif dat{j}(l) == 9
            month_sec = 86400*243;
        elseif dat{j}(l) == 10
            month_sec = 86400*273;
        elseif dat{j}(l) == 2
            month_sec = 86400*304;
        elseif dat{j}(l) == 2
            month_sec = 86400*334;
        end
        end
    
    %%
    fl_time_men(j) = menu(sprintf('Select the time length of file %d: ',j),'Full week','48 hours','24 hours','12 hours','60 minutes','40 minutes','30 minutes','10 minutes');
        switch fl_time_men(j)
            case 1
                file_time{j} = 7;
            case 2
                file_time{j} = 2;
            case 3
                file_time{j} = 1;
            case 4
                file_time{j} = 0.5;
            case 5
                file_time{j} = 1/24;
            case 6
                file_time{j} = 40/1440;
            case 7
                file_time{j} = 30/1440;
            case 8
                file_time{j} = 10/1440;
        end
        
        %%
        elseif is_param == 1
    file_time{1} = 1/48;
    if param == 1||2||3||7||8||9||13||14||15||19||20||21||25||26||27||31||32||33
        file_time{2} = 1/144;
    else
        file_time{2} = 1/36;
    end
    file_time{3} = 1/24;
end