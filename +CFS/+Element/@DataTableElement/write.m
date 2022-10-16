function write(obj)
%WRITE Summary of this function goes here
%   Detailed explanation goes here
    if ~exist(obj.dirpath, 'dir')
        mkdir(obj.dirpath);
    end
    writetable(obj.table, ...
        fullfile(obj.dirpath, ...
            strcat(obj.filename, obj.file_extension)));
end

