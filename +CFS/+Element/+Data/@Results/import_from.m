function import_from(obj, experiment)
%import_from Summary of this function goes here
%   Detailed explanation goes here

    for object = obj.variables
        for var = object{:}(2:end)
            obj.data.(strcat(object{:}{1}, '_', var{:})) = experiment.(object{:}{1}).(var{:});
        end
    end
end
