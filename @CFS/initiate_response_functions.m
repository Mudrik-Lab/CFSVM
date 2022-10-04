function initiate_response_functions(obj)
%initiate_response_functions Summary of this function goes here
%   Detailed explanation goes here
    max_temporal_frequency = max(cellfun(@(matrix) (max(matrix.temporal_frequency)), obj.trial_matrices));
    max_mask_duration = max(cellfun(@(matrix) (max(matrix.mask_duration)), obj.trial_matrices));
    obj.masks_number = max_temporal_frequency*max_mask_duration+1;
    
    obj.number_of_mAFC_pictures = length(obj.mAFC_keys);
    obj.number_of_PAS_choices = length(obj.PAS_keys);
    
    if obj.is_mAFC_text_version
        obj.mAFC = @obj.m_alternative_forced_choice_text;
    else
        obj.mAFC = @obj.m_alternative_forced_choice;
    end
end

