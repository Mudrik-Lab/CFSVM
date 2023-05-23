function noise_mask_single = create_single_noise_mask( ...
    stimuli_height_pixel, ...
    stimuli_width_pixel, ...
    is_pink)

    row = stimuli_height_pixel;
    col = stimuli_width_pixel;
    noise_mask_single = rand(row,col);

    if is_pink
        [XX,YY] = meshgrid(-col/2:col/2-1,row/2:-1:-(row/2-1));
        D = sqrt((XX).^2 + (YY).^2);
        D(D < 1) = 1;
        D = fftshift(D);
        fft_image = fft2(noise_mask_single).*(1./D);
        noise_mask_single = real(ifft2(fft_image));
    end

end