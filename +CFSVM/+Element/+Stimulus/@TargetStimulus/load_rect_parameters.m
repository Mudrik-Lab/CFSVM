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

