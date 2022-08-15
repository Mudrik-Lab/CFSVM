classdef VPCFS < CFS
    %VPCFS Visual priming continuous flash suppression.
    % Child (inherited) class of the CFS parent class.
    %
    % VPCFS Methods:
    %   run_the_experiment - main function for the experiment loop.
    %   show_targets - shows targets after the suppressing pattern phase.
    % See also CFS

    
    methods
        function time_elapsed = run_the_experiment(obj)
            %run_the_experiment Runs the Visual Priming experiment.
            % Shows fixation cross, flashes the masks, fades in the prime
            % image, shows the target images, runs PAS and mAFC.
            obj.current_trial = obj.current_trial + 1;
            obj.shuffle_masks();
            obj.choose_stimulus();
            obj.fixation_cross();
            obj.flash_masks_only();
            obj.stimulus_fade_in();
            obj.flash_masks_with_stimulus();
            time_elapsed = obj.vbl-obj.tstart;
            obj.show_targets();
            obj.perceptual_awareness_scale();
            obj.m_alternative_forced_choice();
        end

        show_targets(obj);
    end

    methods (Access=protected)
        function initiate_response_struct(obj)
            %initiate_response_struct Initiates structure for subject responses.
            obj.response_records = struct('response', {}, 'method', {}, 'elapsed_time', {}, 'trial_number', {});
        end
        
        function append_trial_response(obj, response, method, secs, tflip)
            %append_trial_response Appends recorded response to the main structure.
            obj.response_records(end+1)=struct( ...
                'response', {response}, ...
                'method', method, ...
                'elapsed_time', {secs-tflip}, ...
                'trial_number', {obj.current_trial});
        end

        function choose_stimulus(obj)
            %choose_stimulus Chooses random image from the stimuli.
            obj.stimulus = obj.prime_textures{randi(length(obj.prime_textures),1)};
        end
    end

end
