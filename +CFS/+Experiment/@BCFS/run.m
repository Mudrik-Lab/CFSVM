function run(obj)
% RUN Executes the breaking CFS experiment.
%
% Firstly initiates the experiment, then for every trial loads parameters,
% shows rest screen and fixation cross, flashes masks and stimuli, records
% responses, writes results.
    
    obj.initiate()
    
    for block = 1:obj.trials.n_blocks
        obj.trials.block_index = block;

        for trial = 1:width(obj.trials.matrix{block})
            obj.trials.start_time = GetSecs();
            obj.trials.trial_index = trial;
            obj.load_parameters()

            obj.vbl = obj.fixation.show(obj);

            KbQueueStart()
            obj.flash()
            KbQueueStop()

            obj.trials.end_time = GetSecs();
            obj.stimulus_break.get()
            obj.show_rest_screen()
        end

    end
    obj.show_farewell_screen();

end 

