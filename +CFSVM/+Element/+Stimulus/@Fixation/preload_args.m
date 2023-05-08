function preload_args(obj, screen)
% Loads args property with PTB Screen('DrawLines') arguments.
%
% Args:
%   screen: :class:`~CFSVM.Element.Screen.CustomScreen` object.
    
    for n = 1:length(screen.fields)

        texture = obj.textures.PTB_indices{1};
        if ~isempty(obj.manual_rect)
            rect = obj.get_manual_rect(screen.fields{n}.rect);
        else
            rect = obj.get_rect(screen.fields{n}.rect);
        end
        
        % Add args to the cell array
        obj.args{n} = ...
            {
                'DrawTexture', ...
                screen.window, ...
                texture, ...
                [], ...
                rect, ...
                obj.rotation, ...
                [], ...
                obj.contrast 
            };
        
    end
    
end