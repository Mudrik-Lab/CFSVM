classdef (Abstract) Evidence < ExperimentElement
    %Evidence Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        keys
        title
        title_size
        options
        n_options
        response_choice
        response_time
        response_kbname
    end

    methods
        record_response(obj);
    end
    
end

