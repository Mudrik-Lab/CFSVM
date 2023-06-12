classdef FixationGenerator < handle
    % Generates fixation targets.
    %
    % Supports 6 different shapes from Thaler et al., 2013.
    %

    properties (Access = private)
        dirpath
        radius
        is_anti_aliasing
        n_cycles
        color
        is_outline
    end

    methods

        function obj = FixationGenerator(dirpath, parameters)
            %
            % Args:
            %   dirpath (char|string): Fixation targets will be generated inside
            %       `dirpath/Fixation/`
            %   radius (int): Radius in pixels of the largest shape in the fixaiton.
            %   hex_color (char|string): Color of the fixation target
            %   is_smooth_edges (logical): Whether to smooth the jaggies.
            %   smoothing_cycles (int): Number of smoothing cycles.
            %   is_outline (logical): Whether to generate only an outline of the fixation.
            %
            arguments
                dirpath {mustBeTextScalar}
                parameters.radius {mustBeInteger, mustBePositive} = 256
                parameters.hex_color {mustBeHex} = '#000000'
                parameters.is_smooth_edges {mustBeNumericOrLogical} = false
                parameters.smoothing_cycles {mustBeInteger, mustBePositive} = 1
                parameters.is_outline = false
            end

            obj.dirpath = dirpath;
            if ~exist(fullfile(obj.dirpath, 'Fixation/'), 'dir')
                mkdir(fullfile(obj.dirpath, 'Fixation/'));
            end
            obj.radius = parameters.radius;
            obj.is_anti_aliasing = parameters.is_smooth_edges;
            if obj.is_anti_aliasing
                obj.n_cycles = parameters.smoothing_cycles;
            else
                obj.n_cycles = 0;
            end
            obj.color = CFSVM.Utils.hex2rgb(parameters.hex_color);
            obj.is_outline = parameters.is_outline;
        end

        function A(obj, parameters)
            % Generates the circular target shape.
            %
            % Args:
            %   fname (char|string): Name of the image file, should end with ``.png``.
            %
            arguments
                obj
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius * 2 + 1);
            pixels = obj.circle(obj.radius - round(sqrt(obj.n_cycles)), obj.radius * 2 + 1);
            obj.generate(im, pixels, parameters.fname);

        end

        function C(obj, parameters)
            % Generates the cross target shape.
            %
            % Args:
            %   fname (char|string): Name of the image file, should end with ``.png``.
            %   cross_width (int): Width of the cross arms in pixels.
            %
            arguments
                obj
                parameters.cross_width = fix(obj.radius / 4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius * 2 + 1);
            pixels = obj.cross(obj.radius - round(sqrt(obj.n_cycles)), obj.radius * 2 + 1, parameters.cross_width);
            obj.generate(im, pixels, parameters.fname);
        end

        function AB(obj, parameters)
            % Generates the circle-inside-circle target shape.
            %
            % Args:
            %   fname (char|string): Name of the image file, should end with ``.png``.
            %   inner_circle_radius (int): Radius of the inner circle.
            %
            arguments
                obj
                parameters.inner_circle_radius = fix(obj.radius / 4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius * 2 + 1);
            circle_pixels = obj.circle(obj.radius - round(sqrt(obj.n_cycles)), obj.radius * 2 + 1);
            inner_circle_pixels = obj.circle(parameters.inner_circle_radius, obj.radius * 2 + 1);
            pixels = circle_pixels - inner_circle_pixels;
            obj.generate(im, pixels, parameters.fname);
        end

        function AC(obj, parameters)
            % Generates the circle-inside-cross target shape.
            %
            % Args:
            %   fname (char|string): Name of the image file, should end with ``.png``.
            %   cross_width (int): Width of the cross arms.
            %   circle_radius (int): Radius of the inner circle.
            %
            arguments
                obj
                parameters.cross_width = fix(obj.radius / 4)
                parameters.circle_radius = fix(obj.radius / 4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius * 2 + 1);
            cross_pixels = obj.cross(obj.radius - round(sqrt(obj.n_cycles)), obj.radius * 2 + 1, parameters.cross_width);
            circle_pixels = obj.circle(parameters.circle_radius, obj.radius * 2 + 1);
            pixels = cross_pixels - circle_pixels;
            obj.generate(im, pixels, parameters.fname);
        end

        function BC(obj, parameters)
            % Generates the cross-inside-circle target shape.
            %
            % Args:
            %   fname (char|string): Name of the image file, should end with ``.png``.
            %   cross_width (int): Width of the cross arms.
            %
            arguments
                obj
                parameters.cross_width = fix(obj.radius / 4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius * 2 + 1);
            circle_pixels = obj.circle(obj.radius - round(sqrt(obj.n_cycles)), obj.radius * 2 + 1);
            cross_pixels = obj.cross(obj.radius, obj.radius * 2 + 1, parameters.cross_width);
            pixels = circle_pixels - cross_pixels;
            obj.generate(im, pixels, parameters.fname);
        end

        function ABC(obj, parameters)
            % Generates the circle-inside-cross-inside-circle target shape.
            %
            % Args:
            %   fname (char|string): Name of the image file, should end with ``.png``.
            %   cross_width (int): Width of the cross arms.
            %   inner_circle_radius (int): Radius of the inner circle.
            %
            arguments
                obj
                parameters.cross_width = fix(obj.radius / 4)
                parameters.inner_circle_radius = fix(obj.radius / 4)
                parameters.fname = 'fixation.png'
            end
            im = zeros(obj.radius * 2 + 1);
            circle_pixels = obj.circle(obj.radius - round(sqrt(obj.n_cycles)), obj.radius * 2 + 1);
            cross_pixels = obj.cross(obj.radius, obj.radius * 2 + 1, parameters.cross_width);
            inner_circle_pixels = obj.circle(parameters.inner_circle_radius, obj.radius * 2 + 1);
            pixels = circle_pixels - cross_pixels + inner_circle_pixels;

            obj.generate(im, pixels, parameters.fname);
        end

    end

    methods (Access = private)

        function generate(obj, im, pixels, fname)

            pixels(pixels < 0) = 0;
            pixels = logical(pixels);

            if obj.is_outline
                pixels = bwmorph(pixels, 'remove');
            end
            im(pixels) = 1;
            smoothed_pixels = obj.smooth_edges(im);
            imwrite( ...
                    ind2rgb(im, obj.color), ...
                    fullfile(obj.dirpath, strcat('Fixation/', fname)), ...
                    alpha = smoothed_pixels);
        end

        function smoothed_pixels = smooth_edges(obj, pixels)
            if obj.is_anti_aliasing
                smoothed_pixels = pixels;
                for i = 1:obj.n_cycles
                    smoothed_pixels = conv2(smoothed_pixels, [0, 0, 0; 0, 1, 0; 0, 0, 0]);
                    smoothed_pixels = obj.smooth(smoothed_pixels);
                end
                smoothed_pixels = smoothed_pixels(1 + obj.n_cycles:end - obj.n_cycles, 1 + obj.n_cycles:end - obj.n_cycles);
            else
                smoothed_pixels = double(pixels);
            end
            smoothed_pixels = smoothed_pixels / max(smoothed_pixels, [], 'all');
        end

    end

    methods (Static, Access = private)

        function circle_pixels = circle(radius, pixels_side)
            center_x = fix(pixels_side / 2) + 1;
            center_y = fix(pixels_side / 2) + 1;
            [columns, rows] = meshgrid(1:pixels_side, 1:pixels_side);
            circle_pixels = (rows - center_y).^2 ./ radius^2 + (columns - center_x).^2 ./ radius^2 <= 1;
        end

        function cross_pixels = cross(radius, pixels_side, width)
            center_x = fix(pixels_side / 2) + 1;
            center_y = fix(pixels_side / 2) + 1;
            img = zeros(pixels_side);
            img(center_y - radius:center_y + radius, center_x - width:center_x + width) = 1;
            img(center_y - width:center_y + width, center_x - radius:center_x + radius) = 1;
            cross_pixels = logical(img);
        end

        function neighbours_mean = smooth(a)
            neighbours_mean = conv2(a, ones(3), 'same') ./ conv2(ones(size(a)), ones(3), 'same');
        end

    end

end

function mustBeHex(hex)
    a = char(hex);
    if length(a) ~= 7
        error("Length is wrong, Hex code should be a '#' followed by exactly 6 hexadecimal numbers");
    end
    if a(1) ~= '#'
        error("Hex code should start with a '#'");
    end
    if isempty(regexp(a, "#[\d, A-F]{6}", 'ignorecase'))
        error("Provided hex color is wrong.");
    end
end
