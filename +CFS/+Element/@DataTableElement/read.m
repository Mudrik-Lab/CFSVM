function read(obj)
%READ Summary of this function goes here
%   Detailed explanation goes here
    obj.table = readtable(fullfile(obj.dirpath, ...
            strcat(obj.filename, obj.file_extension)));
end

