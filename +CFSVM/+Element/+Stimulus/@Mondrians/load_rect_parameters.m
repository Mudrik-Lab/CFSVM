function load_rect_parameters(obj, screen, is_left_suppression)
% Calculates rects depending on suppression side for the trial.
%
% Args:
%   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
%   is_left_suppression: bool
%

    if is_left_suppression
        if ~isempty(obj.manual_rect)
            obj.rect = obj.get_manual_rect(screen.fields{1}.rect);
        else
            obj.rect = obj.get_rect(screen.fields{1}.rect);
        end
    else
        if ~isempty(obj.manual_rect)
            obj.rect = obj.get_manual_rect(screen.fields{2}.rect);
        else
            obj.rect = obj.get_rect(screen.fields{2}.rect);
        end
    end
    
end