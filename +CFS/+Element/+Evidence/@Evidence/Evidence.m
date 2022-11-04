classdef (Abstract) Evidence < CFS.Element.TemporalElement
% EVIDENCE An abstract class for all the evidence recording classes.

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

