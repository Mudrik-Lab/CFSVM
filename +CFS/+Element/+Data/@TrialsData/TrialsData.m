classdef TrialsData < handle
% TRIALSDATA Class for storing and manipulating trial parameters.
    
    properties

        filepath
        matrix
        n_blocks
        block_index
        trial_index
        start_time
        end_time

    end

    properties (Constant)

        RESULTS = {'block_index', 'trial_index', 'start_time', 'end_time'}

    end

    methods

        function obj = TrialsData(parameters)
            % TRIALSDATA Construct an instance of this class

            arguments
                parameters.filepath
            end
            
            obj.filepath = parameters.filepath;

        end
        
        import(obj)
        load_trial_parameters(obj, experiment)

    end

end

