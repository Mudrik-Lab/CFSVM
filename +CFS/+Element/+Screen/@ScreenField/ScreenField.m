classdef ScreenField < CFS.Element.SpatialElement
% A concrete class from the abstract
% :class:`~+CFS.+Element.@SpatialElement`.
%
% Describes fields of the screen as properties of 
% :class:`~+CFS.+Element.+Screen.@CustomScreen`.
%
        
    methods

        function obj = ScreenField(rect)

            arguments
                rect
            end

            obj.rect = rect;

        end

    end

end

