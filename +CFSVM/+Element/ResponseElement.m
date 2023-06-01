classdef (Abstract) ResponseElement < matlab.mixin.Copyable
% A base class describing subject response.
%
% Base for :class:`~CFSVM.Element.Evidence.ScaleEvidence`
% and :class:`~CFSVM.Element.Evidence.BreakResponse`.
%

    properties
        
        % Cell array of chars with PTB keys.
        % Use::
        %
        %   KbName('UnifyKeyNames')
        %   KbName('KeyNames') 
        %
        % to get correct keys. 
        % Read more on `PTB <http://psychtoolbox.org/docs/KbName>`_.
        keys cell {mustBeText}

        % ``Int`` index of response choice in keys.
        response_choice {mustBeInteger}

        % ``Double`` time to response
        response_time {mustBeNonnegative}

        % ``PTB char array`` representing pressed key.
        response_kbname {mustBeText} = ''

    end

    
end

