function save_response(obj)
%SAVE_RESPONSE Summary of this function goes here
%   Detailed explanation goes here
    writetable(obj.records, ...
        sprintf('%s/%d.csv',obj.subject_response_directory, ...
                obj.subj_info.subject_code));
end

