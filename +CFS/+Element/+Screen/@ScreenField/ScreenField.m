classdef ScreenField < CFS.Element.SpatialElement
    %SCREENFIELD Summary of this class goes here
    %   Detailed explanation goes here
        
    methods
        function obj = ScreenField(rect)
            %CUSTOMSCREEN Constructs an instance of this class
            % Gets optional keyword arguments:
            % left_screen_rect
            % right_screen_rect

            arguments
                rect
            end

            obj.rect = rect;

        end
        


    end
end

