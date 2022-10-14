function initiate(obj)
    %initiate Initiates parameters by calculating them from rect
    %field.
    obj.left.x_pixels = obj.left.rect(3)-obj.left.rect(1);
    obj.left.y_pixels = obj.left.rect(4)-obj.left.rect(2);
    obj.right.x_pixels = obj.right.rect(3)-obj.right.rect(1);
    obj.right.y_pixels = obj.right.rect(4)-obj.right.rect(2);

    obj.left.x_center = obj.left.rect(3)-round(obj.left.x_pixels/2);
    obj.left.y_center = obj.left.rect(4)-round(obj.left.y_pixels/2);
    obj.right.x_center = obj.right.rect(3)-round(obj.right.x_pixels/2);
    obj.right.y_center = obj.right.rect(4)-round(obj.right.y_pixels/2);
end
