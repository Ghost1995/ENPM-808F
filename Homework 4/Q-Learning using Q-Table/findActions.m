function actionMatrix = findActions( player )
% It is a matrix of order 3^9 x 9 as for each state there are atmost 9
% actions possible. i.e 1 each for each empty state(depending on whether the
% next action for that state is X or O) with maximum of 9 empty states

% For each state in the actionMatrix we store the row of possible actions.
% If the action = 0 means that that state is unattainable

    actionMatrix = zeros(3^9,9);
    for state = 1:3^9
        % get the table from state
        Table = state2table(state);
        TablePowers = [3^0;3^1;3^2;3^3;3^4;3^5;3^6;3^7;3^8];
        % determine the number of zeros and cross in the game
        num_zeros = length(find(Table == 2));
        num_cross = length(find(Table == 1));
        % playable moves per state for player 'X'
        emptyStates = find(Table == 0);
        if player == 1
            for i = 1:length(emptyStates)
                temp_table = Table;
                % assuming robot is always X and goes second
                if num_cross == num_zeros
                    temp_table(emptyStates(i)) = 2;
                    actionMatrix(state,emptyStates(i)) = (temp_table * TablePowers) + 1;
                elseif  num_zeros - num_cross == 1
                    temp_table(emptyStates(i)) = 1;
                    actionMatrix(state,emptyStates(i)) = (temp_table * TablePowers) + 1;
                end
            end
        elseif player == 2
            for i = 1:length(emptyStates)
                temp_table = Table;
                % assuming robot is always X and goes first
                if num_cross == num_zeros
                    temp_table(emptyStates(i)) = 1;
                    actionMatrix(state,emptyStates(i)) = (temp_table * TablePowers) + 1;
                elseif  num_cross - num_zeros == 1
                    temp_table(emptyStates(i)) = 2;
                    actionMatrix(state,emptyStates(i)) = (temp_table * TablePowers) + 1;
                end
            end
        end
    end
end