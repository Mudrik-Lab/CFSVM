classdef CustomScreen < matlab.mixin.Copyable
% Storing and manipulating left and right screen areas.
    
    properties

        % Cell array of :class:`~CFSVM.Element.Screen.ScreenField` objects.
        fields cell
        % Int for number of pixels shifted on keypress while adjusting screens.
        shift {mustBePositive, mustBeInteger}
        % Char array of 7 chars containing HEX color.
        background_color
        % PTB window object.
        window 
        % Float for time between two frames ≈ 1/frame_rate.
        inter_frame_interval {mustBeNumeric}
        % Float for display refresh rate.
        frame_rate {mustBeNumeric}

    end


    methods
        
        function obj = CustomScreen(parameters)
        %
        % Args:
        %   background_color: :attr:`~CFSVM.Element.Screen.CustomScreen.background_color`
        %   is_stereo: bool for setting two screenfields.
        %   initial_rect: [x0, y0, x1, y1] array with pixel positions, if is_stereo, position of the left field.
        %   shift: :attr:`~CFSVM.Element.Screen.CustomScreen.shift`
        %
        
            arguments
                parameters.background_color {mustBeHex}
                parameters.is_stereo {mustBeNumericOrLogical} = false;
                parameters.initial_rect (1,4) {mustBeInteger} = [0,0,950,1080]
                parameters.shift = 10
            end
            
            obj.background_color = parameters.background_color;
            obj.fields{1} = CFSVM.Element.Screen.ScreenField(parameters.initial_rect);
            if parameters.is_stereo
                set(0,'units','pixels')  
                screen_size = get(0,'ScreenSize');
                second_rect = [ ...
                    screen_size(3)-parameters.initial_rect(3), ...
                    parameters.initial_rect(2), ...
                    screen_size(3)-parameters.initial_rect(1), ...
                    parameters.initial_rect(4)];
                obj.fields{2} = CFSVM.Element.Screen.ScreenField(second_rect);
            end
            obj.shift = parameters.shift;
            
        end
        
        adjust(obj, frame)

    end

end

function mustBeHex(a)
    if ~regexp(a, "#[\d, A-F]{6}", 'ignorecase')
        error("Provided hex color is wrong.")
    end
end