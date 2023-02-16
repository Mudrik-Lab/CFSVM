classdef (Abstract) ScaleEvidence < CFS.Element.Evidence.Response & CFS.Element.TemporalElement
    % ScaleEvidence An abstract class for description of scale based
    % evidence and for recording subjects response.
    
    properties

        title
        title_size
        options
        n_options

    end
    
    methods (Access = protected)

        record_response(obj)

    end
end

