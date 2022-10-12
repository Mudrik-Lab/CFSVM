function add_trial_to_table(obj, varargin)
    %add_trial_to_table Appends recorded response to the main table.

    obj.data = orderfields(obj.data, obj.table.Properties.VariableNames);
    obj.table = [obj.table;struct2table(obj.data)];
end
