classdef (Abstract) Evidence < CFS.Element.TemporalElement
    %Evidence Summary of this class goes here
    %   Detailed explanation goes here

    properties

        keys

        title

        title_size

        options

    end
    
    properties (SetAccess = protected)

        n_options

        response_choice
        
        response_time

        response_kbname
        
    end

    methods (Access = protected)
        record_response(obj)
    end
    
end

