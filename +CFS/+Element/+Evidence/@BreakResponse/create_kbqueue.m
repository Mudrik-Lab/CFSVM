function create_kbqueue(obj)
% Creates PTB KbQueue. 
%
% For more information, check `PTB documentation <http://psychtoolbox.org/docs/KbQueueCreate>`_.
%

    keys=[KbName(obj.keys)]; % All keys on right hand plus trigger, can be found by running KbDemo
    keylist=zeros(1,256); % Create a list of 256 zeros
    keylist(keys)=1; % Set keys you interested in to 1
    KbQueueCreate(-1,keylist); % Create the queue with the provided keys

end