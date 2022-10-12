classdef TrialsData < handle
    %TRIALSDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dirpath
        blocks
        n_blocks
        block_index
        trial_index
        start_time
        end_time
    end

    properties (Constant)
        RESULTS = {'block_index', 'trial_index', 'start_time', 'end_time'}
        VARS_MASKS = ["temporal_frequency", "duration"];
        VARS_STIMULUS = ["appearance_delay", "fade_in_duration", ...
            "show_duration", "fade_out_duration"];
    end

    methods
        function obj = TrialsData(dirpath)
            %TRIALsData Construct an instance of this class
            %   Detailed explanation goes here
            obj.dirpath = dirpath;
        end
        
        import(obj, experiment)
        load_trial_parameters(obj, experiment)
    end
    methods (Static)
        [x, seed] = randomise(number_of_elements, repeats);
    end
end

