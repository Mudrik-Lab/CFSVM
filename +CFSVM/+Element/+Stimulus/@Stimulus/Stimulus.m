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
        
    end

   
    methods 

        import_images(obj, window, parameters);

        new_rectangle = get_rect(obj, screen_rectangle);

    end

    methods (Access=protected)

        [x0,y0,x1,y1,ir,ic] = get_stimulus_rect_shift(obj, position);

    end
    
end

