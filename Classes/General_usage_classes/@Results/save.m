function save(obj, subject_code)
%save Saves experiment results to the table.
    writetable(obj.table, ...
        sprintf('%s/%d.csv',obj.dirpath, subject_code));
end