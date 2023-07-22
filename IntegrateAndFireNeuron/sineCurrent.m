function [I, varargout] = sineCurrent(t, varargin) 
     %    I = sineCurrent(T,F,Imax) 
     %        SINECURRENT returns Imax * sine(2*pi*F*T).  T may be a scalar or a time vector. 
     %            F and Imax are optional. F defaults to 0.5. Imax defaults to 2. 
     if ~exist('t') error('sineCurrent requires at least one input parameter, t'); end 
     if nargin>1 f = varargin{1}; 
     else f = 0.5; 
     end 
     if nargin>2 Imax = varargin{2}; 
     else Imax = 2; 
     end 
     I = Imax * sin(2*pi*f*t); 
     varargout{1} = f;  % optional output of frequency 
     varargout{2} = Imax; 
end