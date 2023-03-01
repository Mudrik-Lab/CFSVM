function record_response(obj)
% Waits for a keypress specified in obj.keys and records response properties.
%

    while 1
        [obj.response_time, keyCode, ~] = KbWait();

        if ismember(KbName(keyCode), obj.keys(1:end))

            obj.response_kbname = KbName(keyCode);
            break;

        end

    end
    
    obj.response_choice = find(strcmpi(obj.keys, obj.response_kbname));
    obj.response_kbname = convertCharsToStrings(obj.response_kbname);
    
end

