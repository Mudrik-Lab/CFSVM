classdef VACFS < CFS
    %VACFS Visual adaptation continuous flash suppression.
    % Child (inherited) class of the CFS parent class.
    %
    % VACFS Methods:
    %   run_the_experiment - main function for the experiment loop.
    % See also CFS
    
    properties
        % Path to a directory with adapter images.
        adapter_images_path {mustBeFolder} = './Images/Adapter_images';
    end

    properties (Access = {?CFS})
        adapter_textures; % Psychtoolbox textures of the adapter images.
    end
    
    methods
        function run_the_experiment(obj)
            %run_the_experiment Runs the Visual Adaptation experiment.
            % Shows fixation cross, flashes the masks, shows the target 
            % image with the masks, records target's breakthrough time, runs PAS.
            for block = 1:obj.number_of_blocks
                obj.results.block = block;
                for trial=1:height(obj.trial_matrices{block})
                    obj.results.trial_start_time = GetSecs();
                    obj.results.trial = trial;
                    obj.load_parameters(block);
                    obj.shuffle_masks();
                    obj.stimulus = obj.adapter_textures{obj.stimulus_index};
                    obj.rest_screen();
                    obj.fixation_cross();
                    KbQueueStart();
                    obj.flash();
                    KbQueueStop();
                    obj.perceptual_awareness_scale();
                    obj.m_alternative_forced_choice();
                    obj.results.trial_end_time = GetSecs();
                    obj.results.trial_duration = obj.results.trial_end_time-obj.results.trial_start_time;
                    obj.get_breaking_time();
                    obj.append_trial_results();
                    obj.save_response();
                end
            end
        end
    end
end

