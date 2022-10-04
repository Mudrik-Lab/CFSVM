classdef BCFS < CFS
    %BCFS Breaking continuous flash suppression.
    % Child (inherited) class of the CFS parent class.
    %
    % BCFS Methods:
    %   run_the_experiment - main function for the experiment loop.
    % See also CFS

    methods

        

        function run_the_experiment(obj)
            %run_the_experiment Runs the Visual Priming experiment.
            % Shows fixation cross, flashes the masks, shows the target 
            % image with the masks, records target's breakthrough time, runs PAS.
            for block = 1:obj.number_of_blocks
                obj.results.block = block;
                for trial=1:height(obj.trial_matrices{block})
                    obj.results.trial_start_time = GetSecs();
                    obj.results.trial = trial;
                    obj.load_parameters();
                    obj.shuffle_masks(10*block+trial);
                    if trial ~= 1 || block ~= 1
                        obj.rest_screen();
                    end
                    obj.fixation_cross();
                    KbQueueStart();
                    obj.flash();
                    KbQueueStop();
                    obj.perceptual_awareness_scale();
                    obj.results.trial_end_time = GetSecs();
                    obj.results.trial_duration = obj.results.trial_end_time-obj.results.trial_start_time;
                    obj.get_breaking_time();
                    obj.append_trial_results();
                    obj.save_response(); 

                end
            end
        end
    end

    methods (Access = protected)
        function load_parameters(obj)
            obj.load_trial_matrix_row();
            obj.load_flashing_parameters();
            obj.load_fixation_parameters();
            obj.load_rect_parameters();
            obj.results.stimulus_position = obj.stimulus_position;
            obj.results.stimulus_index = obj.stimulus_index;
            obj.stimulus = obj.target_textures{obj.stimulus_index};
        end
        
        function m_alternative_forced_choice(obj) %#ok<MANU> 
            %m_alternative_forced_choice Does nothing
            % Intentionally does nothing as mAFC in bCFS makes no sense.
        end
        function m_alternative_forced_choice_text(obj) %#ok<MANU> 
            %m_alternative_forced_choice_text Does nothing
            % Intentionally does nothing as mAFC in bCFS makes no sense.
        end
    end
end

