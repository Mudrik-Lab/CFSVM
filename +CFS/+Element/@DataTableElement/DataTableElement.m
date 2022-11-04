classdef (Abstract) DataTableElement < handle
% DATATABLEELEMENT An abstract superclass for data classes.

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

