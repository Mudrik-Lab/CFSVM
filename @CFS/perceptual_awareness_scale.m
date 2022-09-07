function perceptual_awareness_scale(obj)
%perceptual_awareness_scale Draws and shows PAS screen, waits for the
% subject response and records it.
% See also record_response and append_trail_response.
    question = sprintf('There will be a PAS question.');
    DrawFormattedText(obj.window, question, 'center', 'center');
    obj.results.pas_onset = Screen('Flip', obj.window);
    
    % Wait for the response.
    [obj.results.pas_kbname, obj.results.pas_response_time] = obj.record_response(obj.subjective_evidence);
    obj.results.pas_response = find(strcmpi(obj.subjective_evidence,obj.results.pas_kbname))-1;
    obj.results.pas_method = obj.subjective_evidence(1);
    obj.results.pas_kbname = string(obj.results.pas_kbname);

    
end


