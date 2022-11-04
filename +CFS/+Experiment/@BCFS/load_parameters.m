function load_parameters(obj)
% LOAD_PARAMETERS Loads parameters for every trial.
%
% Loads parameters from trial table and then precalculates other
% parameters that depend on it, i.e. masks, stimulus, fixation parameters.

    obj.trials.load_trial_parameters(obj);
    
    obj.masks.load_flashing_parameters(obj.screen, obj.stimulus);
    obj.masks.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
    obj.masks.shuffle(10*obj.trials.block_index+obj.trials.trial_index);

    obj.stimulus.load_flashing_parameters(obj.masks);
    obj.stimulus.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)

    obj.fixation.load_args(obj.screen);

    obj.stimulus.textures.index = obj.stimulus.textures.PTB_indices{obj.stimulus.index};

end
