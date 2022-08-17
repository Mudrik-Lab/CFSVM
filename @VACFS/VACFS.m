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
        
        %For available key names please check KbName('KeyNames') or KbDemo.
        % You can use either numerical code or characters.
        breakthrough_key = 'backspace';
    end

    properties (Access = {?CFS})
        adapter_textures; % Psychtoolbox textures of the adapter images.
    end
    
    methods
        function obj = VACFS()
            obj.create_KbQueue();
        end

        function run_the_experiment(obj)
            %run_the_experiment Runs the Visual Adaptation experiment.
            % Shows fixation cross, flashes the masks, shows the target 
            % image with the masks, records target's breakthrough time, runs PAS.
            obj.current_trial = obj.current_trial + 1;
            obj.shuffle_masks();
            obj.stimulus = obj.choose_texture(obj.adapter_textures);
            obj.fixation_cross();
            KbQueueStart();
            obj.flash();
            KbQueueStop();
            obj.perceptual_awareness_scale();
            obj.m_alternative_forced_choice();
        end
        
    end

    methods (Access = protected)
        function initiate_response_struct(obj)
            %initiate_response_struct Initiates structure for subject responses.
            obj.response_records = struct( ...
                'response', {}, ...
                'method', {}, ...
                'breaking_time', {}, ...
                'response_time', {}, ...
                'trial_number', {}, ...
                'trial_time' , {});
        end
         
        function append_trial_response(obj, response, method, secs, tflip)
            %append_trial_response Appends recorded response to the main structure.

            % Get breakthrough time from PTB KbQueue.
            [pressed, firstPress, ~, ~, ~] = KbQueueCheck();
            breakthrough_time = (firstPress(1,KbName(obj.breakthrough_key))-obj.trial_start)*pressed;
            
            %Append the data
            obj.response_records(end+1)=struct( ...
                'response', {response}, ...
                'method', method, ...
                'breaking_time', {breakthrough_time}, ...
                'response_time', {secs-tflip}, ...
                'trial_number', {obj.current_trial}, ...
                'trial_time', {obj.vbl-obj.trial_start});
        end
        
        function create_KbQueue(obj)
            %create_KbQueue Creates PTB KbQueue, see PTB documentation.
            keys=[KbName(obj.breakthrough_key)]; % All keys on right hand plus trigger, can be found by running KbDemo
            keylist=zeros(1,256); % Create a list of 256 zeros
            keylist(keys)=1; % Set keys you interested in to 1
            KbQueueCreate(-1,keylist); % Create the queue with the provided keys
        end
    end
end

