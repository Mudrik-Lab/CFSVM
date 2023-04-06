classdef MondrianGenerator < handle

    properties(Access=private)
        type
        dirpath
        x_pixels
        y_pixels
        min_fraction
        max_fraction
        n_figures
        cmap
        s_w_cm
        s_w_pix
        s_h_cm
        s_h_pix
        view_dist
        is_phys_props
    end
    
    methods
        function obj = MondrianGenerator(dirpath, parameters)
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

            obj.s_w_cm = screen_width_cm;
            obj.s_w_pix = screen_width_pixel;
            obj.s_h_cm = screen_height_cm;
            obj.s_h_pix = screen_height_pixel;
            obj.view_dist = viewing_distance_cm;
            obj.is_phys_props = true;
        end

        function set_shades(obj, rgb_triplet, n_tones)
            white = [1 1 1];
            obj.cmap = interp1([0 1],[white; rgb_triplet],linspace(0,1,n_tones),'linear');
        end
        

        generate(obj, n_images)
        set_cmap(obj, colormap, parameters)
        [freqs, psds] = get_psd(obj, img)
    end

    methods (Access=private)

        function mondrian = generate_mondrian(obj)
    
            if obj.type=="rectangle"
                random_figure = @obj.random_rect;
            elseif obj.type=="circle"
                random_figure = @obj.random_circle;
            elseif obj.type=="ellipse"
                random_figure = @obj.random_ellipse;
            end
            
            mondrian = zeros(obj.y_pixels, obj.x_pixels);
            for i = 1:obj.n_figures
                pixels = random_figure();
                mondrian(pixels) = randi([0, height(obj.cmap)]);
            end
        end
        
        
        function square_pixels = random_rect(obj)
        
            radius_x = obj.randomize_radius(obj.x_pixels);
            radius_y = obj.randomize_radius(obj.y_pixels);
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
            square_pixels = logical(img);
            
        end
        
        function circle_pixels = random_circle(obj)
            [columns, rows] = meshgrid(1:obj.x_pixels, 1:obj.y_pixels);
            radius = obj.randomize_radius(min(obj.x_pixels, obj.y_pixels));
            center_x = randi([1, obj.x_pixels]);
            center_y = randi([1, obj.y_pixels]);
            circle_pixels = (rows - center_y).^2 ...
                + (columns - center_x).^2 <= radius.^2;
        end
        
        function ellipse_pixels = random_ellipse(obj)
            [columns, rows] = meshgrid(1:obj.x_pixels, 1:obj.y_pixels);
            radius_x = obj.randomize_radius(obj.x_pixels);
            radius_y = obj.randomize_radius(obj.y_pixels);
            center_x = randi([1, obj.x_pixels]);
            center_y = randi([1, obj.y_pixels]);
            ellipse_pixels = (rows - center_y).^2 ./ radius_y^2 ...
                + (columns - center_x).^2 ./ radius_x^2 <= 1;
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

