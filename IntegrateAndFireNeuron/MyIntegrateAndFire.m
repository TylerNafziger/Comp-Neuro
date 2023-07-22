function varargout = MyIntegrateAndFire(inputfunc, inputparam, t_span, Vm0)
% Given a current supply function and function inputs, generate a signal,
% integrate, and determine if neuron will fire over the given time span and
% provided resting membrane potential
% Parameters

    V_peak = 20; % mV
    V_reset = -70; % mV
    V_init = Vm0; % mV
    t_refrac = 10; % ms
    t_beg = t_span(1);
    t_end = t_span(2);
   

    % ODE control
    options = odeset('Events',@andFire); % set event to terminate if V cross thresh
    options = odeset(options,'MaxStep',0.1);

    % Seed loop values
    V = V_init; % set initial voltage according to input
    t = t_beg; % set initial time according to t_span
    ts = [t_beg t_end];

    while(t(end)<t_end) % run ode function
        [t_new,V_new,tsp] = ode15s(@integrate,ts,V(end), options);
        t = [t; t_new];
        V = [V; V_new];

        if t(end) < t_end % check for premature terminate flagging threshold cross
            t = [t; tsp+[eps(tsp);eps(tsp)*2;t_refrac]];
            V = [V; V_peak; V_reset; V_reset];
            ts = [t(end) t_end];
        end
    end

    plot(t,V,'LineWidth',2);
    axis([t_beg t_end V_reset-5 V_peak+5]);
    grid on;

    title('Integrate & Fire');
    ylabel('Potential, mV');
    xlabel('Time, ms');

    varargout{1} = t;
    varargout{2} = V;

    function dVdt = integrate(t,V) 
    % embed integration function so main function inputs can be translated
    V_rest = -60;
    tau = 15;
    if ~exist('inputfunc')
        IR = 0;
    else
        if t<0
            s = 0;
            IR = 0;
        else
            embedparam{1} = t; % set first input to current function to time being evaluated
            embedparam{2} = inputparam{2};
            embedparam{3} = inputparam{3};
            s = inputfunc(embedparam{:}); % driving force
            IR = s*100e9; % current * resistance * 1000 (V to mV)
        end
    end

    dVdt = (V_rest - V + IR)/tau;
end
end




function [fromVth, terminate, direction] = andFire(t,V)
% terminate function for crossing threshold
    V_thresh = -50; % mv, threshold potential
    fromVth = V-V_thresh; % mv, distance from thresh
    
    terminate = 1; % stop the integration
    direction = 1; %positive direction
end

