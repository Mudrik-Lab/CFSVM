classdef (Abstract) ScaleEvidence < CFS.Element.Evidence.Response & CFS.Element.TemporalElement
% A base class for description of scale-based evidence classes like 
% :class:`~+CFS.+Element.+Evidence.@PAS` and
% :class:`~+CFS.+Element.+Evidence.@ImgMAFC`.
%
% Derived from :class:`~+CFS.+Element.+Evidence.@Response` 
% and :class:`~+CFS.+Element.@TemporalElement` classes.
%

    properties

        title  % Char array representing title or question shown on screen.
        title_size  % Int
        options  % Cell array of chars 
        n_options  % Int - length(obj.keys)

    end
    
    methods (Access = protected)

        record_response(obj)

    end
end

