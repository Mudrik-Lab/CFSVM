function load_parameters(obj, screen)
% Loads PAS parameters for the trial.
%
% Args:
%   screen: :class:`~+CFS.+Element.+Screen.@CustomScreen` object.
%

    obj.title_size = round(screen.fields{1}.x_pixels/15);
    obj.text_size = round(obj.title_size/1.5);
    obj.spacing = round(obj.text_size/2);
    if length(screen.fields) > 1
        obj.left_text_start = round(screen.fields{1}.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
        obj.right_text_start = round(screen.fields{2}.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
    else
        obj.left_text_start = round(screen.fields{1}.y_center-(obj.text_size+obj.spacing)*obj.n_options/2);
    end
    
end

