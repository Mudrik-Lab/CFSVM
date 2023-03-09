classdef StereoScreen < CFS.Element.Screen.CustomScreen
% Storing and manipulating left and right screen areas.
    
    properties

        left  % :class:`~+CFS.+Element.+Screen.@ScreenField` object.
        right  % :class:`~+CFS.+Element.+Screen.@ScreenField` object.
        % Int for number of pixels shifted on keypress while adjusting screens.
        
    end


    methods
        
        function obj = StereoScreen(parameters)
        %
        % Args:
        %   background_color: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.background_color`
        %   left_screen_rect: [x0, y0, x1, y1] array with pixel positions.
        %   right_screen_rect: [x0, y0, x1, y1] array with pixel positions.
        %   adjust_shift: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.shift`
        %
            arguments
                parameters.background_color
                parameters.initial_left_screen_rect = [0, 0, 945, 1080];
                parameters.initial_right_screen_rect = [975, 0, 1920, 1080];
                parameters.adjust_shift = 15
            end
            
            obj.background_color = parameters.background_color;
            obj.left = CFS.Element.Screen.ScreenField(parameters.initial_left_screen_rect);
            obj.right = CFS.Element.Screen.ScreenField(parameters.initial_right_screen_rect);
            obj.shift = parameters.adjust_shift;
            
        end
        
        adjust(obj, frame)

    end

end

