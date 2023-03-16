function load_parameters(obj)
% Precalculates and updates parameters for every oncoming trial.
%
% Loads parameters from trial matrix and then precalculates other
% parameters that depend on initialised window, i.e. masks, stimulus, fixation parameters.
%

    for block = 1:obj.trials.n_blocks
        obj.trials.block_index = block;
        for trial = 1:size(obj.trials.matrix{block}, 2)
            obj.trials.trial_index = trial;
            
            % Get an array of stimuli properties 
            prop_list = obj.trials.matrix{block}{trial}.get_dyn_props;
            stim_props = {};
            for prop_idx = 1:length(prop_list)
                c = class(obj.trials.matrix{block}{trial}.(prop_list{prop_idx}));
                if c == "CFS.Element.Stimulus.SuppressedStimulus"
                    stim_props{end+1} = prop_list{prop_idx};
                end
            end


            obj.trials.load_trial_parameters(obj)

            if class(obj) == "CFS.Experiment.VSM"
                obj.b_mask.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
                obj.f_mask.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
            else
                obj.mask.load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
            end
            
            
            for prop_idx = 1:length(stim_props)
                obj.(stim_props{prop_idx}).image_name = ...
                    obj.(stim_props{prop_idx}).textures.images_names(obj.(stim_props{prop_idx}).index);

                obj.(stim_props{prop_idx}).load_rect_parameters(obj.screen, obj.subject_info.is_left_suppression)
            end
            
            obj.fixation.load_args(obj.screen)
            
            obj.pas.load_parameters(obj.screen)
            if class(obj.mafc) == "CFS.Element.Evidence.ImgMAFC"
                obj.mafc.load_parameters(obj.screen, obj.(prop_list{1}).textures.PTB_indices, obj.(prop_list{1}).index);
            end
        end
    end
end
