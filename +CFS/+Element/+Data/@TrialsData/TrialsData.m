classdef TrialsData < handle
% TRIALSDATA Class for manipulating trial matrices.
%
% Imports, loads, modifies trial matrices
    
    properties

        dirpath
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

