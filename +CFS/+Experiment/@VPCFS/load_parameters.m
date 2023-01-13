function load_parameters(obj)
% LOAD_PARAMETERS Loads parameters for every trial.
%
% Loads parameters from trial table and then precalculates other
% parameters that depend on it, i.e. masks, stimulus, fixation, pas and mafc parameters.

    obj.trials.load_trial_parameters(obj)
    
    obj.masks.load_flashing_parameters(obj.screen)
    obj.masks.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
    obj.masks.shuffle()

    prop_list = obj.trials.matrix{1}{1}.get_dynamic_properties;
    for prop_idx = 1:length(prop_list)
        c = class(obj.trials.matrix{1}{1}.(prop_list{prop_idx}));
        if c == "CFS.Element.Stimulus.SuppressedStimulus"
            obj.(prop_list{prop_idx}).load_flashing_parameters(obj.screen, obj.masks)
            obj.(prop_list{prop_idx}).load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
        end
    end
    
    obj.target.load_rect_parameters(obj.screen);
    
    obj.fixation.load_args(obj.screen)
    
    obj.pas.load_parameters(obj.screen)
    if class(obj.mafc) == "CFS.Element.Evidence.ImgMAFC"
        obj.mafc.load_parameters(obj.screen, obj.(prop_list{1}).textures.PTB_indices, obj.(prop_list{1}).index);
    end

    n_fr = obj.masks.duration*obj.screen.frame_rate;
    obj.vbl_recs = zeros(1, n_fr);
    obj.masks.args = cell(1, n_fr);
    for fr = 1:n_fr
        textures = [];
        rects = [];
        rotations = [];
        contrasts = [];
        for prop_idx = 1:length(prop_list)
            c = class(obj.trials.matrix{1}{1}.(prop_list{prop_idx}));
            if c == "CFS.Element.Stimulus.SuppressedStimulus"
                stim = obj.(prop_list{prop_idx});
                if stim.indices(fr)
                    textures(end+1) = stim.textures.PTB_indices{stim.index};
                    rects = [rects, stim.rect];
                    rotations(end+1) = stim.rotation;
                    contrasts(end+1) = stim.contrasts(fr);
                end
            end
        end
        textures(end+1) = obj.masks.textures.PTB_indices{obj.masks.indices(fr)};
        rects = [rects, obj.masks.rect];
        rects = reshape(rects, 4, length(rects)/4);
        rotations(end+1) = obj.masks.rotation;
        contrasts(end+1) = obj.masks.contrast;

        obj.masks.args{fr} = ...
            {
                'DrawTextures', ...
                obj.screen.window, ...
                textures, ...
                [], ...
                rects, ...
                rotations, ...
                [], ...
                contrasts 
            };
    end
    
end