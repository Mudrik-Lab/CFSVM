classdef (Abstract) CustomScreen < handle
% Storing and manipulating left and right screen areas.
    
    properties

        % Int for number of pixels shifted on keypress while adjusting screens.
        shift 
        background_color  % Char array of 7 chars containing HEX color.
        window  % PTB window object.
        inter_frame_interval  % Float for time between two frames ≈ 1/frame_rate.
        frame_rate  % Float for display refresh rate.
        
    end


    methods(Abstract)
        
        adjust(obj, frame)

    end

end

