function write_subject_info(obj)
%WRITE_SUBJECT_INFO Summary of this function goes here
%   Detailed explanation goes here
    if ~exist(obj.subject_response_directory, 'dir')
        mkdir(obj.subject_response_directory);
    end
    if ~exist(obj.subject_info_directory, 'dir')
        mkdir(obj.subject_info_directory);
    end
    writetable(struct2table(obj.subj_info),sprintf('%s/%d.csv',obj.subject_info_directory, obj.subj_info.subject_code));
end

