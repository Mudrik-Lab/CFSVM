function load_flashing_parameters(obj, screen)
% LOAD_FLASHING_PARAMETERS Calculates contrasts arrays for flashing.

    %obj.textures.index = obj.textures.PTB_indices{obj.index};
    
    obj.contrasts_in = obj.contrast/ ...
        (obj.fade_in_duration*screen.frame_rate+1): ...
        obj.contrast/(obj.fade_in_duration*screen.frame_rate+1): ...
        obj.contrast;
    obj.contrasts_out = obj.contrast/ ...
        (obj.fade_out_duration*screen.frame_rate+1): ...
        obj.contrast/(obj.fade_out_duration*screen.frame_rate+1): ...
        obj.contrast;
    
    %% Intratrial changes
    total_stimulus_duration = obj.fade_in_duration+obj.show_duration+obj.fade_out_duration;

    % Rotations
    time_per_rotation = total_stimulus_duration/obj.n_rotations_per_trial;
    frames_per_rotation = time_per_rotation*screen.frame_rate;
    obj.rotations_array = arrayfun(@(n) (obj.rotation+randi([-obj.rotations_variance, obj.rotations_variance])), ...
        1:obj.n_rotations_per_trial);
    obj.rotations_indices = arrayfun(@(n) (ceil(n/frames_per_rotation)), ...
        1:(total_stimulus_duration*screen.frame_rate));
    obj.rotations_indices = [obj.rotations_indices, obj.rotations_indices(end)];
    
    % Multiple temporal stimuli
    time_per_stimulus = total_stimulus_duration/width(obj.indices);
    frames_per_stimulus = time_per_stimulus*screen.frame_rate;
    obj.indices = arrayfun(@(n) (obj.indices(ceil(n/frames_per_stimulus))), ...
        1:(total_stimulus_duration*screen.frame_rate));
    obj.indices = [obj.indices, obj.indices(end)];
    obj.index = obj.indices(1);
    obj.image_name = obj.textures.images_names(obj.index);

end