function import_images(obj, window, parameters)
    %import_images Loads images from directory path and makes an array of textures from it.

    arguments
        obj
        window
        parameters.images_number
    end
    
    % Load filenames
    images = dir(obj.dirpath);
    % Remove '.' and '..' from the list of filenames
    images=images(~ismember({images.name},{'.','..'}));
    
    % If the second argument (number of images to create textures from) was
    % provided, then create textures only for first N images.
    % Else create textures for every image in the folder.
    if isfield(parameters, 'images_number')
        n = parameters.images_number;
        if length(images) < n
            images = repmat(images, 1, fix(n/length(images)));
        end
    else
        n = length(images);
    end

    for img_index = 1:n
        try
            image = imread(fullfile(images(img_index).folder, images(img_index).name));
        catch
        end
        obj.textures.PTB_indices{img_index} = Screen('MakeTexture', window, image);
        
    end
    obj.textures.len = length(obj.textures.PTB_indices);

end