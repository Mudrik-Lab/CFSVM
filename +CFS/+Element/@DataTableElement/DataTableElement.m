classdef (Abstract) DataTableElement < handle
    %DATAELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        dirpath
        filename
        table
        file_extension = '.csv'
    end
    
    methods
        read(obj)
        write(obj)
    end
end

