function check_info_functions(obj)

    files = {dir(obj.path_to_functions).name};
    infos = {'introduction.m', 'rest.m', 'farewell.m'};
    for n_info = 1:length(infos)
        if ~ismember(infos{n_info}, files)
            error('InfoFunctions should contain %s', infos{n_info})
        end
    end
    
    check_blocks(length(obj.trials.matrix), files)

end

function check_blocks(n_blocks, files)
    for block = 1:n_blocks
        if ~ismember(sprintf('block_introduction_%d.m', block), files)
            error('InfoFunctions should contain block_introduction_%d.m', block)
        end
    end
end
