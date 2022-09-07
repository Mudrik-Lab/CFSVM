function textures = import_images(obj, path, varargin)
    %import_images Loads images from directory path and makes an array of textures from it.
    % varargin is the optional argument which provides number of first N images
    % to make textures from.
    
    % Load filenames
    images = dir(path);
    % Remove '.' and '..' from the list of filenames
    images=images(~ismember({images.name},{'.','..'}));
    
    % If the second argument (number of images to create textures from) was
    % provided, then create textures only for first N images.
    % Else create textures for every image in the folder.
    if (~isempty(varargin))
        textures = readimgs(obj.window, images, varargin{1});
    else
        textures = readimgs(obj.window, images, length(images));
    end
end

function textures = readimgs(window, images, n)
    %readimgs Loops through the folder, imports images and creates textures
    % from them. n is the number of images in folder to read.
    textures = cell(n);
    while length(images) < n
        images = [images; images];
    end
    
    for img = 1:n
        try
            target_image = imread(fullfile(images(img).folder, images(img).name));
            textures{img} = Screen('MakeTexture', window, target_image);
        catch
        end
    end
end