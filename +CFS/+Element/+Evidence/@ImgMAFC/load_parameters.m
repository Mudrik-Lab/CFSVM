function load_parameters(obj, screen, PTB_textures_indices, shown_texture_index)
% Loads parameters for mAFC screen for the trial.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%   PTB_textures_indices: Cell array of ints representing loaded PTB textures.
%   shown_texture_index: Int representing PTB texture shown as stimulus.
%

    img_textures = PTB_textures_indices;
    obj.options = {};

    % Calculate shift for every mAFC choice.
    left_screen_shift = screen.fields{1}.x_pixels/obj.n_options;

    if length(screen.fields) > 1
        right_screen_shift = screen.fields{2}.x_pixels/obj.n_options;
    end

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
        left = [screen.fields{1}.rect(1)+left_screen_shift*(i-1), ...
            screen.fields{1}.rect(2), ...
            screen.fields{1}.rect(1)+left_screen_shift*(i), ...
            screen.fields{1}.rect(4)];

        obj.rect{1}(i,:) = obj.get_rect(left);

        if length(screen.fields) > 1
            right = [screen.fields{2}.rect(1)+right_screen_shift*(i-1), ...
                screen.fields{2}.rect(2), ...
                screen.fields{2}.rect(1)+right_screen_shift*(i), ...
                screen.fields{2}.rect(4)];
            
            obj.rect{2}(i,:) = obj.get_rect(right);
        end
        
    end

end