function [patch, paste_index] = patch_creation( ...
                                               obj, ...
                                               stimuli_height_pixel, ...
                                               stimuli_width_pixel, ...
                                               is_noise_fill, ...
                                               is_colored, ...
                                               pattern_shape, ...
                                               is_pink)

    row = stimuli_height_pixel;
    col = stimuli_width_pixel;

    ratio = .08:.02:.18; % image/patch

    patch_radius =  round(max([row col]) .* (ratio)); % inner radius for circular patch

    half_patch_side = round(sqrt(pi) / 2 * patch_radius); % half side length for square

    patch_radius_diamond = round(sqrt(pi / 2) * patch_radius); % inner radius for diamond patch

    patch_size_lvl = length(ratio);

    count = 1;

    origin_patch_half_size = max(patch_radius_diamond) + 3;
    origin_patch_size = 2 * origin_patch_half_size + 1;

    color_layer = 1;

    if is_noise_fill

        if is_pink
            old_rms = obj.rms_contrast;
            old_lum = obj.mean_luminance;
            obj.rms_contrast = 0.15;
            for i = 1:12
                obj.mean_luminance = (mod(i, 4)) / 5;
                origin_patch{i} = obj.set_rms_and_luminance(create_pink_noise(origin_patch_size));
            end
            obj.rms_contrast = old_rms;
            obj.mean_luminance = old_lum;
        else
            for i = 1:12
                origin_patch{i}  = (rand(origin_patch_size, origin_patch_size) - .5) + (mod(i, 4)) / 5; % gray level before standardizing
            end
        end

    else

        if is_colored
            patch_color = [0 0 0; ...
                           1 0 0; ...
                           0 1 0; ...
                           0 0 1; ...
                           1 1 0];

            for i = 1:height(patch_color)
                origin_patch{i} = reshape(patch_color(i, :), 1, 1, 3) .* ones(origin_patch_size, origin_patch_size, 3);
            end
            color_layer = 3;
        else
            patch_color = (0:.2:1)';
            for i = 1:numel(patch_color)
                origin_patch{i} = patch_color(i) .* ones(origin_patch_size);
            end
        end
    end

    [xx, yy] = meshgrid(-origin_patch_half_size:origin_patch_half_size, -origin_patch_half_size:origin_patch_half_size);

    switch lower(pattern_shape)
        case "circle"
            for i = 1:patch_size_lvl
                shape_mask{i} = xx.^2 + yy.^2 < patch_radius(i)^2;
                larger_mask = xx.^2 + yy.^2 < (patch_radius(i) + 2)^2;
                edge{i} = larger_mask - shape_mask{i};
            end
        case "square"
            for i = 1:patch_size_lvl
                shape_mask{i} = abs(xx) < half_patch_side(i) & abs(yy) < half_patch_side(i);
                larger_mask = abs(xx) < (half_patch_side(i) + 2) & abs(yy) < (half_patch_side(i) + 2);
                edge{i} = larger_mask - shape_mask{i};
            end
        case "diamond"
            for i = 1:patch_size_lvl
                diamond = strel('diamond', patch_radius_diamond(i));
                pad_size = origin_patch_half_size - patch_radius_diamond(i);
                shape_mask{i} = padarray(diamond.Neighborhood, [pad_size pad_size]);

                diamond = strel('diamond', patch_radius_diamond(i) + 2);
                pad_size = origin_patch_half_size - (patch_radius_diamond(i) + 2);
                larger_mask = padarray(diamond.Neighborhood, [pad_size pad_size]);
                edge{i} = larger_mask - shape_mask{i};
            end
    end

    patch = cell(length(origin_patch) * length(shape_mask), 1);
    paste_index = cell(size(patch));

    if is_noise_fill

        % Combine patch shape with patch fill
        for i = 1:length(origin_patch)
            for j = 1:length(shape_mask)
                patch{count} = origin_patch{i} .* shape_mask{j};
                paste_index{count} =  logical(shape_mask{j} + edge{j});

                count = count + 1;
            end
        end

    else

        % Combine patch shape with patch fill
        for i = 1:length(origin_patch)
            for j = 1:length(shape_mask)
                patch{count} = origin_patch{i} .* shape_mask{j};

                paste_index{count} =  logical(repmat(shape_mask{j}, 1, 1, color_layer));

                count = count + 1;
            end
        end

    end

end

function pink_noise = create_pink_noise(origin_patch_size)
    white_noise  = rand(origin_patch_size + 1, origin_patch_size + 1);
    [row, col] = size(white_noise);
    [XX, YY] = meshgrid(-col / 2:col / 2 - 1, row / 2:-1:-(row / 2 - 1));
    D = sqrt((XX).^2 + (YY).^2);
    D(end / 2 + 1, end / 2 + 1, :) = 1; % avoid log zero
    fft_image = fftshift(fft2(white_noise));
    fft_image = fftshift(fft_image .* (1 ./ D));
    pink_noise = real(ifft2(fft_image));
    image_mean = sum(sum(pink_noise, 1), 2) ./ (col * row);
    pink_noise = (pink_noise - image_mean) ./ (max(max(pink_noise)) - min(min(pink_noise))) + 0.5;
    pink_noise = pink_noise(1:end - 1, 1:end - 1);
end
