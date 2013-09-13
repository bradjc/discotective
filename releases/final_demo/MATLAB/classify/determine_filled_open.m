function [result] = determine_filled_open(img)
% input is small image of just a notehead
% output is string - either 'fill' or 'open'
%
% METHOD: looks at horizontal runs of black and white. Open heads can be
% characterized by first hitting a black run, then a white run, then
% another black


[h,w] = size(img);

open_flags = 0; % require >=3 to return 'open'

% HORIZONTALLY
for row=1:h % loop thru rows
    % STATES
    blackFirst = 0; %set to 1 once encountered black run of at least 2 pixels
    thenWhite = 0;  %set to 1 once encountered white run of at least 3 pixels
    anotherBlack = 0; %set to 1 once encountered another black run of at least 1 pixels
    
    
    inBlack = img(row,1);
    blackFirst = inBlack;
    run = 1;
    for col=2:w % loop across each row
        
        % UPDATE RUNS
        if (~img(row,col) && ~inBlack) % white continues
            run = run + 1;
        elseif (img(row,col) && ~inBlack) % white run ends
            run = 1;
            inBlack = 1;
        elseif (~img(row,col) && inBlack) % black run ends
            run = 1;
            inBlack = 0;
        else % black continues
            run = run + 1;
        end
        
        % UPDATE STATE
        if (~blackFirst && run >= 2 && inBlack)
            blackFirst = 1;
        elseif (~thenWhite && blackFirst && run >= 1 && ~inBlack) %CHANGED
            thenWhite = 1;
        elseif (~anotherBlack && thenWhite && run >=1 && inBlack)
            % reached final state, add one to the flags indicating open
            % head
            open_flags = open_flags + 1;
            break; % CHANGED
        end
        
        
    end %end column loop
 
end %end row loop



% VERTICALLY
% for col=1:w % loop thru columns
%     % STATES
%     blackFirst = 0; %set to 1 once encountered black run of at least 2 pixels
%     thenWhite = 0;  %set to 1 once encountered white run of at least 3 pixels
%     anotherBlack = 0; %set to 1 once encountered another black run of at least 1 pixels
%     
%     
%     inBlack = img(1,col);
%     run = 1;
%     for row=2:h % loop down each column
%         
%         % UPDATE RUNS
%         if (~img(row,col) && ~inBlack) % white continues
%             run = run + 1;
%         elseif (img(row,col) && ~inBlack) % white run ends
%             run = 1;
%             inBlack = 1;
%         elseif (~img(row,col) && inBlack) % black run ends
%             run = 1;
%             inBlack = 0;
%         else % black continues
%             run = run + 1;
%         end
%         
%         % UPDATE STATE
%         if (~blackFirst && run >= 2 && inBlack)
%             blackFirst = 1;
%         elseif (~thenWhite && blackFirst && run >= 2 && ~inBlack) %CHANGED
%             thenWhite = 1;
%         elseif (~anotherBlack && thenWhite && run >=1 && inBlack)
%             % reached final state, add one to the flags indicating open
%             % head
%             open_flags = open_flags + 1;
%             break; % CHANGED
%         end
%         
%         
%     end %end column loop
%  
% end %end row loop


if(open_flags >= 2)  % we are confident it is an open head
    result = 'open';
else
    result = 'fill';
end



end