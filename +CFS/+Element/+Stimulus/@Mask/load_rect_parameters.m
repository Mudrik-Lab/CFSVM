function load_rect_parameters(obj, screen)
% Calculates rects depending on suppression side for the trial.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%   is_left_suppression: bool
%

    obj.rect = obj.get_rect(screen.fields{1}.rect);
    
end