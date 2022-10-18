classdef BCFS < CFS.Experiment.CFS
    %BCFS Breaking continuous flash suppression.
    % Child (inherited) class of the CFS parent class.
    %
    % BCFS Methods:
    %   run_the_experiment - main function for the experiment loop.
    % See also CFS
    
    properties
        screen CFS.Element.Screen.CustomScreen
        subject_info CFS.Element.Data.SubjectData
        trials CFS.Element.Data.TrialsData
        fixation CFS.Element.Stimulus.Fixation
        frame CFS.Element.Screen.CheckFrame
        stimulus CFS.Element.Stimulus.SuppressedStimulus
        masks CFS.Element.Stimulus.Masks
        pas CFS.Element.Evidence.PAS
        stimulus_break CFS.Element.Evidence.BreakResponse
        results CFS.Element.Data.Results
    end

    methods
        function run_the_experiment(obj)
            %run_the_experiment Runs the Visual Priming experiment.
            % Shows fixation cross, flashes the masks, fades in the prime
            % image, shows the target images, runs PAS and mAFC.
            obj.initiate();
            
            for block = 1:obj.trials.n_blocks
                obj.trials.block_index = block;
                for trial = 1:height(obj.trials.blocks{block})
                    obj.trials.start_time = GetSecs();
                    obj.trials.trial_index = trial;
                    obj.load_parameters();
                    if trial ~= 1 || block ~= 1
                        obj.show_rest_screen();
                    end

                    obj.vbl = obj.fixation.show(obj);
                    
                    KbQueueStart();
                    obj.flash();
                    KbQueueStop();

                    obj.pas.show(obj.screen);
                    obj.trials.end_time = GetSecs();
                    obj.stimulus_break.get();
                    obj.results.import_from(obj);
                    obj.results.add_trial_to_table();
                    obj.results.write()
                end
            end 
        end 
    end

    methods (Access = protected)
        function load_parameters(obj)

            obj.trials.load_trial_parameters(obj);
            
            obj.masks.load_flashing_parameters(obj.screen, obj.stimulus);
            obj.masks.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
            obj.masks.shuffle(10*obj.trials.block_index+obj.trials.trial_index);

            obj.stimulus.load_flashing_parameters(obj.masks);
            obj.stimulus.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)

            obj.fixation.load_args(obj.screen);

            obj.stimulus.textures.index = obj.stimulus.textures.PTB_indices{obj.stimulus.index};

            obj.pas.load_parameters(obj.screen);

        end
        
    end
end

