function wait_for_keypress(obj, key)
% Waits until the provided key is pressed, then continue.
%
% Interrupts the experiment if shift-esc was presses. 
% 
% Args:
%   key: A char array with the PTB key, check KbDemo for more info.
%
    while 1

        [~, keyCode, ~] = KbWait;

        if keyCode(KbName(key)) == 1
            break;

        elseif all(keyCode(KbName({'LeftShift', 'ESCAPE'})))

            Screen('CloseAll');
            ME = MException('Key:Esc_has_been_pressed', ...
                'Esc has been pressed, the program has been terminated.');
            throw(ME)

        end

    end

end

