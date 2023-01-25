function write(obj)
% WRITE Writes table to the dir from the dirpath property.

    % Write the table to the folder with provided filename and extension. 
    writetable(obj.table, ...
        fullfile(obj.dirpath, ...
            strcat(obj.filename, obj.file_extension)))

end

