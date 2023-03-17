classdef (Abstract) SpatialElement < handle
% A base class describing elements with spatial properties.
%
    
    properties

        % [x0, y0, x1, y1] array with pixel positions for the 
        % element's rectangle.
        rect  
        contrast  % Float from 0 to 1
        color  % [R, G, B] array for R, G, B ranging from 0 to 1.
       
    end

    properties (Dependent)

        x_pixels  % Int - width in pixels.
        y_pixels  % Int - height in pixels.
        x_center  % Int - center pixel, for even width lesser value is chosed.
        y_center  % Int - center pixel, for even height lesser value is chosed.

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

