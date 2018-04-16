function [ Q ] = trainTicTacToe()
% To learn the action value table q(s,a) for the tic tac toe
% Agent learns to play the game twice. Once when the human plays first and
% other when the robot plays first.
% X is the robot agent, O is the human player (for simulation it is another agent)
% s - states - Total number of possible states = 3^9 (0 - vacant, 1 - X, 2 - O)
% A - action - Add a X to one of the empty states to reach another state
% r -  0 for non terminal resultant state
%     +1 for terminal state in which the robot wins
%     -1 for terminal state in which the robot loses
%      0 for terminal state in which the board is filled and thus is DRAW
% y - discounting factor = 1 since it is episodic and is bound to terminate at a win/loss/draw state
% a - step size in q learning
% Q(s,a) - a matrix of size 3^9 x 9 x 2
% actionMatrix - matrix of possible next state index for a given state

    % Initialization
    Table = zeros(1,9); % the game board (0 none, 1 = X, 2 = O)
    TablePowers = [3^0;3^1;3^2;3^3;3^4;3^5;3^6;3^7;3^8];
    aCounter = ones(3^9,9);
    y = 1;
    epsilonInitial = 0.5; % greediness coefficient
    epsilonFinal = 0.01;
    Q = zeros(3^9,9,2);
    score = zeros(1,3);
    % define the possible actions for each state
    for player=1:2
        actionMatrix = findActions(player);
        
        % Loop
        for episode=1:10^7
            table = Table;
            % State Initialization
            state = (table * TablePowers) + 1; % convert table to state
            if player == 1
                trueActions = find(actionMatrix(state,:) ~= 0);
                chooseAction = randperm(length(trueActions),1);
                state = actionMatrix(state,trueActions(chooseAction));
            end
            terminalStateReached = false;
            isPresentStateTerminalState = false;
            % epsilon for this iteration
            epsilon = epsilonInitial + (epsilonFinal - epsilonInitial)*(episode/10^7);
            while ~terminalStateReached
                if ~isPresentStateTerminalState
                    % Choose e-greedy action value policy Q to find the next action
                    [nextState,positionOfAction] = epsilonGreedyPolicy(Q(state,:,player),actionMatrix(state,:),epsilon);
                    % find and update the corresponding step value
                    aCounter(state,positionOfAction) = aCounter(state,positionOfAction) + 1;
                    a = 1/aCounter(state,positionOfAction);
                    % Take action and find the corresponding reward and next state
                    [whoWon,reward,isPresentStateTerminalState] = findWinner(nextState);
                    % learned sum
                    if isPresentStateTerminalState
                        learnedSum = reward;
                    else
                        learnedSum = reward + y * min(Q(nextState,actionMatrix(nextState,:) ~= 0,player));
                    end
                    % initial sum
                    initialSum = Q(state,positionOfAction,player);
                    Q(state,positionOfAction,player) = (1 - a) * initialSum + a * learnedSum;
                    state = nextState;
                end
                
                % Episode Termination
                if isPresentStateTerminalState
                    terminalStateReached = true;
                    if whoWon == 1
                        score(1) = score(1) + 1; % Score of X
                    elseif whoWon == 2
                        score(3) = score(3) + 1; % Score of O
                    elseif whoWon == 3
                        score(2) = score(2) + 1; % Tie
                    end
                else
                    % Choose e-greedy action value policy Q to find the next action
                    [nextState,positionOfAction] = epsilonGreedyPolicy(Q(state,:,player),actionMatrix(state,:),epsilon);
                    % find and update the step size
                    aCounter(state,positionOfAction) = aCounter(state,positionOfAction) + 1;
                    a = 1/aCounter(state,positionOfAction);
                    % Take action and find the corresponding reward and next state
                    [whoWon,reward,isPresentStateTerminalState] = findWinner(nextState);
                    % learned sum
                    if isPresentStateTerminalState
                        learnedSum = reward;
                    else
                        learnedSum = reward + y * max(Q(nextState,actionMatrix(nextState,:) ~= 0,player));
                    end
                    % initial sum
                    initialSum = Q(state,positionOfAction,player);
                    Q(state,positionOfAction,player) = (1 - a) * initialSum + a * learnedSum;
                    state = nextState;
                end
            end
            disp(['Episode: ' num2str(episode)]);
        end
    end
    disp(['X Wins: ' num2str(score(1))]);
    disp(['O Wins: ' num2str(score(3))]);
    disp(['Draw: ' num2str(score(2))]);
end