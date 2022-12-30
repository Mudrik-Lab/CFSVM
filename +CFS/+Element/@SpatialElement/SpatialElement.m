classdef (Abstract) SpatialElement < handle
% SPATIALELEMENT An abstract class for elements with spatial properties.
    
    properties

        rect
        contrast
        color
       
    end

    properties (Dependent)

        x_pixels
        y_pixels
        x_center
        y_center

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

