function write(obj)
% Writes table to the dirpath.
%

    % Write the table to the folder with provided filename and extension. 
    writetable(obj.table, ...
        fullfile(obj.dirpath, ...
            strcat(num2str(obj.code), obj.file_extension)))

end

