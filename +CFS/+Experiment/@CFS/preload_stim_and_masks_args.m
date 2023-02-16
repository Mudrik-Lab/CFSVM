function preload_stim_and_masks_args(obj, stim_props)
%PRELOAD_STIM_AND_MASKS_ARGS Precalculates PTB DrawTexture args for a trial.

    % Get number of frames 
    n_fr = obj.masks.duration*obj.screen.frame_rate;
    % Initialize vbl_recs
    obj.vbl_recs = zeros(1, n_fr);
    % Initialize args cell array
    obj.masks.args = cell(1, n_fr);

    % For every frame set for every stimulus set its texture, rectangle,
    % rotation and contrast
    for fr = 1:n_fr
        textures = [];
        rects = [];
        rotations = [];
        contrasts = [];
        for prop_idx = 1:length(stim_props)
        
            stim = obj.(stim_props{prop_idx});
            if stim.indices(fr)
                textures(end+1) = stim.textures.PTB_indices{stim.index};
                rects = [rects, stim.rect];
                rotations(end+1) = stim.rotation;
                contrasts(end+1) = stim.contrasts(fr);
            end

        end

        % Add masks args to the end.
        textures(end+1) = obj.masks.textures.PTB_indices{obj.masks.indices(fr)};
        rects = [rects, obj.masks.rect];
        rects = reshape(rects, 4, length(rects)/4);
        rotations(end+1) = obj.masks.rotation;
        contrasts(end+1) = obj.masks.contrast;

        % Add args to the cell array
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

