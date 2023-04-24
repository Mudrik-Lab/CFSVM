classdef FixationGenerator
% Generates fixation targets.
%
% Supports 6 different shapes from Thaler et al., 2013.
%

    properties(Access=private)
        dirpath
        radius
        is_anti_aliasing
        n_cycles
        color
    end
    
    methods
        function obj = FixationGenerator(dirpath, parameters)
        %
        % Args:
        %   dirpath: Fixation targets will be generated inside
        %       dirpath/Fixation/
        %   radius: Radius in pixels of the largest shape in the fixaiton.
        %   hex_color: Color of the fixation target
        %   is_smooth_edges: Whether to smooth the jaggies.
        %   smoothing_cycles: Number of smoothing cycles.
        %
            arguments 
                dirpath {mustBeTextScalar}
                parameters.radius {mustBeInteger, mustBePositive} = 256
                parameters.hex_color {mustBeHex} = '#000000'
                parameters.is_smooth_edges {mustBeNumericOrLogical} =false
                parameters.smoothing_cycles {mustBeInteger, mustBePositive} =1
            end
            
            obj.dirpath = dirpath;
            if ~exist(fullfile(obj.dirpath,'Fixation/'), 'dir')
                mkdir(fullfile(obj.dirpath,'Fixation/'))
            end
            obj.radius = parameters.radius;
            obj.is_anti_aliasing = parameters.is_smooth_edges;
            if obj.is_anti_aliasing
                obj.n_cycles = parameters.smoothing_cycles;
            else
                obj.n_cycles = 0;
            end
            obj.color = sscanf(parameters.hex_color(2:end),'%2x%2x%2x',[1 3])/255;
        end

        function A(obj, parameters)
        % Generates the circular target shape.
        %
        % Args:
        %   fname: Name of the image file, should end with .png.
        %
            arguments
                obj
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius*2+1);
            circle_pixels = obj.circle(obj.radius-round(sqrt(obj.n_cycles)), obj.radius*2+1);
            smoothed_pixels = obj.smooth_edges(circle_pixels);
            im(circle_pixels)=1;
            imwrite( ...
                ind2rgb(im, obj.color), ...
                fullfile(obj.dirpath, strcat('Fixation/', parameters.fname)), ...
                alpha=smoothed_pixels);
            
        end

        function C(obj, parameters)
        % Generates the cross target shape.
        %
        % Args:
        %   fname: Name of the image file, should end with .png.
        %   cross_width: Width of the cross arms.
        %
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius-round(sqrt(obj.n_cycles)), obj.radius*2+1, parameters.cross_width);
            smoothed_pixels = obj.smooth_edges(cross_pixels);
            im(cross_pixels)=1;
            imwrite( ...
                ind2rgb(im, obj.color), ...
                fullfile(obj.dirpath, strcat('Fixation/', parameters.fname)), ...
                alpha=smoothed_pixels);
        end
        
        function AB(obj, parameters)
        % Generates the circle-inside-circle target shape.
        %
        % Args:
        %   fname: Name of the image file, should end with .png.
        %   inner_circle_radius: Radius of the inner circle.
        %
            arguments 
                obj
                parameters.inner_circle_radius = fix(obj.radius/4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius*2+1);
            circle_pixels = obj.circle(obj.radius-round(sqrt(obj.n_cycles)), obj.radius*2+1);
            inner_circle_pixels = obj.circle(parameters.inner_circle_radius, obj.radius*2+1);
            im(circle_pixels)=1;
            im(inner_circle_pixels)=0;
            smoothed_pixels = obj.smooth_edges(im);
            imwrite( ...
                ind2rgb(im, obj.color), ...
                fullfile(obj.dirpath, strcat('Fixation/', parameters.fname)), ...
                alpha=smoothed_pixels);
        end

        function AC(obj, parameters)
        % Generates the circle-inside-cross target shape.
        %
        % Args:
        %   fname: Name of the image file, should end with .png.
        %   cross_width: Width of the cross arms.
        %   circle_radius: Radius of the inner circle.
        %
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
                parameters.circle_radius = fix(obj.radius/4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius-round(sqrt(obj.n_cycles)), obj.radius*2+1, parameters.cross_width);
            circle_pixels = obj.circle(parameters.circle_radius, obj.radius*2+1);
            im(cross_pixels)=1;
            im(circle_pixels)=0;
            smoothed_pixels = obj.smooth_edges(im);
            imwrite( ...
                ind2rgb(im, obj.color), ...
                fullfile(obj.dirpath, strcat('Fixation/', parameters.fname)), ...
                alpha=smoothed_pixels);
        end

        function BC(obj, parameters)
        % Generates the cross-inside-circle target shape.
        %
        % Args:
        %   fname: Name of the image file, should end with .png.
        %   cross_width: Width of the cross arms.
        %
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius*2+1);
            circle_pixels = obj.circle(obj.radius-round(sqrt(obj.n_cycles)), obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius, obj.radius*2+1, parameters.cross_width);
            im(circle_pixels)=1;
            im(cross_pixels)=0;
            smoothed_pixels = obj.smooth_edges(im);
            imwrite( ...
                ind2rgb(im, obj.color), ...
                fullfile(obj.dirpath, strcat('Fixation/', parameters.fname)), ...
                alpha=smoothed_pixels);
        end

        function ABC(obj, parameters)
        % Generates the circle-inside-cross-inside-circle target shape.
        %
        % Args:
        %   fname: Name of the image file, should end with .png.
        %   cross_width: Width of the cross arms.
        %   inner_circle_radius: Radius of the inner circle.
        %
            arguments 
                obj
                parameters.cross_width = fix(obj.radius/4)
                parameters.inner_circle_radius = fix(obj.radius/4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius*2+1);
            circle_pixels = obj.circle(obj.radius-round(sqrt(obj.n_cycles)), obj.radius*2+1);
            cross_pixels = obj.cross(obj.radius, obj.radius*2+1, parameters.cross_width);
            inner_circle_pixels = obj.circle(parameters.inner_circle_radius, obj.radius*2+1);
            im(circle_pixels)=1;
            im(cross_pixels)=0;
            im(inner_circle_pixels)=1;
            smoothed_pixels = obj.smooth_edges(im);
            imwrite( ...
                ind2rgb(im, obj.color), ...
                fullfile(obj.dirpath, strcat('Fixation/', parameters.fname)), ...
                alpha=smoothed_pixels);
        end
    end
    
    
    methods(Access=private)

        function smoothed_pixels = smooth_edges(obj, pixels)
            if obj.is_anti_aliasing
                smoothed_pixels = pixels;
                for i = 1:obj.n_cycles
                    smoothed_pixels = conv2(smoothed_pixels,[0,0,0;0,1,0;0,0,0]);
                    smoothed_pixels = obj.smooth(smoothed_pixels);
                end
                smoothed_pixels=smoothed_pixels(1+obj.n_cycles:end-obj.n_cycles,1+obj.n_cycles:end-obj.n_cycles);
            else
                smoothed_pixels = double(pixels);
            end
        end

    end


    methods(Static, Access=private)

        function circle_pixels = circle(radius, pixels_side)
            center_x = fix(pixels_side/2)+1;
            center_y = fix(pixels_side/2)+1;
            [columns, rows] = meshgrid(1:pixels_side, 1:pixels_side);
            circle_pixels = (rows - center_y).^2 ./ radius^2 ...
            + (columns - center_x).^2 ./ radius^2 <= 1;
        end

        function cross_pixels = cross(radius, pixels_side, width)
            center_x = fix(pixels_side/2)+1;
            center_y = fix(pixels_side/2)+1;
            img = zeros(pixels_side);
            img(center_y-radius:center_y+radius, center_x-width:center_x+width) = 1;
            img(center_y-width:center_y+width, center_x-radius:center_x+radius) = 1;
            cross_pixels = logical(img);
        end
        function rgb = hex2rgb(hex)
        % Transforms hexadecimal color code to MATLAB RGB color code.
            rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
        end

        function neighbours_mean=smooth(A)
            neighbours_mean = conv2(A,ones(3),'same')./conv2(ones(size(A)),ones(3),'same');
        end

    end

end

function mustBeHex(a)
    if ~regexp(a, "#[\d, A-F]{6}", 'ignorecase')
        error("Provided hex color is wrong.")
    end
end

