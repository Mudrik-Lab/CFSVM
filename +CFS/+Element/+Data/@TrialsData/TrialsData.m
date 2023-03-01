classdef TrialsData < handle
% Storing and manipulating trial parameters.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'block_index', 'trial_index', 'start_time', 'end_time'}

    end

    properties

        filepath  % Char array - path to the .mat file
        matrix  % Nested cell array for trial matrix.
        n_blocks  % Int - number of blocks in trial matrix.
        block_index  % Int - current block.
        trial_index  % Int - current trial.
        start_time  % Float - trial onset.
        end_time  % Float - trial offset

    end



    methods

        function obj = TrialsData(parameters)

            arguments
                parameters.filepath
            end
            
            obj.filepath = parameters.filepath;

        end
        
        import(obj)
        load_trial_parameters(obj, experiment)
        update(obj, experiment)

    end

end

