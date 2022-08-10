classdef BCFS < CFS
    %BCFS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = BCFS()
            obj.create_KbQueue()
        end

        function two_alternatives_forced_choice(obj) %#ok<MANU> 
            %METHOD1 Do nothing
            % Intentionally does nothing as 2AFC in BCFS makes no sense.
        end

        function time_elapsed = run_the_experiment(obj)
            obj.current_trial = obj.current_trial + 1;
            obj.choose_stimulus()
            obj.fixation_cross();
            obj.tstart = obj.flash_masks_only();
            KbQueueStart();
            obj.stimulus_fade_in();
            obj.flash_masks_with_stimulus();
            KbQueueStop();
            time_elapsed = obj.vbl-obj.tstart;
            obj.perceptual_awareness_scale();
        end
    end

    methods (Access = protected)
        function initiate_response_struct(obj)
            obj.response_records = struct('response', {}, 'method', {}, 'elapsed_time', {}, 'trial_number', {}, 'breaking_time', {});
        end

        function append_trial_response(obj, response, method, secs, tflip)

            [pressed, firstPress, ~, ~, ~] = KbQueueCheck();
            breaking_time = (firstPress(1,KbName('Space'))-obj.tstart)*pressed;

            obj.response_records(end+1)=struct( ...
                'response', {response}, ...
                'method', method, ...
                'elapsed_time', {secs-tflip}, ...
                'trial_number', {obj.current_trial}, ...
                'breaking_time', {breaking_time});
        end
    end

    methods (Static)
        function create_KbQueue()
            keys=[KbName('Space')]; %all keys on right hand plus trigger, can be found by running kbdemo
            keylist=zeros(1,256); %create a list of 256 zeros
            keylist(keys)=1; %set keys you interested in to 1
            KbQueueCreate(-1,keylist);
        end
    end
end

