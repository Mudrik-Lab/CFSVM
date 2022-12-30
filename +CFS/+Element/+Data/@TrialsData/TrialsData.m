classdef TrialsData < CFS.Element.DataTableElement
% TRIALSDATA Class for manipulating trial matrices.
%
% Imports, loads, modifies trial matrices
    
    properties
        
        matrix
        n_blocks
        block_index
        trial_index
        start_time
        end_time

    end

    properties (Constant)

        RESULTS = {'block_index', 'trial_index', 'start_time', 'end_time'}
        VARS_MASKS = ["temporal_frequency", "duration"]
        VARS_STIMULUS = ["appearance_delay", "fade_in_duration", ...
            "show_duration", "fade_out_duration"]

    end

    methods

        function obj = TrialsData(parameters)
            % TRIALSDATA Construct an instance of this class

            arguments
                parameters.dirpath
            end
            
            obj.dirpath = parameters.dirpath;
        end
        
        import(obj)
        load_trial_parameters(obj, experiment)

    end
    
    methods (Static)

        x = randomise(number_of_elements, repeats);

    end

end

