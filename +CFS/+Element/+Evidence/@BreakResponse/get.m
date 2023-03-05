function get(obj, pressed, first_press)
% Processes response properties from the PTB KbQueue.
%

    if pressed
        % Get only nonzero timings.
        firstPress = first_press(1,KbName(convertStringsToChars(obj.keys)));
        % Get sorted array of numeric codes converted from keys provided as
        % a parameter.
        sorted_codes = sort(KbName(obj.keys));
        % Get KbName code of the first key pressed.
        first_pressed_code = sorted_codes(firstPress==min(firstPress(firstPress ~= 0)));
        % Get KbName key of the first key pressed.
        obj.response_choice = find(KbName(obj.keys) == first_pressed_code);
        obj.response_kbname = obj.keys(obj.response_choice);
        obj.response_time = min(firstPress(firstPress ~= 0));
    else
        % If not pressed set breaking key to an empty string and time to
        % zero.
        obj.response_choice = "";
        obj.response_kbname = "";
        obj.response_time = 0;
    end
    
end
