function load_rect_parameters(obj, screen, is_left_suppression)
% Calculates rects depending on suppression side for the trial.
%
% Args:
%   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
%   is_left_suppression: bool
%
    
    if length(screen.fields) > 1
        if ~isempty(obj.manual_rect)
            obj.left_rect = obj.get_manual_rect(screen.fields{1}.rect);
            obj.right_rect =  obj.get_manual_rect(screen.fields{2}.rect);
        else
            obj.left_rect = obj.get_rect(screen.fields{1}.rect);
            obj.right_rect =  obj.get_rect(screen.fields{2}.rect);
        end
        
        if is_left_suppression
            obj.rect = obj.right_rect;
        else
            obj.rect = obj.left_rect;
        end

    elseif length(screen.fields) == 1
        if ~isempty(obj.manual_rect)
            obj.rect = obj.get_manual_rect(screen.fields{1}.rect);
        else
            obj.rect = obj.get_rect(screen.fields{1}.rect);
        end

    end

end