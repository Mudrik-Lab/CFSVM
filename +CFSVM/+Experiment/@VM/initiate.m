function initiate(obj)
% Makes all the preparations for the VM experiment to run.
%

    import CFSVM.Element.Screen.* ...
        CFSVM.Element.Data.* ...
        CFSVM.Element.Evidence.* ...
        CFSVM.Element.Stimulus.*
    import CFSVM.Utils.hex2rgb
    
    % Create folder for the raw trial results
    if ~exist(obj.save_to_dir, 'dir')
        mkdir(obj.save_to_dir)
    end
    
    % Create folder for the current subject's raw trial results
    if ~exist(strcat(obj.save_to_dir,"/RawTrials/", obj.subject_info.code), 'dir')
        mkdir(strcat(obj.save_to_dir,"/RawTrials/", obj.subject_info.code))
    end

    obj.trials.import()
    
    % Initialize fixation property
    obj.fixation = obj.trials.matrix{1}{1}.fixation;

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

    % Import fixation target image.
    obj.fixation.import_images(obj.screen.window);
    
    % Import images for every SuppressedStimulus property.
    prop_list = obj.trials.matrix{1}{1}.get_dyn_props;
    for prop_idx = 1:length(prop_list)
        c = class(obj.trials.matrix{1}{1}.(prop_list{prop_idx}));
        if c == "CFSVM.Element.Stimulus.SuppressedStimulus"
            dirpath = obj.trials.matrix{1}{1}.(prop_list{prop_idx}).dirpath;
            obj.addprop(prop_list{prop_idx})
            obj.(prop_list{prop_idx}) = SuppressedStimulus(dirpath);
            obj.(prop_list{prop_idx}).import_images(obj.screen.window)
        end
    end
    
    if class(obj) == "CFSVM.Experiment.VSM"
        % Initialize masks property with parameters from the first trial.
        obj.f_mask = obj.trials.matrix{1}{1}.f_mask;
        obj.b_mask = obj.trials.matrix{1}{1}.b_mask;
        % Import images and create PTB textures of the masks.
        obj.f_mask.import_images(obj.screen.window)
        obj.b_mask.import_images(obj.screen.window)
    else
        % Initialize masks property with parameters from the first trial.
        obj.mask = obj.trials.matrix{1}{1}.mask;
        % Import images and create PTB textures of the masks.
        obj.mask.import_images(obj.screen.window)
        
        if obj.mask.soa < 0
            obj.flash = @obj.f_flash;
        elseif obj.mask.soa > 0
            obj.flash = @obj.b_flash;
        else
            obj.flash = @obj.s_flash;
        end
    end

    % Initialize mafc and pas.
    obj.mafc = obj.trials.matrix{1}{1}.mafc;
    obj.pas = PAS();

    % Update every trial with initialized parameters.
    obj.trials.update(obj)

    obj.load_parameters();
    
    obj.show_introduction_screen()

end
