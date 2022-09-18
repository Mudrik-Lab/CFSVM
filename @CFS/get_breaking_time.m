function get_breaking_time(obj)
    %get_breaking_time Gets breaking time from PTB KbQueue.
    [pressed, firstPress, ~, ~, ~] = KbQueueCheck();
    obj.results.breaking_time = (firstPress(1,KbName(convertStringsToChars(obj.breakthrough_key)))-obj.results.mondrians_onset)*pressed;
end
