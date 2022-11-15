function x = randomise(number_of_elements, repeats)
% RANDOMISE Pseudorandomises with number of consecutive repeats less than 5.

    cons_repeats = 4;
    x = randi(number_of_elements, 1, repeats);
    i = find(diff(x));
    n = [i numel(x)] - [0 i];
    while (max(n)>cons_repeats)
        x = randi(number_of_elements, 1, repeats);
        i = find(diff(x));
        n = [i numel(x)] - [0 i];
    end
    x = num2cell(x);

end

