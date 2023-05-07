classdef ScreenField < CFSVM.Element.SpatialElement
% A concrete class from the abstract
% :class:`~CFSVM.Element.SpatialElement`.
%
% Describes fields of the screen as properties of 
% :class:`~CFSVM.Element.Screen.CustomScreen`.
%
        
    methods

        function obj = ScreenField(rect)
        %
        % Args:
        %   rect: :attr:`~CFSVM.Element.SpatialElement.rect`
        %
            arguments
                rect
            end

            obj.rect = rect;

        end

    end

end

