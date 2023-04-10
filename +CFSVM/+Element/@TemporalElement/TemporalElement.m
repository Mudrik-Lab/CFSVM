classdef (Abstract) TemporalElement < matlab.mixin.Copyable
% A base class describing elements with temporal properties.
%

    properties

        onset (1,1) {mustBeNonnegative} % Float - onset time
        offset (1,1) {mustBeNonnegative} % Float - offset time
        duration (1,1) {mustBeNonnegative} % Float - duration time
        
    end

end

