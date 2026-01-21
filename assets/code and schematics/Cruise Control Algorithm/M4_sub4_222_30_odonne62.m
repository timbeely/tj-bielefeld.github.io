function [v_I,v_F] = M4_sub4_222_30_odonne62(accel_index, data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This function calculates the initial and final average velocities 
% based on provided cleaned velocity data and the time at which 
% acceleration begins.
% 
% Function Call
%   [v_I, v_F] = M4_sub4_222_30_odonne62(accel_index, data)
%
% Input Arguments
%   accel_index - index representing the moment of initial acceleration
%   data - vector of cleaned up velocity data
% 
% Output Arguments
%   v_I - average velocity before accel_index (m/s)
%   v_F - average velocity over the last 500 data points (m/s)
%
% Assignment Information
%   Assignment:     M4, Subfunction 4
%   Author:         Bridget O'Donnell, TJ Bielefeld
%   Team ID:        222-30
%   Academic Integrity:
%     [] I worked with one or more peers but our collaboration
%        maintained academic integrity.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% CALCULATIONS

%%%%%%%%%%%%

% PAST CODE %
    % Calculate the average initial velocity (from start to accel_index)
    % v_I = mean(data(1:accel_index));  
    % Determine the length of the dataset
    % N = length(data);
    % Calculate the average final velocity (last 500 data points)
    % v_F = mean(data((N - 500):N));
% end

%%%%%%%%%%%%



%%%%%%%%%%%%

% IMPROVED CODE #2(MEAN UPDATED TO MEDIAN) %
    % Calculate the average initial velocity (from start to accel_index)
    v_I = median(data(1:accel_index)); 
    
    % Determine the length of the dataset
    N = length(data);
    
    % Calculate the average final velocity (last 500 data points)
    v_F = median(data((N - 500):N));
end

%%%%%%%%%%%%



%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% I have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have I provided
% access to my code to another. The function I am submitting
% is my own original work.