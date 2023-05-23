classdef CFSCrafter < handle
% Generating and modifying CFS masks. 
%
% Supported types of masks are: 
% 1. Either solid or noise-filled circle-, square- or diamond-shaped Mondrians.
% 2. White or pink noise masks.
%
% Types of modifications supported:
% 1. Spatial low-, high-, band-pass filters
% 2. Temporal low-, high-, band-pass filters
% 3. Orientation filter
% 4. Phase scrambling
% 5. Setting RMS contrast and mean luminance.
%
% Types of analyses supported:
% 1. Radially averaged spatial power spectrum (1D)
% 2. Radially averaged temporal power spectrum (1D)
%
% The code was adopted and modified from CFS-crafter:
% https://github.com/guandongwang/cfs_crafter
%
% Wang, G., Alais, D., Blake, R. et al. CFS-crafter: 
% An open-source tool for creating and analyzing images for continuous flash suppression experiments. 
% Behav Res (2022). https://doi.org/10.3758/s13428-022-01903-7
%
    
    properties

        stimuli_array
        refresh_rate
        update_rate
        fft_stimuli
        rms_contrast
        mean_luminance

    end
    
    properties (Dependent)

      total_frames
      spatial_map
      padded_stimuli_dim
      modified_stimuli
      stay_frame

    end
    
    methods
        function obj = CFSCrafter(parameters)
            arguments
                parameters.path_to_masks
                parameters.refresh_rate
                parameters.update_rate
                parameters.rms_contrast = 0.37
                parameters.mean_luminance = 0.48
            end

            parameters_names = fieldnames(parameters);
            for name = 1:length(parameters_names)
                obj.(parameters_names{name}) = parameters.(parameters_names{name});
            end
            
            if isfield(parameters, 'path_to_masks')
                if isfile(parameters.path_to_masks)
                    obj.stimuli_array = load(parameters.path_to_masks);
                elseif isfolder(parameters.path_to_masks)
                    files = dir(parameters.path_to_masks);
                    files = CFSVM.Utils.natsortfiles(files, [], "rmdot");
                    for i = 1:length(files)
                        images(i).image_array = im2double(imread(fullfile(parameters.path_to_masks,files(i).name)));
                    end
                
                    individual_masks = cat(4,images(:).image_array);
                    % individual_masks = set_RMS_and_luminance(individual_masks,rms_contrast,mean_luminance);
                    
                    obj.stimuli_array = repelem(individual_masks, 1, 1, 1, obj.refresh_rate / obj.update_rate);
                end
            end

            if obj.stimuli_array
                obj.fft_stimuli = fftn(obj.stimuli_array, obj.padded_stimuli_dim);
            end
        end
        
        function total_frames = get.total_frames(obj)
            total_frames = size(obj.stimuli_array, 4);
        end

        function stay_frame = get.stay_frame(obj)
            stay_frame = round(obj.refresh_rate/obj.update_rate);
        end

        function padded_stimuli_dim = get.padded_stimuli_dim(obj)
            [row, col, color, frames] = size(obj.stimuli_array);
            padded_stimuli_dim = [max(row,col), max(row,col), color, frames];
        end

        function spatial_map = get.spatial_map(obj)
            [XX, YY] = meshgrid( ...
                -obj.padded_stimuli_dim(1)/2:obj.padded_stimuli_dim(1)/2-1, ...
                obj.padded_stimuli_dim(1)/2:-1:-(obj.padded_stimuli_dim(1)/2-1));
            spatial_map = sqrt((XX).^2 + (YY).^2); % distance map
        end

        function modified_stimuli = get.modified_stimuli(obj)
            modified_stimuli = real(ifftn(obj.fft_stimuli));
            modified_stimuli = modified_stimuli(1:size(obj.stimuli_array, 1),1:size(obj.stimuli_array, 2),:,:);
        end
        
        function play(obj)
            stimuli = obj.set_rms_and_luminance(obj.modified_stimuli);
            implay(stimuli)
        end

        function save(obj, save_to_file)
            stimuli.stimuli_array = obj.set_rms_and_luminance(obj.modified_stimuli);
            save(sprintf('%s', save_to_file), 'stimuli', '-v7.3');
        end

        spatial_filter(obj, screen_width_cm, screen_width_pixel, viewing_distance, filter_parameters)

        temporal_filter(obj, filter_parameters)

        orientation_filter(obj, orientation, sigma)
    
        phase_scramble(obj, parameters)
        
        stimuli_array = set_rms_and_luminance(obj, stimuli_array)

        generate_noise(obj, mask_resolution, sequence_duration_sec, is_pink)

        generate_mondrians( ...
            obj, ...
            mask_resolution, ...
            sequence_duration_sec, ...
            is_noise_fill, ...
            is_colored, ...
            pattern_shape, ...
            is_pink)

    end

    methods (Static)

        noise_mask_single = create_single_noise_mask( ...
            stimuli_height_pixel, ...
            stimuli_width_pixel, ...
            is_pink)

        patterned_mask_single = create_single_patterned_mask( ...
            stimuli_height_pixel, ...
            stimuli_width_pixel, ...
            patch, ...
            paste_index)
        
        [patch,paste_index] = patch_creation( ...
            stimuli_height_pixel, ...
            stimuli_width_pixel, ...
            is_noise_fill, ...
            is_colored, ...
            pattern_shape, ...
            is_pink)

        filter = band_pass_filter(type, dist_map, parameters)

        gray_stimuli_array = convert_to_grayscale(stimuli_array)

        [spatial_frequency, spatial_psd] = get_spatial_amp( ...
            stimuli_array, ...
            screen_width_cm, ...
            screen_width_pixels, ...
            screen_height_cm, ...
            screen_height_pixels, ...
            viewing_distance)

        [temporal_frequency, temporal_psd] = get_temporal_amp(stimuli_array, sequence_duration)
        
    end
end
