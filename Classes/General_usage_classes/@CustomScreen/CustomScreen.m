classdef CustomScreen < handle
    %CustomScreen Class for storing parameters of two provided screens.
    
    properties
        % Struct with fields: rect, x_pixels, y_pixels, x_center, y_center.
        left
        % Struct with fields: rect, x_pixels, y_pixels, x_center, y_center
        right
        background_color
        window
        inter_frame_interval
    end


    methods
        function obj = CustomScreen(parameters)
            %CUSTOMSCREEN Constructs an instance of this class
            % Gets optional keyword arguments:
            % left_screen_rect
            % right_screen_rect
            arguments
                parameters.background_color
                parameters.left_screen_rect = [0, 0, 945, 1080];
                parameters.right_screen_rect = [975, 0, 1920, 1080];
                
            end
            obj.background_color = parameters.background_color;
            obj.left.rect = parameters.left_screen_rect;
            obj.right.rect = parameters.right_screen_rect;
            
            
        end
        
        initiate(obj)
        adjust(obj, frame)
    end
end

