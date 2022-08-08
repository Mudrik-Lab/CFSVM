function get_rects(obj)
    %get_rects Calculates on-screen rectangles from target and mask position/size parameters.
    % Uses static get_stimulus_poisition function, all the tech behind can
    % be find in its documentation.
    % See also get_stimulus_position
    
    % Calculate shift of upperleft and lowerright verticies of target and
    % mask image rectangles.
    [x0, y0, x1, y1] = CFS.get_stimulus_position(obj.target_position, obj.target_size);
    [k0, j0, k1, j1] = CFS.get_stimulus_position(obj.mask_position, obj.mask_size);
    
    % Calculate coordinates for target and mask image rectangles.
    if obj.left_suppression==true
        obj.target_rect = [(1+x0)*obj.x_center, y0*obj.screen_y_pixels, (1+x1)*obj.x_center, y1*obj.screen_y_pixels];
        obj.masks_rect = [k0*obj.x_center, j0*obj.screen_y_pixels, k1*obj.x_center, j1*obj.screen_y_pixels];
    else
        obj.target_rect = [x0*obj.x_center, y0*obj.screen_y_pixels, x1*obj.x_center, y1*obj.screen_y_pixels];
        obj.masks_rect = [(1+k0)*obj.x_center, j0*obj.screen_y_pixels, (1+k1)*obj.x_center, j1*obj.screen_y_pixels];
    end
end   
