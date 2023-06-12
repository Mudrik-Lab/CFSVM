classdef CheckFrame < CFSVM.Element.SpatialElement
    % Handling checkframes on the screen.
    %
    % Derived from :class:`~CFSVM.Element.SpatialElement`.
    %

    properties

        % Int - length in pixels of every checker rectangle in the checkframe.
        checker_length {mustBeNonnegative, mustBeInteger}
        % Int - width in pixels of every checker rectangle in the checkframe.
        checker_width {mustBeNonnegative, mustBeInteger}
        % Cell array of chars contating HEX color codes
        % e.g. {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'}
        % Red-Green {'#00FF00', '#FF0000'}
        % White-Black {'#FFFFFF', '#000000'}
        color_codes cell
        % A matrix of size (4,N) for N=number of checkers.
        rects {mustBeReal}
        % A matrix of size (3,N) for N=number of checkers
        colors {mustBeInRange(colors, 0, 1)}

    end

    methods

        function obj = CheckFrame(kwargs)
            %
            % Args:
            %   checker_length:
            %       :attr:`~CFSVM.Element.Screen.CheckFrame.checker_length`.
            %       Defaults to 30.
            %   checker_width:
            %       :attr:`~CFSVM.Element.Screen.CheckFrame.checker_width`.
            %       Defaults to 15.
            %   hex_colors:
            %       :attr:`~CFSVM.Element.Screen.CheckFrame.color_codes`.
            %       Defaults to {}.
            %
            arguments
                kwargs.checker_length = 30
                kwargs.checker_width = 15
                kwargs.hex_colors = {}
            end

            obj.checker_length = kwargs.checker_length;
            obj.checker_width = kwargs.checker_width;
            if ~isempty(kwargs.hex_colors)
                % Convert hex codes to matlab RGB codes.
                obj.color_codes = cellfun(@(hex) (sscanf(hex(2:end), '%2x%2x%2x', [1 3]) / 255)', ...
                                          kwargs.hex_colors, ...
                                          UniformOutput = false);
            end

        end

        function initiate(obj, screenfield)
            % Initiates checkframe for a screenfield by generating
            % rects and colors matrices.
            %
            % Args:
            %   screenfield: :class:`~CFSVM.Element.Screen.ScreenField` object.
            %

            screen_rect = screenfield.rect;

            % Correct screen rect for the checker width before calculating rects and colors
            screen_rect(1:2) = screenfield.rect(1:2) - obj.checker_width;
            screen_rect(3:4) = screenfield.rect(3:4) + obj.checker_width;

            [rects, colors] = obj.rects_and_colors(screen_rect);

            obj.rects = cat(2, obj.rects, rects);
            obj.colors = cat(2, obj.colors, colors);

        end

        function reset(obj)
            % Empties rect and color props.
            %

            obj.rects = [];
            obj.colors = [];

        end

    end

    methods (Access = protected)

        function [rects, colors] = rects_and_colors(obj, screen_rect)
            % Calculates rectangles [x0,y0,x1,y1] and their colors for a checkframe.
            %
            % Args:
            %   screen_rect: [x0, y0, x1, y1] array with pixel positions.
            %
            % Returns:
            %   [4xN matrix, 3xN matrix]: two matrices:
            %
            %   - 4xN matrix describing rectangle of every checker.
            %   - 3xN matrix describing RGB color of every checker.
            %

            % Get coordinates from the provided screen rectangle.
            rect_cell = num2cell(screen_rect);
            [x0, y0, x1, y1] = rect_cell{:};

            % Calculate lengths of X and Y axes.
            dx = x1 - x0;
            dy = y1 - y0;

            % Get checker length for horizontal and vertical frame edges so that there
            % an int number of the checkers.
            hor_checker_length = obj.nearest_divisor_of_n_to_m(dx, obj.checker_length);
            vert_checker_length = obj.nearest_divisor_of_n_to_m(dy, obj.checker_length);

            % Get number of checkers for horizontal and vertical edges.
            number_of_x_checkers = dx / hor_checker_length;
            number_of_y_checkers = dy / vert_checker_length;

            % Get checker rectangles for every edge of the frame.
            top_rects = obj.get_edge_checker_rects(x0, hor_checker_length, ...
                                                   obj.checker_width, number_of_x_checkers, y0, 0);
            bottom_rects = obj.get_edge_checker_rects(x0, hor_checker_length, ...
                                                      obj.checker_width, number_of_x_checkers, y1 - obj.checker_width, 0);
            left_rects = obj.get_edge_checker_rects(y0, vert_checker_length, ...
                                                    obj.checker_width, number_of_y_checkers, screen_rect(1), 1);
            right_rects = obj.get_edge_checker_rects(y0, vert_checker_length, ...
                                                     obj.checker_width, number_of_y_checkers, x1 - obj.checker_width, 1);

            % Get matrix of color codes for the checker rectangles.
            hor_rgb = zeros(3, number_of_x_checkers);
            vert_rgb = zeros(3, number_of_y_checkers);
            ncolors = length(obj.color_codes);
            for i = 1:ncolors
                hor_rgb(:, i:ncolors:end) = repmat(obj.color_codes{i}, 1, length(hor_rgb(:, i:ncolors:end)));
                vert_rgb(:, i:ncolors:end) = repmat(obj.color_codes{i}, 1, length(vert_rgb(:, i:ncolors:end)));
            end

            % Concatenate edges of the frame
            rects = cat(2, top_rects, left_rects, right_rects, bottom_rects);
            % checker_colors = cat(2, hor_rgb, vert_rgb, flip(vert_rgb, 2), flip(hor_rgb,2));
            colors = cat(2, hor_rgb, vert_rgb, vert_rgb, hor_rgb);
        end

    end
    methods (Static)

        function rects = get_edge_checker_rects(start_coord, checker_length, checker_width, number_of_checkers, edge_shift, is_y)
            % Calculates edge rects, given start_coord of the edge, checker parameters,
            % edge shift and boolean is_y if the edge is vertical.

            coord00 = start_coord:checker_length:start_coord + checker_length * (number_of_checkers - 1);
            coord10 = zeros(1, number_of_checkers) + edge_shift;
            coord01 = coord00 + checker_length;
            coord11 = coord10 + checker_width;
            if is_y == 0
                rects = [coord00; coord10; coord01; coord11];
            else
                rects = [coord10; coord00; coord11; coord01];
            end

        end

        function c = nearest_divisor_of_n_to_m(n, m)
            % Given two whole numbers, n and m, finds a third whole number c
            % that holds n_mod_c==0 and has the minimal abs(c-m).

            % Find all divisors of N
            K = 1:ceil(sqrt(n));
            D = K(rem(n, K) == 0);
            D = [D sort(n ./ D)];

            % Find nearest of the divisors to m
            dist = abs(D - m);
            c = max(D(dist == min(dist)));

        end

    end

end
