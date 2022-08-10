function [response, secs] = record_response(evidence)
%record_response Summary of this function goes here
%   Detailed explanation goes here
    
    % Wait for a keyboard button signaling the observers response.
    while 1
        [secs, keyCode, ~] = KbWait();
        if ismember(KbName(keyCode), evidence(2:end))
            response = KbName(keyCode);
            break;
        end
    end
end

