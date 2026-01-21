function [start_time, tau_time, start_index] = M4_sub3_222_30_bhasin15(time_vals,velocity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
%  This program finds the acceleration start time and the tau time of the
%  velocity data
% Function Call
% M4_sub3_222_30_bhasin15 
% Input Arguments
% time_vals, velocity
% Output Arguments
% start_time, tau_time, start_index
% Assignment Information
%   Assignment:     M4, Problem 3
%   Team member:    Arvin Bhasin, bhasin15@purdue, Olivia Staufer, stauffeo@purdue.edu, 
% TJ Bielefeld tbielefe@purdue.edu, Bridget O’Donnell
%   odonne62@purdue.edu
%   Team ID:        222-30
%   Academic Integrity:
%     [] We worked with one or more peers but our collaboration
%        maintained academic integrity.
%     Peers we worked with: Name, login@purdue [repeat for each]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% M3 CODE
%% ____________________
%% INITIALIZATION
% test_window = 50; % How far ahead to look when comparing speeds
% speed_diff_threshold = 0.50; % Minimum increase in speed to be considered
% sustain_count = 7; % How many times in a row that threshold should be hit
% 
% 
% consec_speed = 0; % Counts how many consecutive valid increases we've seen
% found = 0; % Stops logic early once acceleration has been found
% start_index = 1; % Index of where acceleration start is detected
% rows = length(velocity); % length of our array

%% ____________________
%% CALCULATIONS
% Finding acceleration starting time

% Loop over speed data, up to where we still have room to look ahead
% for idx = 1:(rows - test_window)
% 
%      % Computes change in average speed ahead by the window size
%      diff = velocity(idx + test_window) - velocity(idx);
%   % If the change is big enough, it's becames a canidate
%     if diff > speed_diff_threshold
%         % Counts one more consecutive successful increase
%        consec_speed = consec_speed + 1;
%         % If we've had enough consecutive increases 
%         % and haven't already found it, mark the index
%        if consec_speed >= sustain_count && found == 0
%            start_index = idx + test_window;
%            found = 1; 
%        end
%    else
%   % If the increase isn’t big enough, reset the streak counter
%         consec_speed = 0;
%     end
% end
% 
% % Get time of acceleration start as well making sure it's valid to use
% if start_index > 0
%     start_time = time_vals(start_index);
% else
%     start_time = 0;
% end

% Finding tau time
% 
% % time to reach 63.7% of full speed after a_time with acceleration start
% % time of 5 seconds
% final_speed = mean(velocity((rows - 500):rows));
% start_speed = mean(velocity(1:start_index));
% % Calculate the target speed value where 63.7% of the rise has occurred
% % tau_speed = 0.637 * (final_speed - start_speed);
% % 
% % % Find first index where speed exceeds tau threshold
% % tau_index = start_index;
% % while tau_index <= rows && velocity(tau_index) < tau_speed
% %   % Keep going until tau_speed is reached or end of data
% %     tau_index = tau_index + 1; 
% % end
% %     tau_time = time_vals(tau_index) - start_time;
% % 


%% IMPROVEMENT 3:
%% Description:
% combines two ideas of using average slope over a certain window and
% chekcing if it's positive and large enough to ensure acceleration and
% making the slope has to be consecutively positive to help with false
% positives due to noise.

%% ____________________
%% INITIALIZATION
window_size = 30;         % Number of points in each window
slope_threshold = 5.0;    % Slope threshold (m/s^2) for acceleration
sustain_count = 8;        % Number of consecutive windows needed
rows = length(velocity);

start_index = NaN;        % Initialize as NaN until found
consec_count = 0;         % How many consecutive valid slopes we've seen

%% ____________________
%% FINDING ACCELERATION START TIME
for idx = 1:(length(time_vals) - window_size)
    % Get the window of time and velocity
    t_window = time_vals(idx:idx + window_size - 1);
    v_window = velocity(idx:idx + window_size - 1);

    % Calculate slope using linear fit
    p = polyfit(t_window, v_window, 1);
    avg_slope = p(1);  % slope = acceleration estimate

    % Check if slope exceeds threshold
    if avg_slope > slope_threshold
        consec_count = consec_count + 1;
        % Once enough consecutive valid slopes are detected, set start_index
        if consec_count >= sustain_count && isnan(start_index)
            start_index = idx;  % Set start at the first window that triggered
        end
    else
        consec_count = 0; % Reset if a window fails
    end
end

% If acceleration start not found, set default
if isnan(start_index)
    start_index = 1;
end

start_time = time_vals(start_index);

%% ____________________
%% FINDING TAU TIME
% Estimate initial and final velocities
v0 = mean(velocity(1:start_index));
v_final = mean(velocity(end-500:end)); % assuming 500 samples near end

% Calculate velocity at tau (63.2% of final rise)
v_tau = v0 + 0.632 * (v_final - v0);

% Find when velocity reaches v_tau
tau_index = start_index;
while tau_index <= rows && velocity(tau_index) < v_tau
    tau_index = tau_index + 1;
end

% Calculate tau time
    tau_time = time_vals(tau_index) - start_time;

%% ____________________
%% FORMATTED TEXT/FIGURE DISPLAYS
 
%% ____________________
%% RESULTS

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified. Neither have we provided
% access to my code to another. The program we are submitting
% is our own original work.