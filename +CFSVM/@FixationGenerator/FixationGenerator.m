classdef FixationGenerator
    %FIXATIONGENERATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dirpath
        radius
    end

    properties(Access=private)
        color
    end
    
    methods
        function obj = FixationGenerator(dirpath, parameters)

            arguments 
                dirpath
                parameters.radius = 256
                parameters.hex_color = '#000000'
            end
            
            obj.dirpath = dirpath;
            if ~exist(fullfile(obj.dirpath,'Fixation/'), 'dir')
                mkdir(fullfile(obj.dirpath,'Fixation/'))
            end
            obj.radius=parameters.radius;
            obj.color = sscanf(parameters.hex_color(2:end),'%2x%2x%2x',[1 3])/255;
        end

        function A(obj)
            im = zeros(obj.radius*2+1);
            ellipse_pixels = obj.circle(obj.radius, obj.radius*2+1);
            im(ellipse_pixels)=1;
            imwrite(ind2rgb(im, obj.color), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double(ellipse_pixels'));
        end

        function C(obj, parameters)
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
            end
            im = zeros(obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius, parameters.cross_width);
            im(cross_pixels)=1;
            imwrite(ind2rgb(im, obj.color), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double(cross_pixels'));
        end
        
        function AB(obj, parameters)
            arguments 
                obj
                parameters.inner_circle_radius = fix(obj.radius/4)
                parameters.inner_circle_hex_color = 'transparent'
            end
            im = zeros(obj.radius*2+1);
            circle_pixels = obj.circle(obj.radius, obj.radius*2+1);
            inner_circle_pixels = obj.circle(parameters.inner_circle_radius, obj.radius*2+1);
            im(circle_pixels)=1;
            if parameters.inner_circle_hex_color=="transparent"
                imwrite( ...
                    ind2rgb(im, obj.color), ...
                    fullfile(obj.dirpath, 'Fixation/fixation.png'), ...
                    alpha=double((circle_pixels&~inner_circle_pixels)'));
            else
                im(inner_circle_pixels)=2;
                circle_color=obj.hex2rgb(parameters.inner_circle_hex_color);
                imwrite( ...
                    ind2rgb(im, [obj.color; circle_color]), ...
                    fullfile(obj.dirpath, 'Fixation/fixation.png'), ...
                    alpha=double(or(circle_pixels, inner_circle_pixels)'));
            end
        end

        function AC(obj, parameters)
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
                parameters.circle_radius = fix(obj.radius/4)
                parameters.circle_hex_color = 'transparent'
            end
            im = zeros(obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius, parameters.cross_width);
            circle_pixels = obj.circle(parameters.circle_radius, obj.radius*2+1);
            im(cross_pixels)=1;
            if parameters.circle_hex_color=="transparent"
                imwrite(ind2rgb(im, obj.color), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double((cross_pixels&~circle_pixels)'));
            else
                im(circle_pixels)=2;
                circle_color=obj.hex2rgb(parameters.circle_hex_color);
                imwrite(ind2rgb(im, [obj.color; circle_color]), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double(or(cross_pixels, circle_pixels)'));
            end
        end

        function BC(obj, parameters)
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
                parameters.cross_hex_color = 'transparent'
            end
            im = zeros(obj.radius*2+1);
            circle_pixels = obj.circle(obj.radius, obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius, parameters.cross_width);
            im(circle_pixels)=1;
            if parameters.cross_hex_color=="transparent"
                imwrite(ind2rgb(im, obj.color), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double((circle_pixels&~cross_pixels)'));
            else
                im(cross_pixels)=2;
                cross_color=obj.hex2rgb(parameters.cross_hex_color);
                imwrite(ind2rgb(im, [obj.color; cross_color]), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double(or(cross_pixels, circle_pixels)'));
            end
        end

        function ABC(obj, parameters)
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
                parameters.inner_circle_radius = fix(obj.radius/4)
                parameters.cross_hex_color = 'transparent'
            end
            im = zeros(obj.radius*2+1);
            circle_pixels = obj.circle(obj.radius, obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius, parameters.cross_width);
            inner_circle_pixels = obj.circle(parameters.inner_circle_radius, obj.radius*2+1);
            im(circle_pixels)=1;
            if parameters.cross_hex_color=="transparent"
                imwrite(ind2rgb(im, obj.color), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double((circle_pixels&~(cross_pixels&~inner_circle_pixels))'));
            else
                im(cross_pixels)=2;
                im(inner_circle_pixels)=1;
                cross_color=obj.hex2rgb(parameters.cross_hex_color);
                imwrite(ind2rgb(im, [obj.color; cross_color]), fullfile(obj.dirpath, 'Fixation/fixation.png'), alpha=double(or(circle_pixels, inner_circle_pixels)'));
            end
        end
    end

    methods(Static, Access=private)
        function circle_pixels = circle(radius, pixels_side)
            center_x=fix(pixels_side/2)+1;
            center_y=fix(pixels_side/2)+1;
            [columns, rows] = meshgrid(1:pixels_side, 1:pixels_side);
            circle_pixels = (rows - center_y).^2 ./ radius^2 ...
            + (columns - center_x).^2 ./ radius^2 <= 1;
        end

        function cross_pixels = cross(radius, width)
            center_x = radius+1;
            center_y = radius+1;
            img = zeros(radius*2+1);
            img(center_y-radius:center_y+radius, center_x-width:center_x+width) = 1;
            img(center_y-width:center_y+width, center_x-radius:center_x+radius) = 1;
            cross_pixels = logical(img);
        end
        function rgb = hex2rgb(hex)
        % Transforms hexadecimal color code to MATLAB RGB color code.
            rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
        end

    end

end

