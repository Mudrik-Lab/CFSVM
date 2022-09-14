function m_alternative_forced_choice(obj)
%m_alternative_forced_choice Draws and shows mAFC images, waits for the
% subject response and records it.
% See also record_response and append_trial_response.

    m = obj.number_of_mAFC_pictures;
    question = sprintf('mAFC');
    img_textures = obj.prime_textures;
    [m0, ~, m1, ~] = CFS.get_stimulus_position('Center', obj.mAFC_images_size);

    left_screen_shift = (obj.left_side_screen(3)-obj.left_side_screen(1))/m;
    right_screen_shift = (obj.right_side_screen(3)-obj.right_side_screen(1))/m;

    mafc_textures{1} = img_textures{obj.stimulus_index};
    img_textures(obj.stimulus_index) = [];
    mafc_textures = horzcat(mafc_textures, img_textures{randperm(length(img_textures), m-1)});
    mafc_textures = mafc_textures(randperm(length(mafc_textures)));
    
    for i = 1:m
        %mafc_rect = [(i-1+x0)*shift, obj.y_center-obj.mAFC_images_size*obj.screen_y_pixels/m, (i-1+x1)*shift, obj.y_center+obj.mAFC_images_size*obj.screen_y_pixels/m];
        left_rect = mafc_rects(obj.left_side_screen, m0, m1, obj.mAFC_images_size, obj.left_side_screen(1), left_screen_shift, i);
        right_rect = mafc_rects(obj.right_side_screen, m0, m1, obj.mAFC_images_size, obj.right_side_screen(1), right_screen_shift, i);
        Screen('DrawTexture', obj.window, mafc_textures{i}, [], left_rect, obj.stimulus_rotation, 1);
        Screen('DrawTexture', obj.window, mafc_textures{i}, [], right_rect, obj.stimulus_rotation, 1);
    end

    DrawFormattedText(obj.window, question, 'center');

    obj.results.afc_onset = Screen('Flip', obj.window);
    
    % Wait for the response.
    [obj.results.afc_kbname, obj.results.afc_response_time] = obj.record_response(obj.mAFC_keys);
    obj.results.afc_response = find(strcmpi(obj.mAFC_keys, obj.results.afc_kbname))-1;
    obj.results.afc_method = sprintf('%dAFC', length(obj.mAFC_keys));
    obj.results.afc_kbname = string(obj.results.afc_kbname);

end

function rect = mafc_rects(screen, m0, m1, size, start_shift, pic_shift, i)
    rect_cell = num2cell(screen);
    [~, y0, ~, y1] = rect_cell{:};
    x0 = start_shift+(i-1+m0)*pic_shift;
    x1 = start_shift+(i-1+m1)*pic_shift;
    dy = y1-y0;
    rect = [x0, dy/2-size*(x1-x0), x1, dy/2+size*(x1-x0)];
end
