classdef TrialsData < matlab.mixin.Copyable
% Storing and manipulating trial parameters.
%

    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'block_index', 'trial_index', 'start_time', 'end_time'}

    end

    properties
        % Char array - path to the .mat file
        filepath
        
        % Nested cell array for trial matrix.
        matrix cell 
        
        % Int - number of blocks in trial matrix.
        n_blocks {mustBeInteger} 
        
        % Int - current block.
        block_index {mustBeInteger} 
        
        % Int - current trial.
        trial_index {mustBeInteger} 
        
        % Float - trial onset.
        start_time {mustBeNonnegative} 
        
        % Float - trial offset
        end_time {mustBeNonnegative} 

    end



    methods

        function obj = TrialsData(parameters)
        %
        % Args:
        %   filepath: :attr:`~.+CFSVM.+Element.+Data.@TrialsData.TrialsData.filepath`
        %
        
            arguments
                parameters.filepath {mustBeFile}
            end
            
            obj.filepath = parameters.filepath;

        end
        
        import(obj)
        load_trial_parameters(obj, experiment)
        update(obj, experiment)

    end

end

