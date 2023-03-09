classdef MonoScreen < CFS.Element.Screen.CustomScreen
    %MONOSCREEN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        field
    end
    
    methods
        function obj = MonoScreen(parameters)
        %
        % Args:
        %   background_color: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.background_color`
        %   screen_rect: [x0, y0, x1, y1] array with pixel positions.
        %   adjust_shift: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.shift`
        %
            arguments
                parameters.background_color
                parameters.initial_screen_rect = [0, 0, 1920, 1080];
                parameters.adjust_shift = 15
            end
            
            obj.background_color = parameters.background_color;
            obj.field = CFS.Element.Screen.ScreenField(parameters.initial_screen_rect);
            obj.shift = parameters.adjust_shift;
            
        end
        
        adjust(obj, frame)
    end
end

