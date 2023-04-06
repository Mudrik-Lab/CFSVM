classdef MondrianGenerator < handle

    properties

        % Shape of the figures, currently available shapes are rectangle,
        % square, ellipse, circle, rhombus and 45_rotate_square.
        type
        % Mondrians will be generated inside dirpath/Masks/
        dirpath
        % Width of the generated image in pixels
        x_pixels
        % Height of the generated image in pixels
        y_pixels
        % Minimal possible radius in pixels of the type-shaped figure. Will
        % be calculated by radius=x(y)_pixels*min_fraction
        min_fraction
        % Maximal possible radius in pixels of the type-shaped figure. Will
        % be calculated by radius=x(y)_pixels*max_fraction
        max_fraction
        % Number of figures to generate per 1 Mondrian mask.
        n_figures
        % Colormap.
        cmap
        % Screen width in centimetres.
        s_w_cm
        % Screen width in pixels.
        s_w_pix
        % Screen height in centimetres.
        s_h_cm
        % Screen height in pixels.
        s_h_pix
        % Viewing distance in centimetres.
        view_dist
        % Whether physical propreties were provided.
        is_phys_props
    end
    
    methods
        function obj = MondrianGenerator(dirpath, parameters)
        %
        % Args:
        %   dirpath: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.dirpath`
        %   type: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.type`
        %   x_pixels: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.x_pixels`
        %   y_pixels: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.y_pixels`
        %   min_fraction: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.min_fraction`
        %   max_fraction: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.max_fraction`
        %   n_figures: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.n_figures`
        %   cmap: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.cmap`
        %

            arguments
                dirpath 
                parameters.type = 'rectangle'
                parameters.x_pixels = 512
                parameters.y_pixels = 512
                parameters.min_fraction = 1/100
                parameters.max_fraction = 1/8
                parameters.n_figures = 1000
                parameters.cmap = [1 1 1
                    0.75 0.75 0.75
                    0.5 0.5 0.5
                    0.25 0.25 0.25
                    0 0 0]
            end
            
            obj.dirpath = dirpath;
            if ~exist(fullfile(obj.dirpath,'Masks/'), 'dir')
                mkdir(fullfile(obj.dirpath,'Masks/'))
            end
            parameters_names = fieldnames(parameters);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end

        end

        function set_physical_properties( ...
            obj, ...
            screen_width_cm, ...
            screen_width_pixel, ...
            screen_height_cm, ...
            screen_height_pixel, ...
            viewing_distance_cm)
        % Sets display's physical properties for PSD calculation.
        % 
        % Args:
        %   screen_width_cm: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.s_w_cm`
        %   screen_width_pixel: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.s_w_pix`
        %   screen_height_cm: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.s_h_cm`
        %   screen_height_pixel: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.s_h_pix`
        %   viewing_distance_cm: :attr:`~.+CFSVM.@MondrianGenerator.MondrianGenerator.view_dist`
        %

            obj.s_w_cm = screen_width_cm;
            obj.s_w_pix = screen_width_pixel;
            obj.s_h_cm = screen_height_cm;
            obj.s_h_pix = screen_height_pixel;
            obj.view_dist = viewing_distance_cm;
            obj.is_phys_props = true;
        end

        function set_shades(obj, rgb_triplet, n_tones)
        % Creates MATLAB colormap gradient from white to
        % rgb_triplet color with n_tones between them.
        %
        % Args:
        %   rgb_triplet: [R,G,B] array where R,G,B ranges from 0 to 1.
        %   n_tones: Int describing number of color tones to create.
        %

            white = [1 1 1];
            obj.cmap = interp1([0 1],[white; rgb_triplet],linspace(0,1,n_tones),'linear');
        end
        

        generate(obj, n_images)
        set_cmap(obj, colormap, parameters)
        [freqs, psds] = get_psd(obj, img)
    end

    methods (Access=private)

        function mondrian = generate_mondrian(obj)
            
            switch obj.type
                case "rectangle"
                    random_figure = @obj.random_rect;
                    x_equal_y=false;
                case "square"
                    random_figure = @obj.random_rect;
                    x_equal_y=true;
                case "circle"
                    random_figure = @obj.random_ellipse;
                    x_equal_y=true;
                case "ellipse"
                    random_figure = @obj.random_ellipse;
                    x_equal_y=false;
                case "rhombus"
                    random_figure = @obj.random_rhombus;
                    x_equal_y=false;
                case "45_rotated_square"
                    random_figure = @obj.random_rhombus;
                    x_equal_y=true;
            end
            
            mondrian = zeros(obj.y_pixels, obj.x_pixels);
            for i = 1:obj.n_figures
                pixels = random_figure(x_equal_y);
                mondrian(pixels) = randi([0, height(obj.cmap)]);
            end
        end
        
        
        function rect_pixels = random_rect(obj, x_equal_y)
        
            if x_equal_y
                radius_x = obj.randomize_radius(min(obj.x_pixels, obj.y_pixels));
                radius_y = radius_x;
            else
                radius_x = obj.randomize_radius(obj.x_pixels);
                radius_y = obj.randomize_radius(obj.y_pixels);
            end
            center_x = randi([1, obj.x_pixels]);
            center_y = randi([1, obj.y_pixels]);
            function coord = check_coord(coord, max_value)
                if coord < 1
                    coord = 1;
                elseif coord > max_value
                    coord = max_value;
                end
            end
            x0 = check_coord(center_x-radius_x, obj.x_pixels);
            x1 = check_coord(center_x+radius_x, obj.x_pixels);
            y0 = check_coord(center_y-radius_y, obj.y_pixels);
            y1 = check_coord(center_y+radius_y, obj.y_pixels);
            img = zeros(obj.y_pixels, obj.x_pixels);
            img(x0:x1, y0:y1) = 1;
            rect_pixels = logical(img);
            
        end

        function rhombus_pixels = random_rhombus(obj, x_equal_y)

            if x_equal_y
                radius_x = obj.randomize_radius(min(obj.x_pixels, obj.y_pixels));
                radius_y = radius_x;
            else
                radius_x = obj.randomize_radius(obj.x_pixels);
                radius_y = obj.randomize_radius(obj.y_pixels);
            end

            center_x = randi([1, obj.x_pixels]);
            center_y = randi([1, obj.y_pixels]);
            R = [center_x-radius_x, center_y
                center_x, center_y-radius_y
                center_x+radius_x, center_y
                center_x, center_y+radius_y];
            [columns,rows] = meshgrid(1:obj.x_pixels,1:obj.y_pixels) ; 
            rhombus_pixels = inpolygon(columns,rows,R(:,1),R(:,2));
            
        end
        
        function ellipse_pixels = random_ellipse(obj, x_equal_y)
            
            [columns, rows] = meshgrid(1:obj.x_pixels, 1:obj.y_pixels);
            center_x = randi([1, obj.x_pixels]);
            center_y = randi([1, obj.y_pixels]);
            if x_equal_y
                radius = obj.randomize_radius(min(obj.x_pixels, obj.y_pixels));
                ellipse_pixels = (rows - center_y).^2 ...
                + (columns - center_x).^2 <= radius.^2;
            else
                radius_x = obj.randomize_radius(obj.x_pixels);
                radius_y = obj.randomize_radius(obj.y_pixels);
                ellipse_pixels = (rows - center_y).^2 ./ radius_y^2 ...
                + (columns - center_x).^2 ./ radius_x^2 <= 1;
            end 

        end
        
        function radius = randomize_radius(obj, pixels)
            radius = randi([ceil(pixels*obj.min_fraction), floor(pixels*obj.max_fraction)]);
        end

    end

    methods(Static, Access=private)

        function img_size_degree = pixels2degrees(img_size_pixels, s_cm, s_pix, view_dist)

            % cm/pix
            pixel_size = s_cm/s_pix;
            % mask size in cm
            img_size_cm = pixel_size * img_size_pixels;
            %mask size in degree of visual angle
            img_size_degree = 2 * rad2deg(atan(img_size_cm/(2 * view_dist)));
            
        end

    end

end

