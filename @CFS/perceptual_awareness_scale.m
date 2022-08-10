function perceptual_awareness_scale(obj)
%PERCEPTUAL_AWARENESS_SCALE Summary of this function goes here
%   Detailed explanation goes here
    question = sprintf('There will be a PAS question.');
    Screen('TextFont', obj.window, 'Courier');
    Screen('TextSize', obj.window, 50);
    Screen('TextStyle', obj.window, 1+2);
    DrawFormattedText(obj.window, question, 'center', 'center')
    tflip = Screen('Flip', obj.window);
    
    [response, secs] = obj.record_response(obj.subjective_evidence);
    
    obj.append_trial_response(response, obj.subjective_evidence(1), secs, tflip);
    
end


