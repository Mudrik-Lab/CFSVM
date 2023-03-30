function run(obj)
% Executes the visual masking experiment.
%
% First initiates the experiment, then for every trial update parameters,
% shows fixation crosses, flashes masks and stimuli, records
% responses, writes results and shows rest screen.
%

    obj.initiate()
    
    for block = 1:obj.trials.n_blocks
        obj.trials.block_index = block;

        for trial = 1:width(obj.trials.matrix{block})
            obj.trials.start_time = GetSecs();
            obj.trials.trial_index = trial;
            obj.trials.load_trial_parameters(obj);

            obj.flash();
            
            obj.pas.show(obj);
            obj.mafc.show(obj);
            obj.trials.end_time = GetSecs();
            obj.show_rest_screen()
            save(sprintf( ...
                "%s/RawTrials/%s/block%d_trial%d.mat", ...
                obj.save_to_dir, ...
                obj.subject_info.code, ...
                obj.trials.block_index, ...
                obj.trials.trial_index), 'obj')
            obj.wait_for_keypress('return')
        end

    end
    obj.show_farewell_screen();

end 

