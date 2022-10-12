function load_parameters(obj, screen)
%LOAD_PARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    obj.title_size = round(screen.left.x_pixels/15);
    obj.text_size = round(obj.title_size/1.5);
    obj.spacing = round(obj.text_size/2);
    obj.left_text_start = screen.left.y_center-(obj.text_size+obj.spacing)*obj.n_options/2;
    obj.right_text_start = screen.right.y_center-(obj.text_size+obj.spacing)*obj.n_options/2;
end

