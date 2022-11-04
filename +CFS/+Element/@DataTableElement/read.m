function read(obj)
% READ Reads table.

    obj.table = readtable(fullfile(obj.dirpath, ...
            strcat(obj.filename, obj.file_extension)));
end

