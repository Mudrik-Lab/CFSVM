function textures = import_images(obj, path, varargin)
    %import_images Loads images from dir path and makes an array of textures from it.
    
    % Load filenames
    images = dir(path);
    % Remove '.' and '..' from the list of filenames
    images=images(~ismember({images.name},{'.','..'}));
    
    if (~isempty(varargin))
        textures = readimgs(obj.window, images, varargin{1});
    else
        textures = readimgs(obj.window, images, length(images));
    end
end

function textures = readimgs(window, images, n)
    textures = cell(n);
    for img = 1:n
        try
            target_image = imread(fullfile(images(img).folder, images(img).name));
            textures{img} = Screen('MakeTexture', window, target_image);
        catch
        end
    end
end