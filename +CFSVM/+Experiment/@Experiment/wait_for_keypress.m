function wait_for_keypress(key, func_name)
% Waits until the provided key is pressed, then continue.
%
% Interrupts the experiment if shift-esc was presses. 
% 
% Args:
%   key: A char array with the PTB key, check KbDemo for more info.
%

    if ~(isstring(key)||ischar(key)||iscellstr(key))
        if key
            warning('A key provided by the function %s should be char, string or cell array of chars', func_name)
        end
        return
    end
    keys = KbName('KeyNames');
    keys = keys(~cellfun('isempty', keys));
    if any(ismember(lower(key), lower(keys)))
        while 1
    
            [~, keyCode, ~] = KbStrokeWait;
    
            if any(keyCode(KbName(key)))
                break;
    
            elseif all(keyCode(KbName({'LeftShift', 'ESCAPE'})))
    
                Screen('CloseAll');
                ME = MException('Key:Esc_has_been_pressed', ...
                    'Esc has been pressed, the program has been terminated.');
                throw(ME)
    
            end
    
        end
    else
        warning('Function %s provided a non-existent key.', func_name)
    end

end

