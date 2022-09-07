function m_alternative_forced_choice(obj)
%m_alternative_forced_choice Draws and shows mAFC screen, waits for the
% subject response and records it.
% See also record_response and append_trail_response.
    question = sprintf('There will be a xAFC question.');
    DrawFormattedText(obj.window, question, 'center', 'center');
    obj.results.afc_onset = Screen('Flip', obj.window);
    
    % Wait for the response.
    [obj.results.afc_kbname, obj.results.afc_response_time] = obj.record_response(obj.objective_evidence);
    obj.results.afc_response = find(strcmpi(obj.objective_evidence,obj.results.afc_kbname))-1;
    obj.results.afc_method = obj.objective_evidence(1);
    obj.results.afc_kbname = string(obj.results.afc_kbname);

end

