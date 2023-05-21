function new_rectangle = get_manual_rect(obj, screen_rectangle)
    x0 = screen_rectangle(1)+obj.manual_rect(1);
    y0 = screen_rectangle(2)+obj.manual_rect(2);
    x1 = screen_rectangle(1)+obj.manual_rect(3);
    y1 = screen_rectangle(2)+obj.manual_rect(4);
    new_rectangle = [x0,y0,x1,y1];
end

