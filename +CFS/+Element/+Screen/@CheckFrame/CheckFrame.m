classdef CheckFrame < CFS.Element.SpatialElement
    %CheckFrame Class for handling checkframes on the screen.
    % CheckFrame Properties:
    %   checker_length - length in pixels of every checker rectangle in the checkframe.
    %   checker_width - width in pixels of every checker rectangle in the checkframe.
    %   color_codes - checkframe colors in hexadecimal color code
    %   rects - matrix with checker rectangle coordinates.
    %   colors - matrix with checker rectangle colors.
    
    properties
        % Length in pixels of every checker rectangle in the checkframe.
        checker_length
        % Width in pixels of every checker rectangle in the checkframe.
        checker_width
        % Checkframe colors in hexadecimal color code (check this in google)
        % Cell array of character vectors, e.g. {'#0072BD', '#D95319', '#EDB120', '#7E2F8E'}
        % Red-Green {'#00FF00', '#FF0000'}
        % White-Black {'#FFFFFF', '#000000'}
        color_codes

    end
    
    methods
        
        function obj = CheckFrame(parameters)
            %CheckFrame Constructs an instance of this class
            % Gets optional keyword arguments:
            % checker_length
            % checker_width
            % hex_colors - cell array of character vectors, e.g. {'#FFFFFF', '#000000'}
            arguments
                parameters.checker_length = 30
                parameters.checker_width = 15
                parameters.hex_colors = {'#FFFFFF', '#000000'}
            end
            obj.checker_length = parameters.checker_length;
            obj.checker_width = parameters.checker_width;
            % Convert hex codes to matlab RGB codes.
            obj.color_codes = cellfun(@(hex) (sscanf(hex(2:end), '%2x%2x%2x', [1 3])/255)', ...
                parameters.hex_colors, ...
                UniformOutput=false);
        end
        
        initiate(obj, screen)

    end

    methods (Access = protected)
        [rects, colors] = rects_and_colors(obj, screen_rect)
    end

end

