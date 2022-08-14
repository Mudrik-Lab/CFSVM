function get_subject_info(obj)
%GET_SUBJECT_INFO Summary of this function goes here
%   Detailed explanation goes here

    app = SubjectInfo();
    while ~(app.save_clicked || app.cancel_clicked)
        pause(0.05)
    end
    if app.cancel_clicked == 1
        app.delete;
        % Stop further execution.
        error('"Cancel" button was pushed, program execution was stopped')
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

