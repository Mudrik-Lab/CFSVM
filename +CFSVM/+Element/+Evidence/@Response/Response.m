classdef (Abstract) Response < handle
% A base class for describing subject response.
%
% Base for :class:`~+CFSVM.+Element.+Evidence.@ScaleEvidence`.
%

    properties
        
        % Cell array of chars with PTB keys. 
        % Read more `here <http://psychtoolbox.org/docs/KbName>`_.
        keys  
        response_choice  % Int - index of response choice in keys.
        response_time  % Float
        response_kbname  % PTB char array representing pressed key.

    end

    
end

