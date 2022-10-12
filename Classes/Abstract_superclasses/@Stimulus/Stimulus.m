classdef (Abstract) Stimulus < ExperimentElement
    %STIMULUS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dirpath;
        % Stimulus position on the screen (half of the window).
        % Expected values are 'UpperLeft', 'Top', 'UpperRight', 'Left', 
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'.
        position {mustBeMember(position, { ...
                         'UpperLeft', 'Top', 'UpperRight', ...
                         'Left', 'Center', 'Right', ...
                         'LowerLeft', 'Bottom', 'LowerRight'})} = 'Center';
        
        xy_ratio = 1;

        % From 0 to 1, where 1 means 100% of the screen (half of the window).
        size {mustBeInRange(size, 0, 1)} = 0.5;

        padding = 0;
        
        % Positive values represent clockwise rotation, 
        % negative values represent counterclockwise rotation.
        rotation {mustBeNumeric} = 0;
        
        % Contrast is from 0 (fully transparent) to 1 (fully opaque).
        contrast {mustBeInRange(contrast, 0, 1)} = 1;

        index;

        textures;
        
    end
   
    methods
        new_rectangle = get_rect(obj, screen_rectangle);
        [x0, y0, x1, y1, i, j] = get_stimulus_rect_shift(obj);
        import_images(obj, window, parameters);
    end
end

