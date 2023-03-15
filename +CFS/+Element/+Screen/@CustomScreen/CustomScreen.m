classdef CustomScreen < handle
% Storing and manipulating left and right screen areas.
    
    properties
        % Cell array of :class:`~+CFS.+Element.+Screen.@ScreenField` objects.
        fields
        % Int for number of pixels shifted on keypress while adjusting screens.
        shift
        % Char array of 7 chars containing HEX color.
        background_color

        window  % PTB window object.
        inter_frame_interval  % Float for time between two frames ≈ 1/frame_rate.
        frame_rate  % Float for display refresh rate.
    end


    methods
        
        function obj = CustomScreen(parameters)
        %
        % Args:
        %   background_color: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.background_color`
        %
        %   initial_left_screen_rect: [x0, y0, x1, y1] array with pixel positions.
        %   initial_right_screen_rect: [x0, y0, x1, y1] array with pixel positions.
        %   adjust_shift: :attr:`~.+CFS.+Element.+Screen.@CustomScreen.CustomScreen.shift`
        %
            arguments
                parameters.background_color
                parameters.is_stereo = false;
                parameters.initial_rect = [0,0,945,1080]
                parameters.adjust_shift = 15
            end
            
            obj.background_color = parameters.background_color;
            obj.fields{1} = CFS.Element.Screen.ScreenField(parameters.initial_rect);
            if parameters.is_stereo
                set(0,'units','pixels')  
                screen_size = get(0,'ScreenSize');
                second_rect = [ ...
                    screen_size(3)-parameters.initial_rect(3), ...
                    parameters.initial_rect(2), ...
                    screen_size(3)-parameters.initial_rect(1), ...
                    parameters.initial_rect(4)];
                obj.fields{2} = CFS.Element.Screen.ScreenField(second_rect);
            end
            obj.shift = parameters.adjust_shift;
            
        end
        
        adjust(obj, frame)

    end

end

