function run(obj)
% Executes the breaking CFS experiment.
%
% First initiates the experiment, then for every trial update parameters,
% shows fixation crosses, flashes masks and stimuli, records
% responses, writes results and shows rest screen.
%

    obj.initiate()
    
    for block = 1:obj.trials.n_blocks
        obj.trials.block_index = block;
        obj.show_info(sprintf('block_introduction_%d', block))

        for trial = 1:width(obj.trials.matrix{block})
            obj.trials.start_time = GetSecs();
            obj.trials.trial_index = trial;
            obj.trials.load_trial_parameters(obj);
            
            vbl = obj.fixation.show(obj);

            KbQueueStart()
            [pressed, first_press] = obj.flash(vbl);
            KbQueueStop()

            obj.trials.end_time = GetSecs();
            obj.breakthrough.get(pressed, first_press)
            obj.show_info('rest')
            save(sprintf( ...
                "%s/RawTrials/%s/block%d_trial%d.mat", ...
                obj.save_to_dir, ...
                obj.subject_info.code, ...
                obj.trials.block_index, ...
                obj.trials.trial_index), 'obj')
        end

    end
    obj.show_info('farewell')

end 

