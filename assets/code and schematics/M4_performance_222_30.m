function [] = M4_performance_222_30(test1, test2, test3, test4, test5, time_model, car, tire)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Compares CruiseAuto experimental data to CruiseAuto left and right bounds
% to ensure a working algorithm and for analysis for the ACC system on these new tires
% as well as sets the acceleration start time to a flat 5.00 seconds for all data. 
%
% Function Call
% M4_performance_222_30(test1, test2, test3, test4, test5, time_model, car, tire)
%  
% Input Arguments
% test1, test2, test3, test4, test5 = mathematical models using the
% parameters calculated in the other subfunctions
% time_model = time values for mathematical model
% car, tire = vector control variables for titles on plots
% 
% Output Arguments
% None
% Assignment Information
%   Assignment:     M4, Problem 5
%   Team member:    TJ Bielefeld, tbielefe@purdue.edu
%   Team ID:        222-30
%   Academic Integrity:
%     [] We worked with one or more peers but our collaboration
%        maintained academic integrity.
%     Peers we worked with: Name, login@purdue [repeat for each]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

% Left and Right Bound Cruise Control Data for Graphing given in M0
accel_start_left = 4.50;
accel_start_right = 6.00;

tau_left = 1.26;
tau_right = 3.89;

initial_vel_left = 1.10;
initial_vel_right = -0.90;

final_vel_left = 25.82;
final_vel_right = 23.36;

time_flat_left = linspace(0, 4.5, 10); % time values for plotting
time_flat_right = linspace(0, 6, 10);

time_left = linspace(4.5, 50, 1000); % time values for mathematical model
time_right = linspace(6, 50, 1000);

% string arrays for plot creation in the loop
tire_types = ["Winter", "Seasonal", "Summer", "Winter", "Seasonal", "Summer", "Winter", "Seasonal", "Summer"];
car_types = ["Compact", "Compact", "Compact", "Sedan", "Sedan", "Sedan", "SUV", "SUV", "SUV"];


%% ____________________
%% CALCULATIONS
% Create a mathematical model for the left and right bounds. These don't change across car and tire types.

y_model_flat_left = ones(size(time_flat_left)) .* initial_vel_left;
y_model_left = initial_vel_left + (1 - exp(-(time_left - accel_start_left) / tau_left)) .* (final_vel_left - initial_vel_left); % model for left bound

y_model_flat_right = ones(size(time_flat_right)) .* initial_vel_right;
y_model_right = initial_vel_right + (1 - exp(-(time_right - accel_start_right) / tau_right)) .* (final_vel_right - initial_vel_right); % model for left bound

%% ____________________
%% FORMATTED TEXT/FIGURE DISPLAYS
 
% Create a plot with the right and left bound data data set as a mathematical model
figure();
g1 = plot(time_flat_left, y_model_flat_left, "k--"); %% constant speed for first seconds for left bound
hold on;
g2 = plot(time_flat_right, y_model_flat_right, "k--"); %% constant speed for first seconds for right bound
hold on;
plot(time_left, y_model_left, "k--");  %% model for left bound
hold on;
plot(time_right, y_model_right, "k--"); %% model for right bound
hold on;
    
% create string for correct title
title_string = sprintf("Performance Tests: Speed vs Time for %s using %s Tires", car_types(car), tire_types(tire));
    
% plot the 5 tests cleaned data mathematical model
g3 = plot(time_model, test1, "r-");
hold on;
g4 = plot(time_model, test2, "b-");
hold on;
g5 = plot(time_model, test3, "g-");
hold on;
g6 = plot(time_model, test4, "c-");
hold on;
g7 = plot(time_model, test5, "m-");
hold off;
xlabel("Time (s)");
ylabel("Speed (m/s)");
title(title_string);
grid on;
legend([g1 g2 g3 g4 g5 g6 g7],"Left Bound", "Right Bound", "Test 1", "Test 2", "Test 3", "Test 4", "Test 5", "Location", "best");
    

%% ____________________
%% RESULTS


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified. Neither have we provided
% access to my code to another. The program we are submitting
% is our own original work.
end


