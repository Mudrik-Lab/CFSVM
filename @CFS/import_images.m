function textures = import_images(obj, path)
    %import_images Loads images from dir path and makes an array of textures from it.
    
    % Load filenames
    images = dir(path);
    % Remove '.' and '..' from the list of filenames
    images=images(~ismember({images.name},{'.','..'}));
    % Load image files and make textures from them
    for img = 1:length(images)
        try
            target_image = imread(fullfile(...
                images(img).folder, images(img).name));
            textures{img} = Screen('MakeTexture', obj.window, target_image);
        catch
        end
    end
end