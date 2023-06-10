function rgb = hex2rgb(hex)
% Transforms hexadecimal color code to MATLAB RGB color code.
%
% Args:
%   hex (str): Color described by hexadecimal code, e.g., #123ABC
%
% Returns:
%   array: Color described by [R,G,B] array, where R,G,B from 0 to 1.
%
    arguments
        hex {mustBeHex}
    end
    hex = char(hex);
    rgb = sscanf(hex(2:end),'%2x%2x%2x',[1 3])/255;
    
end

function mustBeHex(hex)
    a = char(hex);
    if length(a) ~= 7
        error("Length is wrong, Hex code should be a '#' followed by exactly 6 hexadecimal numbers")
    end
    if a(1) ~= '#'
        error("Hex code should start with a '#'")
    end
    if isempty(regexp(a, "#[\d, A-F]{6}", 'ignorecase'))
        error("Provided hex color is wrong.")
    end
end