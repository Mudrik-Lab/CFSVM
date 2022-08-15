function [response, secs] = record_response(evidence)
%record_response Waits for a specific keypress and records the it.
    while 1
        [secs, keyCode, ~] = KbWait();
        if ismember(KbName(keyCode), evidence(2:end))
            response = KbName(keyCode);
            break;
        end
    end
end

