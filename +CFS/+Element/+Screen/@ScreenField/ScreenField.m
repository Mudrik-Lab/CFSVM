classdef ScreenField < CFS.Element.SpatialElement
%SCREENFIELD Screen class for describing area on the screen.
        
    methods

        function obj = ScreenField(rect)
            % SCREENFIELD Constructs an instance of this class

            arguments
                rect
            end

            obj.rect = rect;

        end

    end

end

