function import_from(obj, experiment)
% IMPORT_FROM Imports data from the experiment elements recorded in the trial.

    for object = obj.variables
        for var = object{:}(2:end)
            obj.data.(strcat(object{:}{1}, '_', var{:})) = experiment.(object{:}{1}).(var{:});
        end
    end
end
