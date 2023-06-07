classdef (Abstract) Stimulus < CFSVM.Element.TemporalElement & CFSVM.Element.SpatialElement
% A base class for different types of stimuli.
%
% Derived from :class:`~CFSVM.Element.TemporalElement` and 
% :class:`~CFSVM.Element.SpatialElement` classes.
%
    
    properties
        % Char array for path to directory in which stimuli are stored.
        dirpath {mustBeTextScalar} = '.'
        % Char array. One of 'UpperLeft', 'Top', 'UpperRight', 'Left',
        % 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'
        position {mustBeMember(position, { ...
                    'UpperLeft', 'Top', 'UpperRight', 'Left', 'Center', 'Right', 'LowerLeft', 'Bottom', 'LowerRight'})} = "Center"
        % Nonnegative float describing x/y of the stimulus image.
        xy_ratio {mustBeNonnegative}
        % Float between 0 and 1, when 0 is not shown and 1 fills whole 
        % :class:`~CFSVM.Element.Screen.ScreenField` object.
        size  {mustBeInRange(size, 0, 1)}
        % Float between 0 and 1, when 0 alignment to the frame and 1 is
        % alignment to the center of the :class:`~CFSVM.Element.Stimulus.Fixation`.
        padding {mustBeInRange(padding, 0, 1)}
        % Float describing degrees of rotation.
        rotation {mustBeReal}
        % Int describing current image (by position in the folder)
        index {mustBeNonnegative, mustBeInteger}
        % Struct with fields PTB_indices - cell array with PTB textures indices,
        % images_names - cell array of chars, len - number of textures.
        textures
        % Cell array of chars with name of current image.
        image_name cell {mustBeText}
        % Float in seconds for showing blank screen after the stimulus presentation,
        % has the effect in only very specific cases.
        blank {mustBeNonnegative}
        % [x0, y0, x1, y1] array - manually entered stimulus position
        % inside the screen fields. Will override position, size, padding
        % and xy_ratio.
        manual_rect {mustBeInteger}
    end

   
    methods

        function new_rectangle = get_rect(obj, screen_rectangle)
        % Returns array with pixels coordinates for the new_rectangle in a
        % given screen_rectangle, new_rectangle alignment, its size, padding and its X to Y ratio.
        %
        % Args:
        %   screen_rectangle: [x0, y0, x1, y1] array with pixel positions.
        %
        % Returns:
        %   [x0, y0, x1, y1]: resized and positioned rectangle array.
        %
            
        
            % Extract coordinates from the provided screen rectangle.
            rect_cell = num2cell(screen_rectangle);
            [x0, y0, x1, y1] = rect_cell{:};
        
            % Get length of X axis in pixels.
            dx = x1-x0;
            % Get length of Y axis in pixels.
            dy = y1-y0;
            % Get remainder of subtraction between lengths of Y and X axes.
            rem = dy-dx;
        
            % Set rectangle with proper size and x to y ratio.
            unmoved_rect = [0,0,dx*obj.size,dx*obj.size/obj.xy_ratio];
            
        
            % Calculate shift from 0 to 1 of every coordinate of the new_rectangle given the provided stimulus alignment.
            [m0, n0, m1, n1, i, j] = obj.get_stimulus_rect_shift(obj.position);
        
            % Calculate X axis center of the new_rectangle.
            x_center = mean([x0+m0*dx, x0+m1*dx]);
            % Calculate Y axis center of the new_rectangle.
            y_center = mean([y0+n0*dy-(1-i)*(1-n0)*rem/2, y0+n1*dy-(3-i)*n1*rem/2]);
            
            % Get the new rectangle
            new_rectangle = round(CenterRectOnPoint(unmoved_rect, x_center, y_center));
        end


        function new_rectangle = get_manual_rect(obj, screen_rectangle)
            x0 = screen_rectangle(1)+obj.manual_rect(1);
            y0 = screen_rectangle(2)+obj.manual_rect(2);
            x1 = screen_rectangle(1)+obj.manual_rect(3);
            y1 = screen_rectangle(2)+obj.manual_rect(4);
            new_rectangle = [x0,y0,x1,y1];
        end


        function import_images(obj, window, parameters)
        % Loads images from the provided path and makes an array of PTB textures from it.
        %
        % Args:
        %   window: PTB window object.
        %   images_number: (Optional) Number of textures to create.
        %
            arguments
        
                obj
                window
                parameters.images_number
        
            end
            
            % Load filenames, remove dots and sort naturally.
            images = CFSVM.Utils.natsortfiles(dir(obj.dirpath), [], 'rmdot');
            
            % If the 'images_number' argument was provided, 
            % then create textures only for the first 'images_number' images.
            % Else create textures for every image in the folder.
            if isfield(parameters, 'images_number')
                n = parameters.images_number;
                % Duplicate images if there is not enough in the folder.
                if length(images) < n
                    images = repmat(images, 1, fix(n/length(images)));
                end
            else
                n = length(images);
            end
            
            % For every image read it and make PTB texture, ignore files that are
            % not images.
            for img_index = 1:n
                try
                    fullp = fullfile(images(img_index).folder, images(img_index).name);
                    [~, ~, ext] = fileparts(fullp);
                    if ext == ".png"
                        [image, ~, alpha] = imread(fullp);
                        if ~isempty(alpha)
                            image(:, :, 4) = alpha;
                        end
                    else
                        image = imread(fullp);
                    end
                    obj.textures.PTB_indices{img_index} = Screen('MakeTexture', window, image);
                    obj.textures.images_names{img_index} = images(img_index).name;
                catch
                end
            end
        
            % Get number of textures created. 
            obj.textures.len = length(obj.textures.PTB_indices);
        
        end
        
    end

    methods (Access=protected)

        function [x0, y0, x1, y1, ir, ic] = get_stimulus_rect_shift(obj, position)
        % Calculates fractional shift for every coordinate of a rectangle based on given parameters.
        %
        % If you define the rectangle position by the upper left and lower right 
        % verticies (as the PTB does), you may see that positions with the same
        % row indicies will have the same Y coordinates and those with the same
        % column indicied will have the same X coordinates.
        %
        % Args:
        %   position: Char array describing a ninth of a screen.
        %
        % Returns:
        %   [x0, y0, x1, y1, ir, ic]: Array containing:
        %
        %   - x0: Float describing correction to the x0 coordinate.
        %   - y0: Float describing correction to the y0 coordinate.
        %   - x1: Float describing correction to the x1 coordinate.
        %   - y1: Float describing correction to the y1 coordinate.
        %   - ir: Int describing row position in a position matrix.
        %   - ic: Int describing column position in a position matrix.
        
            % If size greater-or-equal to half of the screen, padding doesn't matter. 
            if obj.size >= 0.5
                obj.padding = 0;
            end
            
            % Position matrix.
            s = ["UpperLeft" "Top" "UpperRight";
                "Left" "Center" "Right";
                "LowerLeft" "Bottom" "LowerRight"];
        
            % Get matrix coordinates of the provided alignment.
            [ir, ic] = find(s == position);
            % Calculate X axis coordinates.
            [x0, x1] = obj.coord_shift(ic, obj.size, obj.padding);
            % Calculate Y axis coordinates
            [y0, y1] = obj.coord_shift(ir, obj.size, obj.padding);
        end
        
        

    end

    methods(Static, Access=protected)
        function [coord0, coord1] = coord_shift(index, size, padding)
        % Calculates actual shifts for the provided index.
            switch index
                case 1
                    coord0 = (0.5-size)*padding;
                    coord1 = 0.5-(0.5-size)*(1-padding);
                case 2
                    coord0 = (1-size)/2;
                    coord1 = (1+size)/2;
                case 3
                    coord0 = 0.5+(0.5-size)*(1-padding);
                    coord1 = 1-(0.5-size)*padding;
            end
        end
    end
    
end

