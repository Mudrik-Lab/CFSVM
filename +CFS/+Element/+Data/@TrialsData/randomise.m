function x = randomise(number_of_elements, repeats)
%randomise Pseudorandomises with number of consecutive repeats less than 5.
    x = randi(number_of_elements, 1, repeats);
    i = find(diff(x));
    n = [i numel(x)] - [0 i];
    while (max(n)>4)
        x = randi(number_of_elements, 1, repeats);
        i = find(diff(x));
        n = [i numel(x)] - [0 i];
    end
end

