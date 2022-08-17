function get_subject_info(obj)
%get_subject_info Creates an object of SubjectInfo app class and waits for the data to be passed.
% Sets left or right eye suppression depending on the passed data
% See also SubjectInfo
    
    % Create object from the class
    app = SubjectInfo();
    %movegui(app.UIFigure, 'center');
    % Wait for the button to be pushed. Either 'Save' or 'Cancel'.
    while ~(app.save_clicked || app.cancel_clicked)
        pause(0.05)
    end

    % if cancel button was pushed - delete the object and stop the
    % experiment execution.
    % If save button was pushed - save provided data and set suppressing
    % half of the window. Delete the object at the end.
    if app.cancel_clicked == 1
        app.delete;
        % Stop further execution.
        error('"Cancel" button was pushed, program execution was stopped.')
    else
        obj.subj_info = app.data;
        if obj.subj_info.dominant_eye == "Right"
            obj.left_suppression = false;
        else
            obj.left_suppression = true;
        end
        app.delete;
    end
end

