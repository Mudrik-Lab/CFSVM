function save_response(obj)
%save_response Saves experiment results to the table.
    writetable(obj.records, ...
        sprintf('%s/%d.csv',obj.subject_response_directory, ...
                obj.subj_info.subject_code));
end

