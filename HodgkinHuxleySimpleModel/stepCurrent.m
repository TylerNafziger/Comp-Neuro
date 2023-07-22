function I = stepCurrent(t,t_end,I_step)
I = zeros(size(t));
for k=1:length(t)
    if ~exist("t_end") && ~exist("I_step")
        if t(k) > 0
            I(k) = 1;
        elseif t(k) == 0
            I(k) = 0.5;
        else
            I(k) = 0;
        end
    elseif exist("t_end") && ~exist("I_step")
        if t(k)<0 || t(k)>t_end
            I(k) = 0;
        elseif t_end>t(k) && t(k)>0
            I(k) = 1;
        elseif t(k) == 0 || t(k) == t_end
            I(k) = 0.5;
        end
    elseif exist("t_end") && exist("I_step")
        if t(k)<0 || t(k)>t_end
            I(k) = 0;
        elseif t_end>t(k) && t(k)>0
            I(k) = I_step;
        elseif t(k) == 0 || t(k) == t_end
            I(k) = I_step/2;
        end
    elseif ~exist("t_end") && exist("I_step")
        if t(k)<0
            I(k) = 0;
        elseif t(k)>0
            I(k) = I_step;
        elseif t(k) == 0
            I(k) = I_step/2;
        end
    end
end
end