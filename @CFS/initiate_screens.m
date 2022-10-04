function initiate_screens(obj)
%INITIATE_SCREENS Summary of this function goes here
%   Detailed explanation goes here
    obj.screen.left.rect(1:2) = obj.left_side_screen(1:2) + obj.checker_rect_width;
    obj.screen.left.rect(3:4) = obj.left_side_screen(3:4) - obj.checker_rect_width;
    obj.screen.right.rect(1:2) = obj.right_side_screen(1:2) + obj.checker_rect_width;
    obj.screen.right.rect(3:4) = obj.right_side_screen(3:4) - obj.checker_rect_width;
    
    obj.screen.left.x_pixels = obj.screen.left.rect(3)-obj.screen.left.rect(1);
    obj.screen.left.y_pixels = obj.screen.left.rect(4)-obj.screen.left.rect(2);
    obj.screen.right.x_pixels = obj.screen.right.rect(3)-obj.screen.right.rect(1);
    obj.screen.right.y_pixels = obj.screen.right.rect(4)-obj.screen.right.rect(2);

    obj.screen.left.x_center = obj.screen.left.rect(3)-round(obj.screen.left.x_pixels/2);
    obj.screen.left.y_center = obj.screen.left.rect(4)-round(obj.screen.left.y_pixels/2);
    obj.screen.right.x_center = obj.screen.right.rect(3)-round(obj.screen.right.x_pixels/2);
    obj.screen.right.y_center = obj.screen.right.rect(4)-round(obj.screen.right.y_pixels/2);
end

