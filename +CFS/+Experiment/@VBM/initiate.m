function initiate(obj)
% Makes all the preparations for the CFS experiment to run.
%

    import CFS.Element.Screen.* ...
        CFS.Element.Data.* ...
        CFS.Element.Evidence.* ...
        CFS.Element.Stimulus.*

    % Create folder for the raw trial results
    if ~exist("!Raw", 'dir')
        mkdir("!Raw")
    end
    
    % Create folder for the current subject's raw trial results
    if ~exist("!Raw/"+obj.subject_info.code, 'dir')
        mkdir("!Raw/"+obj.subject_info.code)
    end

    obj.trials.import()
    
    % Initialize fixation property
    obj.fixation = Fixation();

    % Write to disk provided subject data.
    obj.subject_info.write()
    
    % Switch to the PTB's internal keys naming scheme.
    KbName('UnifyKeyNames');
    
    % Convert hex to MATLAB rgb color code.
    obj.screen.background_color = hex2rgb(obj.screen.background_color);

    obj.initiate_window()

    obj.screen.adjust(CheckFrame())

    obj.show_preparing_screen()

    % Warm WaitSecs() function.
    % WaitSecs(0.00001);
    
    % Import images for every SuppressedStimulus property.
    prop_list = obj.trials.matrix{1}{1}.get_dyn_props;
    for prop_idx = 1:length(prop_list)
        c = class(obj.trials.matrix{1}{1}.(prop_list{prop_idx}));
        if c == "CFS.Element.Stimulus.SuppressedStimulus"
            dirpath = obj.trials.matrix{1}{1}.(prop_list{prop_idx}).dirpath;
            obj.addprop(prop_list{prop_idx})
            obj.(prop_list{prop_idx}) = SuppressedStimulus(dirpath);
            obj.(prop_list{prop_idx}).import_images(obj.screen.window)
        end
    end
    
    
    % Initialize masks property with parameters from the first trial.
    obj.mask = obj.trials.matrix{1}{1}.mask;

    % Import images and create PTB textures of the masks.
    obj.mask.import_images(obj.screen.window)

    % Update every trial with initialized parameters.
    obj.trials.update(obj)

    obj.load_parameters();
    
    obj.show_introduction_screen()

end

function rgb = hex2rgb(hex)
% Transforms hexadecimal color code to MATLAB RGB color code.
    rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
end