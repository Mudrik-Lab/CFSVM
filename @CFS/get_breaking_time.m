function get_breaking_time(obj)
    %get_breaking_time Gets breaking time from PTB KbQueue.
    % Get KbQueue records
    [pressed, firstPress, ~, ~, ~] = KbQueueCheck();

    if pressed
        % Get only nonzero timings.
        firstPress = firstPress(1,KbName(convertStringsToChars(obj.breakthrough_keys)));
        % Get sorted array of numeric codes converted from keys provided as
        % a parameter.
        sorted_codes = sort(KbName(obj.breakthrough_keys));
        % Get KbName code of the first key pressed.
        first_pressed_code = sorted_codes(firstPress==min(firstPress(firstPress ~= 0)));
        % Get KbName key of the first key pressed.
        obj.results.breaking_key = obj.breakthrough_keys(find(KbName(obj.breakthrough_keys) == first_pressed_code));
        obj.results.breaking_time = min(firstPress(firstPress ~= 0));
    else
        % If not pressed set breaking key to an empty string and time to
        % zero.
        obj.results.breaking_key = "";
        obj.results.breaking_time = 0;
    end
end
