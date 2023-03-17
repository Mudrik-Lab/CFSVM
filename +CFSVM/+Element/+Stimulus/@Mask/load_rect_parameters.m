function load_rect_parameters(obj, screen, is_left_suppression)
% Calculates rects depending on suppression side for the trial.
%
% Args:
%   screen: :class:`~+CFSVM.+Element.+Screen.@CustomScreen` object.
%   is_left_suppression: bool
%
    
    if length(screen.fields) > 1
        
        obj.left_rect = obj.get_rect(screen.fields{1}.rect);
        obj.right_rect =  obj.get_rect(screen.fields{2}.rect);
        
        if is_left_suppression
            obj.rect = obj.left_rect;
        else
            obj.rect = obj.right_rect;
        end

    elseif length(screen.fields) == 1

        obj.rect = obj.get_rect(screen.fields{1}.rect);

    end
    
end