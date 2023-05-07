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
        
        function obj = CheckFrame(parameters)
        %
        % Args:
        %   checker_length: :attr:`~CFSVM.Element.Screen.CheckFrame.checker_length`
        %   checker_width: :attr:`~CFSVM.Element.Screen.CheckFrame.checker_width`
        %   hex_colors: :attr:`~CFSVM.Element.Screen.CheckFrame.color_codes`
        %
            arguments
                parameters.checker_length = 30
                parameters.checker_width = 15
                parameters.hex_colors = {}
            end

            obj.checker_length = parameters.checker_length;
            obj.checker_width = parameters.checker_width;
            if ~isempty(parameters.hex_colors)
                % Convert hex codes to matlab RGB codes.
                obj.color_codes = cellfun(@(hex) (sscanf(hex(2:end), '%2x%2x%2x', [1 3])/255)', ...
                    parameters.hex_colors, ...
                    UniformOutput=false);
            end

        end
        
        initiate(obj, screen)
        reset(obj)
    end

    methods (Access = protected)
        [rects, colors] = rects_and_colors(obj, screen_rect)
    end

end

