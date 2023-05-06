classdef MondrianGenerator < handle
% Generates Mondrian masks for CFS experiments.
%
% Supports shapes, like rectangles, circles, rhombi and more.
% Calculates PSDs for every mondrians if screen physical properties are
% set.
%

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
        % Colormap. Either one of the supported colormaps by 
        % :meth:`~CFSVM.Generators.MondrianGenerator.set_cmap` or MATLAB-styled RGB array.
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
        %   dirpath (char|string): :attr:`~CFSVM.Generators.MondrianGenerator.dirpath`
        %   type (char|string): :attr:`~CFSVM.Generators.MondrianGenerator.type`
        %   x_pixels (int): :attr:`~CFSVM.Generators.MondrianGenerator.x_pixels`
        %   y_pixels (int): :attr:`~CFSVM.Generators.MondrianGenerator.y_pixels`
        %   min_fraction (double): :attr:`~CFSVM.Generators.MondrianGenerator.min_fraction`
        %   max_fraction (double): :attr:`~CFSVM.Generators.MondrianGenerator.max_fraction`
        %   n_figures (int): :attr:`~CFSVM.Generators.MondrianGenerator.n_figures`
        %   cmap (double array|char|string): :attr:`~CFSVM.Generators.MondrianGenerator.cmap`
        %

            arguments
                dirpath 
                parameters.type = 'rectangle'
                parameters.x_pixels = 512
                parameters.y_pixels = 512
                parameters.min_fraction = 1/100
                parameters.max_fraction = 1/8
                parameters.n_figures = 100
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

            if isstring(obj.cmap) || ischar(obj.cmap)
                obj.set_cmap(obj.cmap);
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
        %   screen_width_cm (double): :attr:`~CFSVM.Generators.MondrianGenerator.s_w_cm`
        %   screen_width_pixel (int): :attr:`~CFSVM.Generators.MondrianGenerator.s_w_pix`
        %   screen_height_cm (double): :attr:`~CFSVM.Generators.MondrianGenerator.s_h_cm`
        %   screen_height_pixel (int): :attr:`~CFSVM.Generators.MondrianGenerator.s_h_pix`
        %   viewing_distance_cm (double): :attr:`~CFSVM.Generators.MondrianGenerator.view_dist`
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
        %   rgb_triplet (double array): [R,G,B] array where R,G,B ranges from 0 to 1.
        %   n_tones (int): Number of color tones to create.
        %

            white = [1 1 1];
            obj.cmap = interp1([0 1], [white; rgb_triplet], linspace(0,1,n_tones), 'linear');
        end
        
        function set_cmap(obj, colormap, parameters)
        % Will generate MATLAB colormap gradient from white to
        % rgb_triplet color with n_tones.
        %
        % Args:
        %   colormap: One of 'grayscale', 'reds', 'blues', 'greens', 'rgb',
        %       'original'.
        %   n_tones: (Optional) Int describing number of color tones to create,
        %       relevant only for shades colormaps
        %
            
            arguments
                obj
                colormap
                parameters.n_tones = 8
            end
            if strcmpi('grayscale', colormap)
                obj.set_shades([0,0,0], parameters.n_tones);
            elseif strcmpi('reds', colormap)
                obj.set_shades([1,0,0], parameters.n_tones);
            elseif strcmpi('blues', colormap)
                obj.set_shades([0,0,1], parameters.n_tones);
            elseif strcmpi('greens', colormap)
                obj.set_shades([0,1,0], parameters.n_tones);
            else
                switch lower(colormap)
                    case 'rgb'
                        obj.cmap = [1 0 0
                            0 1 0
                            0 0 1];
                    case 'original'
                        obj.cmap = [1 1 1
                            1 0 0
                            0 1 0
                            0 0 1
                            1 1 0
                            1 0 1
                            0 1 1
                            0 0 0];
                end
            end
        end

        function generate(obj, n_images, parameters)
        % Generates and saves Mondrians.
        %
        % Args:
        %   n_images: Int number of Mondrians to generate.
        %
            arguments
                obj
                n_images
                parameters.fname = 'mondrian.png'
            end
            [~,name, ext] = fileparts(parameters.fname);
            w = waitbar(0, 'Starting');
            psds_matrix = [];
            for m = 1:n_images
                waitbar(m/n_images, w, sprintf('Generating Mondrians: %d %%', floor(m/n_images*100)));
                mondrian = obj.generate_mondrian();
                if obj.is_phys_props
                    [freqs, psds] = obj.get_psd(mondrian);
                    psds_matrix = [psds_matrix, psds];
                end
                imwrite(ind2rgb(mondrian, obj.cmap), fullfile(obj.dirpath, sprintf('Masks/%s_%d%s', name, m, ext)))
            end
            if obj.is_phys_props
                T = array2table([freqs, psds_matrix]);
                T.Properties.VariableNames(1:n_images+1) = ["freqs", arrayfun(@(s)(sprintf('%s_%d%s', name, s, ext)), 1:n_images, UniformOutput=false)];
                writetable(T,fullfile(obj.dirpath, 'mondrians_psds.csv'))
                f = figure('visible','off');
                semilogy(freqs, mean(psds_matrix, 2))
                title('Average PSD of generated Mondrians')
                xlabel('Spatial frequency [CPD]')
                ylabel('PSD')
                exportgraphics(f,fullfile(obj.dirpath, 'average_mondrians_psd.png'))
            end
            close(w);
        end
        
        function [freqs, psds] = get_psd(obj, img)
        %
        %
        % Args:
        %   img: [x_pixels, y_pixels, n_colors] array - img to calculate psd from.
        %
        % Returns:
        %   [freqs, psds]: two arrays with length=n_freqs.
        %
        
            [row,col] = size(img);
            gray_img = im2gray(img);
            max_dim = max(row, col);
            imgfft = fftshift(fft2(gray_img, max_dim, max_dim));
            power = abs(imgfft./((max_dim).^2)).^2 ;
            [XX,YY] = meshgrid(-max_dim/2:max_dim/2-1,-max_dim/2:1:max_dim/2-1);
            spatial_map = round(sqrt((XX).^2 + (YY).^2));
            max_rad = max(max(spatial_map));
            psds = zeros(max_rad,1);
            for i = 1:max_rad
                index = spatial_map == i;
                psds(i) = sum(power(index),'all')./sum(index,'all');
            end
            width_degree = obj.pixels2degrees(width(img), obj.s_w_cm, obj.s_w_pix, obj.view_dist);
            height_degree = obj.pixels2degrees(height(img),obj.s_h_cm,obj.s_h_pix, obj.view_dist);
            freqs = (0:max_rad-1)';
            freqs = freqs./ max(width_degree, height_degree);
        end

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
            img(y0:y1, x0:x1) = 1;
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
            % mask size in degree of visual angle
            img_size_degree = 2 * rad2deg(atan(img_size_cm/(2 * view_dist)));
            
        end

    end

end

