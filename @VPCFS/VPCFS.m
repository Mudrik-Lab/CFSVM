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
        
        % Position of the image in the provided directory
        target_image_index {mustBeInteger, mustBePositive} = 1;
        
        % For how long to show the target images after the suppression has
        % been stopped.
        target_presentation_duration {mustBeNonnegative} = 0.7;
    %end
    
    %properties (Access = {?CFS})
        prime_textures; % Psychtoolbox textures of the prime images.
    end
    
    methods

        function run_the_experiment(obj)
            %run_the_experiment Runs the Visual Priming experiment.
            % Shows fixation cross, flashes the masks, fades in the prime
            % image, shows the target images, runs PAS and mAFC.

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
                    obj.flash();
                    obj.show_targets();
                    obj.perceptual_awareness_scale();
                    obj.mAFC();
                    obj.results.trial_end_time = GetSecs();
                    obj.results.trial_duration = obj.results.trial_end_time-obj.results.trial_start_time;
                    obj.append_trial_results();
                    obj.save_response();
                end
            end 
        end 
    end

    methods (Access=protected)
        function load_parameters(obj)
            obj.load_trial_matrix_row();
            obj.load_flashing_parameters();
            obj.load_fixation_parameters();
            obj.load_rect_parameters();
            obj.results.stimulus_index = obj.stimulus_index;
            obj.stimulus = obj.prime_textures{obj.stimulus_index};
            if ~obj.is_mAFC_text_version
                obj.load_mAFC_parameters();
            end  
        end

        show_targets(obj);
        function get_breaking_time(obj) %#ok<MANU> 
            %get_breaking_time Does nothing
            % Intentionally does nothing as there is no breaking time in VPCFS.
        end
    end
end
