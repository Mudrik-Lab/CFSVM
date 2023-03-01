classdef (Abstract) TemporalElement < handle
% A base class for describing elements with temporal properties.
%

    properties

        onset  % Float - time of onset
        offset  % Float - time of offset
        duration  % Float
        
    end

end

