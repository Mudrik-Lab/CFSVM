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
    total_frames = total_stimulus_duration*screen.frame_rate;
    total_images = length(unique(obj.indices));
    %obj.index = obj.indices;
    obj.image_name = obj.textures.images_names(obj.indices);

    % Rotations
    time_per_rotation = total_stimulus_duration/obj.n_rotations_per_trial;
    frames_per_rotation = time_per_rotation*screen.frame_rate;
    obj.rotations_array = arrayfun(@(n) (obj.rotation+randi([-obj.rotations_variance, obj.rotations_variance])), ...
        1:obj.n_rotations_per_trial);
    obj.rotations_indices = arrayfun(@(n) (ceil(n/frames_per_rotation)), ...
        1:(total_frames));
    obj.rotations_indices = [obj.rotations_indices, obj.rotations_indices(end)];
    

    positions = ["UpperLeft" "Top" "UpperRight";
        "Left" "Center" "Right";
        "LowerLeft" "Bottom" "LowerRight"];

    z = zeros([numel(positions), total_frames, total_images]);
    % Multiple temporal/spatial stimuli
    time_per_stimulus = total_stimulus_duration/size(obj.indices, 2);
    frames_per_stimulus = time_per_stimulus*screen.frame_rate;
    
    for frame = 1:total_frames
        for pos = 1:size(obj.indices, 1)
            z( ...
                find(positions == obj.position(pos, ceil(frame/frames_per_stimulus))), ...
                frame, ...
                obj.indices(pos, ceil(frame/frames_per_stimulus))) = 1; 
        end
    end
    obj.indices = z;
    %obj.indices = arrayfun(@(n) (obj.indices(ceil(n/frames_per_stimulus))), ...
    %    1:(total_frames));
    obj.indices = cat(2, obj.indices, obj.indices(:, end, :));  

end