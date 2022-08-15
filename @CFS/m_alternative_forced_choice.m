function m_alternative_forced_choice(obj)
%m_alternative_forced_choice Draws and shows mAFC screen, waits for the
% subject response and records it.
% See also record_response and append_trail_response.
    question = sprintf('There will be a xAFC question.');
    Screen('TextFont', obj.window, 'Courier');
    Screen('TextSize', obj.window, 50);
    Screen('TextStyle', obj.window, 1+2);
    DrawFormattedText(obj.window, question, 'center', 'center');
    tflip = Screen('Flip', obj.window);
    
    % Wait for the response.
    [response, secs] = obj.record_response(obj.objective_evidence);

    % Add the response to the structure.
    obj.append_trial_response(response, obj.objective_evidence(1), secs, tflip);
end

