classdef (Abstract) Stimulus < CFS.Element.TemporalElement & CFS.Element.SpatialElement
    %STIMULUS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

        dirpath

        position
       
        xy_ratio

        size

        padding
        
        rotation

        index

        textures
        
    end

   
    methods 
        import_images(obj, window, parameters);
    end

    methods (Access = protected)
        new_rectangle = get_rect(obj, screen_rectangle);
        [x0, y0, x1, y1, i, j] = get_stimulus_rect_shift(obj);
    end
end

