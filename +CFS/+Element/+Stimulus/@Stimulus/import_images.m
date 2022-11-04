function import_images(obj, window, parameters)
% import_images Loads images from the provided path and makes an array of PTB textures from it.

    arguments
        obj
        window
        parameters.images_number
    end
    
    % Load filenames
    images = dir(obj.dirpath);
    % Remove '.' and '..' from the list of filenames
    images=images(~ismember({images.name},{'.','..'}));
    
    % If the 'images_number' argument was provided, 
    % then create textures only for the first 'images_number' images.
    % Else create textures for every image in the folder.
    if isfield(parameters, 'images_number')
        n = parameters.images_number;
        % Duplicate images if there is not enough in the folder.
        if length(images) < n
            images = repmat(images, 1, fix(n/length(images)));
        end
    else
        n = length(images);
    end
    
    % For every image read it and make PTB texture, ignore files that are
    % not images.
    for img_index = 1:n
        try
            image = imread(fullfile(images(img_index).folder, images(img_index).name));
        catch
        end
        obj.textures.PTB_indices{img_index} = Screen('MakeTexture', window, image);
        
    end

    % Get number of textures created. 
    obj.textures.len = length(obj.textures.PTB_indices);

end