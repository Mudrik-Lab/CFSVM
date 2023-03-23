classdef (Abstract) Response < handle
% A base class for describing subject response.
%
% Base for :class:`~+CFSVM.+Element.+Evidence.@ScaleEvidence`.
%

    properties
        
        % Cell array of chars with PTB keys.
        % Read more `here <http://psychtoolbox.org/docs/KbName>`_.
        keys cell {mustBeText}

        % Int - index of response choice in keys.
        response_choice {mustBeInteger}

        % Float
        response_time {mustBeNonnegative}

        % PTB char array representing pressed key.
        response_kbname {mustBeText} = ''

    end

    
end

