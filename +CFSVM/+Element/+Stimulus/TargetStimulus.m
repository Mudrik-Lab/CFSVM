classdef TargetStimulus < CFSVM.Element.Stimulus.Stimulus
% Manipulating target stimulus.
%
% Derived from :class:`~CFSVM.Element.Stimulus.Stimulus`.
%


    properties (Constant)
        
        % Parameters to parse into the processed results table.
        RESULTS = {'onset', 'offset', 'index', 'image_name'}

    end


    properties

        % [x0, y0, x1, y1] array - stimulus rect on the left screen.
        left_rect (1,4) {mustBeInteger}
        % [x0, y0, x1, y1] array - stimulus rect on the right screen.
        right_rect (1,4) {mustBeInteger}

    end
    



    methods

        function obj = TargetStimulus(dirpath, kwargs)
        %
        % Args:
        %   dirpath: :attr:`CFSVM.Element.Stimulus.Stimulus.dirpath`.
        %   duration: :attr:`CFSVM.Element.TemporalElement.duration`.
        %       Defaults to 1.
        %   position: :attr:`CFSVM.Element.Stimulus.Stimulus.position`.
        %       Defaults to "Center".
        %   xy_ratio: :attr:`CFSVM.Element.Stimulus.Stimulus.xy_ratio`.
        %       Defaults to 1.
        %   size: :attr:`CFSVM.Element.Stimulus.Stimulus.size`.
        %       Defaults to 0.3.
        %   padding: :attr:`CFSVM.Element.Stimulus.Stimulus.padding`.
        %       Defaults to 0.5.
        %   rotation: :attr:`CFSVM.Element.Stimulus.Stimulus.rotation`.
        %       Defaults to 0.
        %   contrast: :attr:`CFSVM.Element.SpatialElement.contrast`.
        %       Defaults to 1.
        %
        
            arguments
                dirpath {mustBeFolder}
                kwargs.duration = 1
                kwargs.position = "Center"
                kwargs.xy_ratio = 1
                kwargs.size = 0.3
                kwargs.padding = 0.5
                kwargs.rotation = 0
                kwargs.contrast = 1
            end
            
            obj.dirpath = dirpath;
            parameters_names = fieldnames(kwargs);
            
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = kwargs.(parameters_names{name});
            end

        end
        
        
        function load_rect_parameters(obj, screen)
        % Calculates rect coordinates on screen.
        %
        % Args:
        %   screen: :class:`~+CFSVM.+Element.+Screen.@CustomScreen` object.
        %
        
            if ~isempty(obj.manual_rect)
                obj.left_rect = obj.get_manual_rect(screen.fields{1}.rect);
                obj.right_rect =  obj.get_manual_rect(screen.fields{2}.rect);
            else
                obj.left_rect = obj.get_rect(screen.fields{1}.rect);
                obj.right_rect =  obj.get_rect(screen.fields{2}.rect);
            end
                
        end


        function show(obj, experiment)
        % Presents target for the provided duration.
        %
        % Args:
        %   experiment: An experiment object.
        %
        
            target = obj.textures.PTB_indices{obj.index};
            obj.image_name = obj.textures.images_names(obj.index);
            
            Screen('DrawTexture', experiment.screen.window, target, [], ...
                obj.left_rect, 0, 1, obj.contrast);
        
            Screen('DrawTexture', experiment.screen.window, target, [], ...
                obj.right_rect, 0, 1, obj.contrast);
            
            % Left screen cross
            Screen(experiment.fixation.args{1}{:});
            % Right screen cross
            Screen(experiment.fixation.args{2}{:});
            % Checkerboard frame
            Screen('FillRect', experiment.screen.window, experiment.frame.colors, experiment.frame.rects);
            
            obj.onset = Screen('Flip', experiment.screen.window);
            
            WaitSecs(obj.duration);
            obj.offset = GetSecs();
            
        end


    end
    
end
