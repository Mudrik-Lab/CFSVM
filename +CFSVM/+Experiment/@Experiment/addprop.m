function addprop(obj, prop_name)
% Adds new dynamic property and records its name.
%
% Args:
%   prop_name: Name of new property.
%

    % First add the property to the list of dynamic properties
    obj.dynpropnames{end+1} = prop_name;
    % Then call the addprop method of the dynamicprops class, 
    % which actually adds the dynamic property to the object.
    p = addprop@dynamicprops(obj, prop_name);
    p.NonCopyable = false;

end