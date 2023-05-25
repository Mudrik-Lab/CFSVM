function orientation_filter(obj, parameters)
    arguments
    parameters.orientation
    parameters.sigma
    end

    [XX, YY] = meshgrid( ...
        -obj.padded_stimuli_dim(1)/2:obj.padded_stimuli_dim(1)/2-1, ...
        obj.padded_stimuli_dim(1)/2:-1:-(obj.padded_stimuli_dim(1)/2-1));
    theta = atan2(-YY,XX);  % orientation map

    orientation = orientation * pi/180;
    sigma = sigma * pi/180;
    sinDiff = sin(theta) * cos(orientation) - cos(theta) * sin(orientation);    % amplitudes for diff(points in the image, selected orientation).

    cosDiff = cos(theta) * cos(orientation) + sin(theta) * sin(orientation);
    diffTheta = abs( atan2( sinDiff,cosDiff ) );  %  sine= o/h, and cosine = a/h.. thus ~the same ratio for o/a (tan, the diff angle)
    oriBand = exp((-diffTheta .^2) / (2*sigma^2));

    % repeat the process for the opposite angles (ie, +180 degrees), since the fft has a mirror image in the spectrum

    orientation = orientation+pi; % 180 deg offset
    sinDiff = sin(theta) * cos(orientation) - cos(theta) * sin(orientation);
    cosDiff = cos(theta) * cos(orientation) + sin(theta) * sin(orientation);
    diffTheta = abs( atan2( sinDiff,cosDiff ) );
    ori_filter = oriBand + exp((-diffTheta .^2) / (2*sigma^2));
    ori_filter = fftshift(ori_filter);

    obj.fft_stimuli = obj.fft_stimuli .* ori_filter;

end