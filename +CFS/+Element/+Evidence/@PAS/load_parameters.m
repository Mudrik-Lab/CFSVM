function load_parameters(obj, screen)
% Loads PAS parameters for the trial.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%

    obj.title_size = round(screen.left.x_pixels/15);
    obj.text_size = round(obj.title_size/1.5);
    obj.spacing = round(obj.text_size/2);
    obj.left_text_start = round(screen.left.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
    obj.right_text_start = round(screen.right.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
    
end

