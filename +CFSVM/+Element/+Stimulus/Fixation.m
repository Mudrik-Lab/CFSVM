classdef Fixation < CFSVM.Element.Stimulus.Stimulus
% Handling fixation cross.
%
% Derived from :class:`~CFSVM.Element.TemporalElement` and 
% :class:`~CFSVM.Element.SpatialElement` classes.
%

    properties (Constant)

        % Parameters to parse into the processed results table.
        RESULTS = {'onset'}

    end


    properties
        
        % Cell array storing arguments for PTB's Screen('DrawLines'). 
        args cell

    end


    methods

        function obj = Fixation(dirpath, kwargs)
        %
        % Args:
        %   dirpath: :attr:`~CFSVM.Element.Stimulus.Stimulus.dirpath`.
        %   duration: :attr:`~CFSVM.Element.TemporalElement.duration`.
        %       Defaults to 0.
        %   position: :attr:`~CFSVM.Element.Stimulus.Stimulus.position`.
        %       Defaults to "Center".
        %   xy_ratio: :attr:`~CFSVM.Element.Stimulus.Stimulus.xy_ratio`.
        %       Defaults to 1.
        %   size: :attr:`~CFSVM.Element.Stimulus.Stimulus.size`.
        %       Defaults to 0.05.
        %   padding: :attr:`~CFSVM.Element.Stimulus.Stimulus.padding`.
        %       Defaults to 0.
        %   rotation: :attr:`~CFSVM.Element.Stimulus.Stimulus.rotation`.
        %       Defaults to 0.
        %   contrast: :attr:`~CFSVM.Element.SpatialElement.contrast`.
        %       Defaults to 1.

            arguments
                dirpath {mustBeFolder}
                kwargs.duration = 0
                kwargs.position = "Center"
                kwargs.xy_ratio = 1
                kwargs.size = 0.05
                kwargs.padding = 0
                kwargs.rotation = 0
                kwargs.contrast = 1
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(kwargs);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = kwargs.(parameters_names{name});
            end

        end
        
        function preload_args(obj, screen)
        % Loads args property with PTB Screen('DrawLines') arguments.
        %
        % Args:
        %   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
        %
            
            for n = 1:length(screen.fields)
        
                texture = obj.textures.PTB_indices{1};
                if ~isempty(obj.manual_rect)
                    rect = obj.get_manual_rect(screen.fields{n}.rect);
                else
                    rect = obj.get_rect(screen.fields{n}.rect);
                end
                
                % Add args to the cell array
                obj.args{n} = ...
                    {
                        'DrawTexture', ...
                        screen.window, ...
                        texture, ...
                        [], ...
                        rect, ...
                        obj.rotation, ...
                        [], ...
                        obj.contrast 
                    };
                
            end
    
        end


        function vbl = show(obj, experiment)
        % Draws and shows fixation cross on the screen.
        %
        % Args:
        %   experiment: An experiment object.
        %
        % Returns:
        %   float: Onset time of the fixation.
        %
        
            % Left screen cross
            Screen(obj.args{1}{:});
            % Right screen cross
            Screen(obj.args{2}{:});
            % Checkerboard frame
            Screen('FillRect', experiment.screen.window, experiment.frame.colors, experiment.frame.rects);
            % Flip to the screen
            obj.onset = Screen('Flip', experiment.screen.window);
            vbl = obj.onset;
        
        end

    end

end

