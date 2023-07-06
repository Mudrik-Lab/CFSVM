function preload_stim_and_masks_args(obj, stim_props)
    % Precalculates DrawTexture args for stimuli and masks for a trial.
    %
    % Args:
    %   stim_props: A cell array of chars with names for stimuli properties.
    %

    % Get number of frames
    n_fr = obj.masks.duration * obj.screen.frame_rate;
    % Initialize vbl_recs
    obj.flips = zeros(5, n_fr);
    % Initialize args cell array
    obj.masks.args = cell(1, n_fr);
    
    try
        masks_contrasts = CFSVM.Utils.expand_n2m(obj.masks.contrast, n_fr);
    catch ME
        if ME.identifier == "MATLAB:repelem:invalidReplications"
            error("Number of contrasts provided for the masks object is invalid.")
        else
            rethrow(ME)
        end
    end

    try
        masks_rotations = CFSVM.Utils.expand_n2m(obj.masks.rotation, n_fr);
    catch ME
        if ME.identifier == "MATLAB:repelem:invalidReplications"
            error("Number of rotations provided for the masks object is invalid.")
        else
            rethrow(ME)
        end
    end
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
                textures(end + 1) = stim.textures.PTB_indices{stim.index};
                rects = [rects, stim.rect];
                rotations(end + 1) = stim.rotation;
                contrasts(end + 1) = stim.contrasts(fr);
            end

        end
        
        if masks_contrasts(fr)
            % Add masks args to the end.
            textures(end + 1) = obj.masks.textures.PTB_indices{obj.masks.indices(fr)};
            rects = [rects, obj.masks.rect];
            rotations(end + 1) = masks_rotations(fr);
            contrasts(end + 1) = masks_contrasts(fr);

            if width(obj.masks.rect) == 8
                textures(end + 1) = obj.masks.textures.PTB_indices{obj.masks.indices(fr)};
                rotations(end + 1) = masks_rotations(fr);
                contrasts(end + 1) = masks_contrasts(fr);
            end
        end
        
        rects = reshape(rects, 4, length(rects) / 4);

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
