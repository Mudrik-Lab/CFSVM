classdef (Abstract) CFS < handle
    %CFS The interface class for three types of Continuous Flash Suppression
    %experiments: Breaking-CFS, Visual Priming and Visual Adaptation.
    % These are implemented in subclasses BCFS, VPCFS and VACFS, respectively.
    %
    % CFS Properties:
    %
    % CFS Methods:

    
    properties (Access = protected)
        vbl % Timestamp for internal use.
    end

    methods (Abstract)
        run_the_experiment(obj)
    end

    methods (Abstract, Access = protected)
        load_parameters(obj)
    end

    methods (Access = protected)
        
        initiate(obj)
        initiate_window(obj)
        show_introduction_screen(obj)
        show_rest_screen(obj)
        flash(obj)
        
    end
    
    methods (Hidden)
        function varargout = findobj(O,varargin)
            varargout = findobj@handle(O,varargin{:});
        end
        function varargout = findprop(O,varargin)
            varargout = findprop@handle(O,varargin{:});
        end
        function varargout = addlistener(O,varargin)
            varargout = addlistener@handle(O,varargin{:});
        end
        function varargout = notify(O,varargin)
            varargout = notify@handle(O,varargin{:});
        end
        function varargout = listener(O,varargin)
            varargout = listener@handle(O,varargin{:});
        end
        function varargout = delete(O,varargin)
            varargout = delete@handle(O,varargin{:});
        end
    end

end

