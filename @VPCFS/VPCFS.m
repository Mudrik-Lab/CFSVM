classdef VPCFS < CFS
    %VPCFS Visual priming continuous flash suppression.
    % Child (inherited) class of the CFS parent class.
    %
    % VPCFS Methods:
    %   run_the_experiment - main function for the experiment loop.
    %   show_targets - shows targets after the suppressing pattern phase.
    % See also CFS
    %     prime_images_path - path to a directory with prime images. VPCFS only.
    %     target_presentation_duration - duration of target after the suppression. VPCFS only.
    
    properties
        % Path to a directory with prime images.
        prime_images_path {mustBeFolder} = './Images/Prime_images';
        
        % For how long to show the target images after the suppression has
        % been stopped.
        target_presentation_duration {mustBeNonnegative} = 0.7; 
    end
    
    properties (Access = {?CFS})
        prime_textures; % Psychtoolbox textures of the prime images.
    end
    
    methods
        function run_the_experiment(obj)
            %run_the_experiment Runs the Visual Priming experiment.
            % Shows fixation cross, flashes the masks, fades in the prime
            % image, shows the target images, runs PAS and mAFC.
            obj.current_trial = obj.current_trial + 1;
            obj.shuffle_masks();
            obj.stimulus = obj.choose_texture(obj.prime_textures);
            obj.fixation_cross();
            obj.flash();
            obj.show_targets();
            obj.perceptual_awareness_scale();
            obj.m_alternative_forced_choice();
        end

        show_targets(obj);
    end

    methods (Access=protected)
        function initiate_response_struct(obj)
            %initiate_response_struct Initiates structure for subject responses.
            obj.response_records = struct( ...
                'response', {}, ...
                'method', {}, ...
                'response_time', {}, ...
                'trial_number', {}, ...
                'trial_time', {});
        end
        
        function append_trial_response(obj, response, method, secs, tflip)
            %append_trial_response Appends recorded response to the main structure.
            obj.response_records(end+1)=struct( ...
                'response', {response}, ...
                'method', method, ...
                'response_time', {secs-tflip}, ...
                'trial_number', {obj.current_trial}, ...
                'trial_time', {obj.vbl-obj.trial_start});
        end
    end
end
