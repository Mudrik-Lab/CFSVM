function wait_for_keypress(obj, key)
    %WAIT_FOR_KEYPRESS
    % Wait until the right KEY is pressed, then continue.
    % If control-esc was pressed - end the experiment.

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

