function rgb = hex2rgb(hex)
% Transforms hexadecimal color code to MATLAB RGB color code.

    rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
    
end

