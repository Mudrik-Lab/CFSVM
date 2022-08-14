classdef VPCFS < CFS
    %VPCFS Visual priming continuous flash suppression
    %   Detailed explanation goes here
    %
    % VPCFS Properties:
    %   prime_images_path - directory with prime images.
    
    methods
        function time_elapsed = run_the_experiment(obj)
            obj.current_trial = obj.current_trial + 1;
            obj.shuffle_masks();
            obj.choose_stimulus();
            obj.fixation_cross();
            obj.tstart = obj.flash_masks_only();
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
            obj.response_records = struct('response', {}, 'method', {}, 'elapsed_time', {}, 'trial_number', {});
        end
        
        function append_trial_response(obj, response, method, secs, tflip)
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
