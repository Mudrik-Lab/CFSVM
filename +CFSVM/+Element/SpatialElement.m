classdef (Abstract) SpatialElement < matlab.mixin.Copyable
% A base class describing elements with spatial properties.
%
    
    properties

        % ``[x0, y0, x1, y1] array`` with pixel positions for the 
        % element's rectangle.
        rect (1,4) {mustBeNonnegative}

        % ``Float`` from 0 to 1, where 1 is full contrast.
        contrast (1,1) {mustBeInRange(contrast, 0, 1)} 
        
        % ``[R, G, B] array`` for Red, Green, Blue ranging from 0 to 1.
        color (1,3) {mustBeInRange(color, 0, 1)} 
       
    end

    properties (Dependent)

        x_pixels  % (Dependent) Width in pixels.
        y_pixels  % (Dependent) Height in pixels.
        x_center  % (Dependent) Center pixel, the lesser value is chosed when the width is even.
        y_center  % (Dependent) Center pixel, the lesser value is chosed when the height is even.

    end
    
    methods

        function x_pixels = get.x_pixels(obj)
            if isempty(obj.rect)
                x_pixels = [];
            else
                x_pixels = obj.rect(3)-obj.rect(1);
            end
        end

        function y_pixels = get.y_pixels(obj)
            if isempty(obj.rect)
                y_pixels = [];
            else
                y_pixels = obj.rect(4)-obj.rect(2);
            end
        end

        function x_center = get.x_center(obj)
            if isempty(obj.rect)
                x_center = [];
            else
                x_center = obj.rect(3)-round((obj.rect(3)-obj.rect(1))/2);
            end
        end
        
        function y_center = get.y_center(obj)
            if isempty(obj.rect)
                y_center = [];
            else
                y_center = obj.rect(4)-round((obj.rect(4)-obj.rect(2))/2);
            end
        end
        
    end

end

