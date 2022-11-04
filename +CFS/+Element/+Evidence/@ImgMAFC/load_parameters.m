function load_parameters(obj, screen, PTB_textures_indices, shown_texture_index)
% LOAD_MAFC_PARAMETERS Loads parameters for mAFC screen for current trial.

    img_textures = PTB_textures_indices;
    obj.options = {};

    % Calculate shift for every mAFC choice.
    left_screen_shift = screen.left.x_pixels/obj.n_options;
    right_screen_shift = screen.right.x_pixels/obj.n_options;

    if shown_texture_index ~= 0
        % Copy prime image used in the trial.
        obj.options{1} = img_textures{shown_texture_index};
        % Remove used prime image.
        img_textures(shown_texture_index) = [];
    end

    % Choose randomly n-1 not used prime images.
    obj.options = horzcat(obj.options, img_textures{randperm(length(img_textures), obj.n_options-1)});

    % Shuffle used prime image with not used ones.
    obj.options = obj.options(randperm(length(obj.options)));

    obj.img_indices = num2str(cellfun(@(x) find([PTB_textures_indices{:}]==x), obj.options));
    obj.rect = {zeros(obj.n_options,4);zeros(obj.n_options,4)};

    for i = 1:obj.n_options
        left = [screen.left.rect(1)+left_screen_shift*(i-1), ...
            screen.left.rect(2), ...
            screen.left.rect(1)+left_screen_shift*(i), ...
            screen.left.rect(4)];
        right = [screen.right.rect(1)+right_screen_shift*(i-1), ...
            screen.right.rect(2), ...
            screen.right.rect(1)+right_screen_shift*(i), ...
            screen.right.rect(4)];
        obj.rect{1}(i,:) = obj.get_rect(left);
        obj.rect{2}(i,:) = obj.get_rect(right);
    end

end