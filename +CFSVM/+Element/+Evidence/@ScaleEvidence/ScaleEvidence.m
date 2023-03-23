classdef (Abstract) ScaleEvidence < CFSVM.Element.Evidence.Response & CFSVM.Element.TemporalElement
% A base class for description of scale-based evidence classes like 
% :class:`~+CFSVM.+Element.+Evidence.@PAS` and
% :class:`~+CFSVM.+Element.+Evidence.@ImgMAFC`.
%
% Derived from :class:`~+CFSVM.+Element.+Evidence.@Response` 
% and :class:`~+CFSVM.+Element.@TemporalElement` classes.
%

    properties

        % Char array representing title or question shown on screen.
        title {mustBeTextScalar} = ''

        % Int
        title_size {mustBeNonnegative, mustBeInteger}  

        % Cell array 
        options cell 

        % Int - length(obj.keys)
        n_options {mustBeInteger} 

    end
    
    methods (Access = protected)

        record_response(obj)

    end
end

