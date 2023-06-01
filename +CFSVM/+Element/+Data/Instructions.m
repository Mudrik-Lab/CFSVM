classdef Instructions < matlab.mixin.Copyable
% Presenting the instruction screens.
%

    properties (SetAccess=private)

        % Path to the folder containing specific subfolders 
        % with images: introduction, block_introduction_1, ..., 
        % block_introduction_n, rest, farewell.
        dirpath
        % Key to press to move to the previous image of the instruction. 
        backward_key  
        % Key to press to move to the next image of the instruction.
        forward_key
        % Key to press to proceed from instruction to the next stage.
        proceed_key
        % Struct containing PTB textures for different instruction types.
        textures

    end
    

    methods


        function obj = Instructions(dirpath, kwargs)
        %
        % Args:
        %   dirpath: Path to the folder containing specific subfolders 
        %       with images: introduction, block_introduction_1, ..., 
        %       block_introduction_n, rest, farewell.
        %   backward_key: Key to press to move to the previous 
        %       image of the instruction. Defaults to 'LeftArrow'.
        %   forward_key: Key to press to move to the next image 
        %       of the instruction. Defaults to 'RightArrow'.
        %   proceed_key: Key to press to proceed from instruction 
        %       to the next stage. Defaults to 'Return'.
        %
            arguments
                dirpath {mustBeFolder}
                kwargs.backward_key {mustBePTBKey} = 'LeftArrow'
                kwargs.forward_key {mustBePTBKey} = 'RightArrow'
                kwargs.proceed_key {mustBePTBKey} = 'Return'
            end
            obj.dirpath = CFSVM.Utils.rel2abs(dirpath);
            obj.backward_key = convertStringsToChars(kwargs.backward_key);
            obj.forward_key = convertStringsToChars(kwargs.forward_key);
            if isempty(kwargs.proceed_key)
                obj.proceed_key = obj.forward_key;
            else
                obj.proceed_key = convertStringsToChars(kwargs.proceed_key);
            end
        end

        function import_images(obj, window, n_blocks)
        % Imports instruction images from the dirpath subfolders.
        % 
        % Args:
        %   window: PTB window pointer.
        %   n_blocks: Number of subfolders with block introductions.
        %
            obj.validate_instructions(n_blocks)
            instructs = [{'introduction', 'rest', 'farewell'}, compose('block_introduction_%d', 1:n_blocks)];

            for n = 1:length(instructs)
                images = CFSVM.Utils.natsortfiles(dir(fullfile(obj.dirpath, instructs{n})), [], 'rmdot');
                for img_index = 1:length(images)
                    try
                        fullp = fullfile(images(img_index).folder, images(img_index).name);
                        [~, ~, ext] = fileparts(fullp);
                        if ext == ".png"
                            [image, ~, alpha] = imread(fullp);
                            if ~isempty(alpha)
                                image(:, :, 4) = alpha;
                            end
                        else
                            image = imread(fullp);
                        end
                        obj.textures.(instructs{n}).PTB_indices{img_index} = Screen('MakeTexture', window, image);
                        obj.textures.(instructs{n}).images_names{img_index} = images(img_index).name;
                        obj.textures.(instructs{n}).aspect_ratios{img_index} = width(image)/height(image);
                    catch
                    end
                end
                % Get number of textures created. 
                obj.textures.(instructs{n}).len = length(obj.textures.(instructs{n}).PTB_indices);
            end

        end

        function show(obj, experiment, type)
        % Shows the instruction by type.
        % If type=='rest', saves the trial data.
        %
        % Args:
        %   experiment: An object derived from the :class:`~CFSVM.Experiment.Experiment` subclass.
        %   type: Type of the instruction. One of introduction, block_introduction_1,
        %       ..., block_introduction_n, rest, farewell.
        %
            n_screens = length(obj.textures.(type).PTB_indices);
            curr_screen = 1;
            while 1

                if curr_screen < 1
                    curr_screen = 1;
                end

                for field = 1:length(experiment.screen.fields)
                    rect = experiment.screen.fields{field}.rect;
                    aspect_ratios = experiment.screen.fields{field}.x_pixels/experiment.screen.fields{field}.y_pixels;
                    if  aspect_ratios < obj.textures.(type).aspect_ratios{curr_screen}
                        new_y = (rect(3)-rect(1))/obj.textures.(type).aspect_ratios{curr_screen};
                        pixel_shift = round((rect(4)-rect(2)-new_y)/2);
                        rect(2) = rect(2)+pixel_shift;
                        rect(4) = rect(4)-pixel_shift;
                    elseif aspect_ratios > obj.textures.(type).aspect_ratios{curr_screen}
                        new_x = (rect(4)-rect(2))*obj.textures.(type).aspect_ratios{curr_screen};
                        pixel_shift = round((rect(3)-rect(1)-new_x)/2);
                        rect(1) = rect(1)+pixel_shift;
                        rect(3) = rect(3)-pixel_shift;
                    end
                    Screen('DrawTexture', ...
                            experiment.screen.window, ...
                            obj.textures.(type).PTB_indices{curr_screen}, ...
                            [], ...
                            rect)
                end
                
                if isa(experiment, "CFSVM.Experiment.CFS")
                    % Checkerboard frame
                    Screen('FillRect', experiment.screen.window, experiment.frame.colors, experiment.frame.rects);
                end
                Screen('Flip', experiment.screen.window);
                
                % If rest, save the trial
                if strcmp(type, 'rest')
                    save(sprintf( ...
                        "%s/RawTrials/%s/block%d_trial%d.mat", ...
                        experiment.save_to_dir, ...
                        experiment.subject_info.code, ...
                        experiment.trials.block_index, ...
                        experiment.trials.trial_index), 'experiment')
                end

                % Wait until the right key is pressed, then continue.
                key_code = obj.wait_for_keypress();
                key_name = KbName(key_code);
                if any(strcmp(key_name, obj.backward_key)) && curr_screen > 1
                    curr_screen = curr_screen - 1;
                elseif any(strcmp(key_name, obj.forward_key)) && curr_screen < n_screens
                    curr_screen = curr_screen + 1;
                elseif any(strcmp(key_name, obj.proceed_key)) && curr_screen == n_screens
                    break;
                end
            end
        end

        function validate_instructions(obj, n_blocks)

            files = {dir(obj.dirpath).name};
            instructs = {'introduction', 'rest', 'farewell'};
            for n_info = 1:length(instructs)
                if ~ismember(instructs{n_info}, files)
                    error('Instructions should contain %s folder', instructs{n_info})
                end
                if isempty(CFSVM.Utils.natsortfiles(dir(fullfile(obj.dirpath, instructs{n_info})), [], 'rmdot'))
                    error('%s folder is empty', instructs{n_info})
                end
            end
            
            for block = 1:n_blocks
                if ~ismember(sprintf('block_introduction_%d', block), files)
                    error('Instructions should contain block_introduction_%d folder', block)
                end
                if isempty(CFSVM.Utils.natsortfiles(dir(fullfile( ...
                        obj.dirpath, ...
                        sprintf('block_introduction_%d', block))), [], 'rmdot'))
                    error('block_introduction_%d folder is empty', block)
                end
            end
        
        end
        

        function key_code = wait_for_keypress(obj)
        % Waits until the provided key is pressed, then continue.
        %
        % Interrupts the experiment if esc was pressed.
        %
            while 1
        
                [~, key_code, ~] = KbStrokeWait;
        
                if any(key_code(KbName({obj.backward_key, obj.forward_key, obj.proceed_key})))
                    break;
        
                elseif all(key_code(KbName({'ESCAPE'})))
        
                    Screen('CloseAll');
                    ME = MException('Key:Esc_has_been_pressed', ...
                        'Esc has been pressed, the program has been terminated.');
                    throw(ME)
        
                end
            end
        end
    end

end

function mustBePTBKey(key)

    if ~(isstring(key)||ischar(key)||iscellstr(key))
        if key
            error('The %s should be char, string or cell array of chars', inputname(1))
        end
    end
    KbName('UnifyKeyNames');
    keys = KbName('KeyNames');
    keys = keys(~cellfun('isempty', keys));
    if ~any(ismember(key, keys))
        error("The %s is not a valid PTB key. " + ...
            "Use KbName('UnifyKeyNames') and KbName('KeyNames') " + ...
            "to find the valid keyname.", inputname(1))
    end

end

