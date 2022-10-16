classdef (Abstract) SpatialElement < handle
    %SPATIALELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
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
            x_pixels = obj.rect(3)-obj.rect(1);
        end
        function y_pixels = get.y_pixels(obj)
            y_pixels = obj.rect(4)-obj.rect(2);
        end
        function x_center = get.x_center(obj)
            x_center = obj.rect(3)-round((obj.rect(3)-obj.rect(1))/2);
        end
        function y_center = get.y_center(obj)
            y_center = obj.rect(4)-round((obj.rect(4)-obj.rect(2))/2);
        end
        
        %initiate(obj)
    end
end

