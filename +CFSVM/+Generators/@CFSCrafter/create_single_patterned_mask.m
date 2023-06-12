function patterned_mask_single = create_single_patterned_mask( ...
                                                              stimuli_height_pixel, ...
                                                              stimuli_width_pixel, ...
                                                              patch, ...
                                                              paste_index)

    row = stimuli_height_pixel;
    col = stimuli_width_pixel;

    [patch_xdim, patch_ydim, color_layer] = cellfun(@size, patch);
    max_patch_size = max(max([patch_xdim, patch_ydim]));
    color_layer = color_layer(1);

    ratio = 3:7; % image/patch

    total_patch_no = (max(ratio)^2) * 20;

    patch_location = [
                      randi(round(row + 3 * max_patch_size), ...
                            total_patch_no, 1) ...
                      randi(round(col + 3 * max_patch_size), ...
                            total_patch_no, 1)
                     ];

    uncut_row = 5 * max_patch_size + row;
    uncut_col = 5 * max_patch_size + col;

    patterned_mask_single = zeros(uncut_row, uncut_col, color_layer);

    for i = 1:total_patch_no

        new_paste_index = false(size(patterned_mask_single));
        rand_patch_index = randi(length(patch));
        new_patch = patch{rand_patch_index};
        patch_index = paste_index{rand_patch_index};
        [sz1, sz2, ~] = size(new_patch);
        new_paste_index(patch_location(i, 1):patch_location(i, 1) + sz1 - 1, ...
                        patch_location(i, 2):patch_location(i, 2) + sz2 - 1, ...
                        :) =  paste_index{rand_patch_index};
        patterned_mask_single(new_paste_index) = new_patch(patch_index);

    end

    patterned_mask_single = patterned_mask_single( ...
                                                  max_patch_size:row + max_patch_size - 1, ...
                                                  max_patch_size:col + max_patch_size - 1, ...
                                                  :);
end
