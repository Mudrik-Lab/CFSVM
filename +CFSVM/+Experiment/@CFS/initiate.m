function initiate(obj)
    % Makes all the preparations for the CFS experiment to run.
    %

    import CFSVM.Element.Screen.*
    import CFSVM.Element.Data.*
    import CFSVM.Element.Evidence.*
    import CFSVM.Element.Stimulus.*
    import CFSVM.Utils.hex2rgb

    % Create folder for the raw trial results
    if ~exist(obj.save_to_dir, 'dir')
        mkdir(obj.save_to_dir);
    end

    % Create folder for the current subject's raw trial results
    if ~exist(strcat(obj.save_to_dir, "/RawTrials/", obj.subject_info.code), 'dir')
        mkdir(strcat(obj.save_to_dir, "/RawTrials/", obj.subject_info.code));
    end

    obj.trials.import();

    % Initialize fixation property
    obj.fixation = obj.trials.matrix{1}{1}.fixation;

    % Initialize frame property with parameters from the first trial.
    obj.frame = obj.trials.matrix{1}{1}.frame;

    % Write to disk provided subject data.
    obj.subject_info.write();

    % Switch to the PTB's internal keys naming scheme.
    KbName('UnifyKeyNames');

    % Convert hex to MATLAB rgb color code.
    obj.screen.background_color = hex2rgb(obj.screen.background_color);

    obj.initiate_window();

    obj.screen.adjust(obj.frame);

    obj.show_preparing_screen();

    % Warm WaitSecs() function.
    WaitSecs(0.00001);

    % Import fixation target image.
    obj.fixation.import_images(obj.screen.window);

    % Import images for every SuppressedStimulus property.
    prop_list = obj.trials.matrix{1}{1}.get_dyn_props;
    for prop_idx = 1:length(prop_list)
        c = class(obj.trials.matrix{1}{1}.(prop_list{prop_idx}));
        if c == "CFSVM.Element.Stimulus.SuppressedStimulus"
            dirpath = obj.trials.matrix{1}{1}.(prop_list{prop_idx}).dirpath;
            obj.addprop(prop_list{prop_idx});
            obj.(prop_list{prop_idx}) = SuppressedStimulus(dirpath);
            obj.(prop_list{prop_idx}).import_images(obj.screen.window);
        end
    end

    % Relevant only for VPCFS.
    % Initialize and import target property, Initialize mafc and pas.
    if class(obj) == "CFSVM.Experiment.VPCFS"
        obj.target = TargetStimulus(obj.trials.matrix{1}{1}.target.dirpath);
        obj.target.import_images(obj.screen.window);

        obj.mafc = obj.trials.matrix{1}{1}.mafc;
        obj.pas = PAS();
    end

    % Relevant only for BCFS.
    % Initialize breaking response property and create PTB KbQueue.
    if class(obj) == "CFSVM.Experiment.BCFS"
        obj.breakthrough = BreakResponse(keys = obj.trials.matrix{1}{1}.breakthrough.keys);
        obj.breakthrough.create_kbqueue();
    end

    % Initialize masks property with parameters from the first trial.
    obj.masks = obj.trials.matrix{1}{1}.masks;
    obj.masks.get_max(obj.trials.matrix);

    if ~isempty(obj.masks.crafter_masks)
        obj.masks.import_from_crafter(obj.screen.window);
    else
        % Import images and create PTB textures of the masks.
        obj.masks.import_images(obj.screen.window, images_number = obj.masks.n_max);
    end

    % Update every trial with initialized parameters.
    obj.trials.update(obj);

    obj.instructions.import_images(obj.screen.window, obj.trials.n_blocks);

    obj.load_parameters();

end
