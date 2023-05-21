function import_images(obj, window, parameters)
% Loads images from the provided path and makes an array of PTB textures from it.
%
% Args:
%   window: PTB window object.
%   images_number: (Optional) Number of textures to create.
%
    arguments

        obj
        window
        parameters.images_number

    end
    
    % Load filenames, remove dots and sort naturally.
    images = CFSVM.Utils.natsortfiles(dir(obj.dirpath), [], 'rmdot');
    
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
            fullp = fullfile(images(img_index).folder, images(img_index).name);
            [~, ~, ext] = fileparts(fullp);
            if ext == ".png"
                [image, ~, alpha] = imread(fullp);
                if ~isempty(alpha)
                    image(:, :, 4) = alpha;
                end
            else
                image = imread(fullp);
            end
            obj.textures.PTB_indices{img_index} = Screen('MakeTexture', window, image);
            obj.textures.images_names{img_index} = images(img_index).name;
        catch
        end
    end

    % Get number of textures created. 
    obj.textures.len = length(obj.textures.PTB_indices);

end