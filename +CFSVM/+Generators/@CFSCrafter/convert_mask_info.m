function convert_mask_info(obj, edge_parameters)
    arguments
        obj
        edge_parameters.detection_method = "canny"
        edge_parameters.detection_threshold = []
    end

    [obj.stimuli_property.height_pixel,...
        obj.stimuli_property.width_pixel,...
        color_layer, ...
        obj.stimuli_property.total_frames] = size(obj.stimuli_array);


    obj.stimuli_property.width_degree = CFSVM.Utils.pix2deg( ...
        obj.stimuli_property.width_pixel, ...
        obj.screen_info.width_cm, ...
        obj.screen_info.width_pixel, ...
        obj.screen_info.viewing_distance);

    obj.stimuli_property.height_degree = CFSVM.Utils.pix2deg( ...
        obj.stimuli_property.height_pixel, ...
        obj.screen_info.height_cm, ...
        obj.screen_info.height_pixel, ...
        obj.screen_info.viewing_distance);


    if color_layer == 3
        obj.stimuli_property.color = "rgb";
    else
        obj.stimuli_property.color = "grayscale";
    end

    gray_stimuli_array = obj.convert_to_grayscale(obj.stimuli_array);
    entropy_frame = zeros(obj.total_frames, 1);

    for i = 1:obj.stimuli_property.total_frames
        entropy_frame(i) = entropy(gray_stimuli_array(:,:,:,i));

    end

    obj.stimuli_property.entropy = mean(entropy_frame,"all");
    obj.stimuli_property.mean_luminance = mean(gray_stimuli_array, "all");
    obj.stimuli_property.rms_contrast = mean(std(gray_stimuli_array,1,[1,2]));
    
    obj.stimuli_property.edge_detection_method = edge_parameters.detection_method;

    [~, ...
        obj.stimuli_property.edge_density, ...
        obj.stimuli_property.edge_detection_threshold] = obj.find_edge( ...
        obj.stimuli_array, ...
        edge_parameters.detection_method, ...
        edge_parameters.detection_threshold);
    
end