function save_responses(obj)
    %save_responses Saves responses as a table to file.
    % Creates folders if don't exist.
    if ~exist(obj.subject_info_directory, 'dir')
        mkdir(obj.subject_info_directory);
    end
    disp(obj.subj_info.subject_code)
    writetable(struct2table(obj.subj_info),sprintf('%s/%d.txt',obj.subject_info_directory, obj.subj_info.subject_code));

    if ~exist(obj.subject_response_directory, 'dir')
        mkdir(obj.subject_response_directory);
    end
    writetable(struct2table(obj.response_records),sprintf('%s/%d.txt',obj.subject_response_directory, obj.subj_info.subject_code));
end
