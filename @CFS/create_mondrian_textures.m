function create_mondrian_textures(obj)
    %create_mondrian_textures Creates textures from mondrian masks.
    
    % Wait until generate_mondrians() finishes.
    wait(obj.future);
    % Get the generated masks
    obj.masks = fetchOutputs(obj.future);
    % Initiate an array.
    obj.textures = cell(1, obj.masks_number);
    % Generate the Psychtoolbox textures.
    for n = 1 : obj.masks_number
        obj.textures{n} = Screen('MakeTexture', obj.window, obj.masks{n});
    end
end