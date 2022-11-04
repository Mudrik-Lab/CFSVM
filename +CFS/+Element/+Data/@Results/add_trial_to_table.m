function add_trial_to_table(obj, varargin)
% ADD_TRIAL_TO_TABLE Appends recorded response to the table.
    
    obj.data = orderfields(obj.data, obj.table.Properties.VariableNames);
    obj.table = [obj.table;struct2table(obj.data)];
end
