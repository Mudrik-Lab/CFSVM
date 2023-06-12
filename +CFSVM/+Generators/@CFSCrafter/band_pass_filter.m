function filter = band_pass_filter(type, dist_map, parameters)
    arguments
        type
        dist_map
        parameters.l_freq
        parameters.h_freq
        parameters.order
    end

    l_freq = parameters.l_freq;
    h_freq = parameters.h_freq;
    order = parameters.order;

    if isempty(l_freq)
        if isempty(h_freq)
            error('Provide at least one side cutoff frequency');
        else
            % Low pass filter if only h_freq has been provided.
            switch type
                case 'Ideal'
                    filter = double(abs(dist_map) < h_freq);
                case 'Gaussian'
                    filter = exp(-dist_map.^2 / (2 * (h_freq^2)));
                case 'Butterworth'
                    filter = 1 ./ ((1 + abs(dist_map) ./ h_freq).^(2 * order));
                case 'Log Gaussian'
                    fPeak = h_freq;
                    sigma = .5; % bandwidth in octave = 1, sigma = 1/2, need to check
                    filter = exp(-((log2(abs(dist_map)) - log2(fPeak)).^2) / (2 * log2(sqrt(2).^sigma)^2));
                    filter(dist_map < fPeak) = 1;
            end
            filter = fftshift(filter);
        end
    elseif isempty(h_freq)
        % High pass filter if only l_freq has been provided.
        switch type
            case 'Ideal'
                filter = double(abs(dist_map) > l_freq);
            case 'Gaussian'
                filter = 1 - exp(-abs(dist_map).^2 / (2 * (l_freq^2)));
            case 'Butterworth'
                filter = 1 ./ ((1 + l_freq ./ abs(dist_map)).^(2 * order));
            case 'Log Gaussian'
                fPeak = l_freq;
                sigma = .5; % bandwidth in octave = 1, sigma = 1/2, need to check
                filter = exp(-((log2(abs(dist_map)) - log2(fPeak)).^2) / (2 * log2(sqrt(2).^sigma)^2));
                filter(dist_map > fPeak) = 1;

        end
        filter = fftshift(filter);
    else
        % Band pass filter if l_freq and h_freq has been provided.
        switch type
            case 'Ideal'
                filter = double(abs(dist_map) < h_freq & abs(dist_map) > l_freq);
            case 'Gaussian'
                filter = exp(-dist_map.^2 / (2 * (h_freq^2))) - exp(-dist_map.^2 / (2 * (l_freq^2)));
            case 'Butterworth'
                filter = 1 - 1 ./ (1 + (((h_freq - l_freq) .* abs(dist_map)) ./ (dist_map.^2 - l_freq.^2)).^(2 * order));
            case 'Log Gaussian'
                fPeak = (h_freq - l_freq) / 2;
                sigma = log2(l_freq / h_freq); % sigma in octave sigma = log2(f2/f1)
                filter = exp(-((log2(abs(dist_map)) - log2(fPeak)).^2) / (2 * log2(sqrt(2).^sigma)^2));
        end
        filter = filter ./ max(max(filter));
        filter = fftshift(filter);
    end

end
