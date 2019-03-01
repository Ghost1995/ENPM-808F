function [whoWon,varargout] = findWinner( state )
% Here we determine if the state is terminal or not
% If it is terminal then if X wins, reward = +1
%                        if O wins, reward = -1
%                        if it is a draw, reward = 0
%                        if not terminal, reward = 0
% 0 -> Game in Progress
% 1 -> X Won
% 2 -> O Won
% 3 -> Draw

    table = reshape(state2table(state),[3,3]);
    isTerminal = true;
    % Horizontal
    if (table(1,1) == table(1,2) && table(1,2) == table(1,3) && table(1,3) ~= 0)
        whoWon = table(1,1);
    elseif (table(2,1) == table(2,2) && table(2,2) == table(2,3) && table(2,3) ~= 0)
        whoWon = table(2,1);
    elseif (table(3,1) == table(3,2) && table(3,2) == table(3,3) && table(3,3) ~= 0)
        whoWon = table(3,1);
    % Vertical
    elseif (table(1,1) == table(2,1) && table(2,1) == table(3,1) && table(3,1) ~= 0) 
        whoWon = table(1,1);
    elseif (table(1,2) == table(2,2) && table(2,2) == table(3,2) && table(3,2)~= 0) 
        whoWon = table(1,2);
    elseif (table(1,3) == table(2,3) && table(2,3) == table(3,3) && table(3,3) ~= 0) 
        whoWon = table(1,3);
    % Diagonal
    elseif (table(1,1) == table(2,2) && table(2,2) == table(3,3) && table(3,3) ~= 0)
        whoWon = table(1,1);
    elseif (table(1,3) == table(2,2) && table(2,2) == table(3,1) && table(3,1) ~= 0)
        whoWon = table(1,3);
    % If it's a tie
    elseif isempty(find(table == 0,1))
        whoWon = 3;
        reward = 0;
    else
        whoWon = 0;
        reward = 0;
        isTerminal = false;
    end
    
    nout = max(nargout,1) - 1;
    if nout == 2
        if whoWon == 1
            reward = 1;
        elseif whoWon == 2
            reward = -1;
        end
    
        varargout{1} = reward;
        varargout{2} = isTerminal;
    end
end