function [freqs, psds] = get_psd(obj, img)

    [row,col] = size(img);
    gray_img = im2gray(img);
    max_dim = max(row, col);
    imgfft = fftshift(fft2(gray_img, max_dim, max_dim));
    power = abs(imgfft./((max_dim).^2)).^2 ;
    [XX,YY] = meshgrid(-max_dim/2:max_dim/2-1,-max_dim/2:1:max_dim/2-1);
    spatial_map = round(sqrt((XX).^2 + (YY).^2));
    max_rad = max(max(spatial_map));
    psds = zeros(max_rad,1);
    for i = 1:max_rad
        index = spatial_map == i;
        psds(i) = sum(power(index),'all')./sum(index,'all');
    end
    width_degree = obj.pixels2degrees(width(img), obj.s_w_cm, obj.s_w_pix, obj.view_dist);
    height_degree = obj.pixels2degrees(height(img),obj.s_h_cm,obj.s_h_pix, obj.view_dist);
    freqs = (0:max_rad-1)';
    freqs = freqs./ max(width_degree, height_degree);

end

