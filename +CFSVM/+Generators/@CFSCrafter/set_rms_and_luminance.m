function stimuli_array = set_rms_and_luminance(obj, stimuli_array)
    
    gray_stimuli_array = obj.convert_to_grayscale(stimuli_array);
    image_mean = mean(gray_stimuli_array,[1,2]);
    mean_rms_contrast = mean(std(gray_stimuli_array,1,[1,2]));
    stimuli_array = (stimuli_array-image_mean) ./ mean_rms_contrast * obj.rms_contrast;
    stimuli_array = stimuli_array + obj.mean_luminance;
    stimuli_array(stimuli_array>1) = 1;
    stimuli_array(stimuli_array<0) = 0;

end