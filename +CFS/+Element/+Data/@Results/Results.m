classdef Results < CFS.Element.DataTableElement
    %RESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
        objects
        variables
    end
    
    methods
        function obj = Results(experiment, parameters)
            %RESULTS Construct an instance of this class
            %   Detailed explanation goes here

            arguments
                experiment
                parameters.dirpath = './!Results'
            end

            obj.dirpath = parameters.dirpath;
            obj.filename = num2str(experiment.subject_info.code);

            obj.objects = {};
            obj.variables = {};

            for prop = properties(class(experiment))'
                if isprop(experiment.(prop{:}), 'RESULTS')
                    obj.objects = cat(2, obj.objects, prop);
                end
            end
            
            for object = obj.objects
                object_vars = [object, experiment.(object{:}).RESULTS];
                obj.variables = cat(2, obj.variables, {object_vars});
            end
            object_and_vars = cellfun(@(x)  ...
                strcat(x{1}, '_', x(2:end)), obj.variables, UniformOutput=false);
            vars_to_table = horzcat(object_and_vars{:});
            obj.table = cell2table(cell(0, length(vars_to_table)), ...
        'VariableNames', vars_to_table);

        end
        import_from(obj, experiment)
        add_trial_to_table(obj);
    end
end

