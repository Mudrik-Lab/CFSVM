function [spatial_frequency, spatial_psd] = get_spatial_amp( ...
    stimuli_array, ...
    screen_width_cm, ...
    screen_width_pixels, ...
    screen_height_cm, ...
    screen_height_pixels, ...
    viewing_distance)

    [row,col,~,~] = size(stimuli_array);

    gray_stimuli_array = CFSCrafter.convert_to_grayscale(stimuli_array);

    %max dimension between half column and half row
    max_dim = ceil(max(row/2,col/2));

    %padded to a square
    fft_gray_stimuli = fftshift(fft2(gray_stimuli_array,2*max_dim,2*max_dim));

    power = abs(fft_gray_stimuli./((2.*max_dim).^2)).^2 ;
    %radial average


    [XX,YY] = meshgrid(-max_dim:max_dim-1,-max_dim:1:max_dim-1);

    spatial_map = round(sqrt((XX).^2 + (YY).^2)); % distance map

    max_rad = max(max(spatial_map));

    spatial_psd = zeros(max_rad,1);

    for i = 1:max_rad
        index = spatial_map == i;
        spatial_psd(i) = sum(power(index),'all')./sum(index,'all');
    end

    spatial_frequency = (0:max_rad-1)';
    %use the degree dimension of the padded square
    width_degree = CFSVM.Utils.pix2deg(row, screen_width_cm, screen_width_pixels, viewing_distance);
    height_degree = CFSVM.Utils.pix2deg(col,screen_height_cm,screen_height_pixels, viewing_distance);
    spatial_frequency = spatial_frequency./ max(width_degree,height_degree);

end