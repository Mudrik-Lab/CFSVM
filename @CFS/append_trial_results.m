function append_trial_results(obj)
    %append_trial_response Appends recorded response to the main table.
    
    obj.results = orderfields(obj.results, obj.records.Properties.VariableNames);

    obj.records = [obj.records;struct2table(obj.results)];
end
