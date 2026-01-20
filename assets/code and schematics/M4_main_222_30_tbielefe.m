function [] = M4_main_222_30_tbielefe()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This function is the main function that calls subfunctions to calculate
% different metrics regarding Autonomous Cruise Control data and then 
% produces formatted figures for the final report that clearly displays 
% the data, the analysis, and conclusions for CruiseAuto's ACC system.
%
% Function Call
% M4_main_222_30_tbielefe()
%
% Input Arguments
% No input arguments
%
% Output Arguments
% No output arguments
%
% Assignment Information
%   Assignment:     M4, Problem 1
%   Team member:    TJ Bielefeld, tbielefe@purdue.edu, Liv Stauffer, 
% stauffeo@purdue.edu, Bridget O'Donnell, odonne62@purdue.edu, 
% Arvin Bhasin, bhasin15@purdue.edu
%   Team ID:        222-30
%   Academic Integrity:
%     [] We worked with one or more peers but our collaboration
%        maintained academic integrity.
%     Peers we worked with:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION
data = readmatrix("Sp25_cruiseAuto_experimental_data.csv"); % import the data given by CruiseAuto
time_vals = data(:,1); % create vector that holds all time values

benchmark = readmatrix("Sp25_cruiseAuto_M3benchmark_data.csv"); % import the benchmark data given by CruiseAuto

% indices to match to the data table to extract the correct test data
col_data = 2;

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

tire = 1; % vector control variable for graphing titles
car = 1; % vector control variable for graphing titles
car_bench = 1; % vector variable for graphing titles
parameter_idx = 1; % vector variable for percent error calculations

% constant acceleration start time given by CruiseAuto
constant_accel_start_time = 5;

% string arrays for plot creation in the loop
tire_types = ["Winter", "Seasonal", "Summer", "Winter", "Seasonal", "Summer", "Winter", "Seasonal", "Summer"];
car_types = ["Compact", "Compact", "Compact", "Sedan", "Sedan", "Sedan", "SUV", "SUV", "SUV"];


% Benchmark Test Parameters [Compact, Sedan, SUV]
bench_accel_time_para = [6.21, 9.39, 6.85];
bench_time_constant_para = [1.51, 1.96, 2.80];
bench_initial_vel_para = [-0.09, -0.22, 0.19];
bench_final_vel_para = [25.08, 24.72, 24.18];

%% ____________________
%% CALCULATIONS

% Create a mathematical model for the left and right bounds. These don't change across car and tire types.

y_model_flat_left = ones(size(time_flat_left)) .* initial_vel_left;
y_model_left = initial_vel_left + (1 - exp(-(time_left - accel_start_left) / tau_left)) .* (final_vel_left - initial_vel_left); % model for left bound

y_model_flat_right = ones(size(time_flat_right)) .* initial_vel_right;
y_model_right = initial_vel_right + (1 - exp(-(time_right - accel_start_right) / tau_right)) .* (final_vel_right - initial_vel_right); % model for left bound


%% ___________________
%% FORMATTED TEXT/FIGURE DISPLAYS

for num=1:9 % for loop to loop through every car type and every tire type. 9 total cleaned data sets
    
    % create raw data vector that holds the 5 tests per car per tire type
    average_time_constant = 0;
    average_accel_start = 0;
    average_initial_vel = 0;
    average_final_vel = 0;
    
    % create vectors for a mathematical model for the performance
    %subfunction
    time_model_performance_flat = linspace(0, 5, 500);
    time_model_performance = linspace(5, 50, 4500);
    time_performance = [time_model_performance_flat, time_model_performance];
    performance = zeros(length(time_performance),5);

    for test=0:4
        test_data = data(:, test + col_data); % retrieve the raw data for each test 1 to 5
       
        % call all subfunctions
        test_data_clean = M4_sub2_222_30_stauffeo(test_data); %clean the data
        [accel_start_time, time_constant, accel_index] = M4_sub3_222_30_bhasin15(time_vals, test_data_clean); % returns acceleration start time, time constant, 
    % and accel time index for initial velocity
        [initial_vel, final_vel] = M4_sub4_222_30_odonne62(accel_index, test_data_clean); %find the initial and final velocity
        
        %add the current test to the total parameters average
        average_time_constant = average_time_constant + time_constant;
        average_accel_start = average_accel_start + accel_start_time;
        average_initial_vel = average_initial_vel + initial_vel;
        average_final_vel = average_final_vel + final_vel;
        
        % create a mathematical model for the individual test for the
        % performance subfunction
        y_model_performance_flat = ones(size(time_model_performance_flat)) .* initial_vel;
        y_model_performance = initial_vel + (1 - exp(-(time_model_performance - constant_accel_start_time) / time_constant)) .* (final_vel - initial_vel);
        performance(:, test + 1) = [y_model_performance_flat, y_model_performance];
    
    end
    
    % average all the parameters
    average_time_constant = average_time_constant / 5;
    average_accel_start = average_accel_start / 5;
    average_initial_vel = average_initial_vel / 5;
    average_final_vel = average_final_vel / 5;
   
    
    % Create a plot with the right and left bound data data set as a mathematical model
    figure()
    g1 = plot(time_flat_left, y_model_flat_left, "r-"); %% constant speed for first seconds for left bound
    hold on;
    g2 = plot(time_flat_right, y_model_flat_right, "b-"); %% constant speed for first seconds for right bound
    hold on;
    plot(time_left, y_model_left, "r-");  %% model for left bound
    hold on;
    plot(time_right, y_model_right, "b-"); %% model for right bound
    hold on;
    
    % Add the model for the cleaned data for all found parameters
    time_flat = linspace(0, constant_accel_start_time, 1000);
    time_model = linspace(constant_accel_start_time, 50, 10000);

    y_model_flat = ones(size(time_flat)) .* average_initial_vel;
    y_model = average_initial_vel + (1 - exp(-(time_model - constant_accel_start_time) / average_time_constant)) .* (average_final_vel - average_initial_vel); % model for data

    % create string for correct title
    title_string = sprintf("Averaging Tests: Speed vs Time for a %s using %s Tires", car_types(car), tire_types(tire));
    
    % plot the cleaned data mathematical model
    plot(time_flat, y_model_flat, "k-");
    hold on;
    g3 = plot(time_model, y_model, "k-");
    hold off;
    xlabel("Time (s)");
    ylabel("Speed (m/s)");
    title(title_string);
    grid on;
    legend([g1 g2 g3],"Left Bound", "Right Bound", "CruiseAuto Test Data", "Location", "best");
 
    
    % call performance subfunction to plot the experimental data with left and
    % right bounds to ensure algorithm works effectively and the ACC system
    % works correctly for the new tires for all 5 tests
    M4_performance_222_30(performance(:,1), performance(:,2), performance(:,3), performance(:,4), performance(:,5), time_performance, car, tire);
    
    tire = tire + 1; % Update vector control variable for next 
    car = car + 1; % Update vector control variable for next 
    col_data = col_data + 5; % Update index for next set of 5 tests
end

for bench=2:4 % loop through the benchmark data for the 3 data sets on original tires for using our algorithm
    
    raw_benchmark = benchmark(:,bench); % initialize raw data
    
    % call subfuctions to find parameters
    [accel__time_bench, time_constant_bench, accel_index_bench] = M4_sub3_222_30_bhasin15(time_vals, raw_benchmark); % returns acceleration start time, time constant, 
    % and accel time index for initial velocity
    [initial_vel_bench, final_vel_bench] = M4_sub4_222_30_odonne62(accel_index_bench, raw_benchmark);

    % shifted raw_benchmark for acceleration start time of 5 seconds
    raw_shifted = raw_benchmark(accel_index_bench-500:end);
    time_shifted = time_vals(accel_index_bench-500:end);
    time_shifted = time_shifted - (accel__time_bench-5.00);
   
    % create model for the benchmark data for a start time of 5 seconds
    time_flat_bench = linspace(0, constant_accel_start_time, 1000);
    time_model_bench = linspace(constant_accel_start_time, 50 - (accel__time_bench-5.00), 10000);
    
    y_model_bench_flat = ones(size(time_flat_bench)) .* initial_vel_bench;
    y_model_bench = initial_vel_bench + (1 - exp(-(time_model_bench - constant_accel_start_time) / time_constant_bench)) .* (final_vel_bench - initial_vel_bench); % model for data
    
    % title string for graphing
    title_string_bench = sprintf("Speed vs Time for a %s using Benchmark Tires", car_types(car_bench));
    
    % Create figures for raw benchmark data and model
    figure(bench + 17); % continue numbering the figures generated
    g1 = plot(time_flat_left, y_model_flat_left, "r-"); %% constant speed for first seconds for left bound
    hold on;
    g2 = plot(time_flat_right, y_model_flat_right, "b-"); %% constant speed for first seconds for right bound
    hold on;
    plot(time_left, y_model_left, "r-");  %% model for left bound
    hold on;
    plot(time_right, y_model_right, "b-"); %% model for right bound
    hold on;
    g3 = plot(time_shifted, raw_shifted, "c-");
    hold on;
    g4 = plot(time_flat_bench, y_model_bench_flat, "k-");
    hold on;
    plot(time_model_bench, y_model_bench, "k-");
    hold off;
    grid on;
    xlabel("Time (s)");
    ylabel("Speed (m/s)");
    xlim([0, 50 - (accel__time_bench-5.00)]);
    title(title_string_bench);
    legend([g1 g2 g3 g4], "Left Bound", "Right Bound", "Raw Benchmark Data", "Modeled Data", "Location", "best");
    
    % print parameters
    fprintf("\nThe acceleration start time in the data for a %s is %.2f\n", car_types(car_bench), accel__time_bench);
    fprintf("The time constant in the data for a %s is %.2f\n", car_types(car_bench), time_constant_bench);
    fprintf("The initial and final velocity for the data for a %s is %.2f and %.2f, respectively.\n", car_types(car_bench), initial_vel_bench, final_vel_bench);
     
    % find SSE_mod
    bench_model = zeros(size(time_vals));
    for idx = 1:length(time_vals)
        if time_vals(idx) < accel__time_bench
            bench_model(idx) = initial_vel_bench;
        else
            bench_model(idx) = initial_vel_bench + (final_vel_bench - initial_vel_bench) * ...
            (1 - exp(-(time_vals(idx) - accel__time_bench) / time_constant_bench));
        end
    end

    % Compute SSE
    SSE_mod = sum((raw_benchmark - bench_model).^2, "all") / length(time_vals);

    % print the SSE
    fprintf("\nThe SSE for the %s model is %.4f\n", car_types(car_bench), SSE_mod);
    
    % percent error for all parameters
    accel_error = abs(accel__time_bench - bench_accel_time_para(parameter_idx)) / bench_accel_time_para(parameter_idx) * 100;
  
    time_constant_error = abs(time_constant_bench - bench_time_constant_para(parameter_idx)) / bench_time_constant_para(parameter_idx) * 100;
    
    initial_vel_error = abs(initial_vel_bench - bench_initial_vel_para(parameter_idx)) / abs(bench_initial_vel_para(parameter_idx)) * 100;
    
    final_vel_error = abs(final_vel_bench - bench_final_vel_para(parameter_idx)) / bench_final_vel_para(parameter_idx) * 100;
    
    % print parameter percent error
    fprintf("\nThe acceleration start time percent error of the model for a %s is %.2f%%\n", car_types(car_bench), accel_error);
    fprintf("The time constant percent error of the model for a %s is %.2f%%\n", car_types(car_bench), time_constant_error);
    fprintf("The initial and final velocity percent error of the model for a %s is %.2f%% and %.2f%%, respectively.\n", car_types(car_bench), initial_vel_error, final_vel_error);
    
    % Update vector control variables
    parameter_idx = parameter_idx + 1;
    car_bench = car_bench + 3;

end

%% ____________________
%% RESULTS

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified. Neither have we provided
% access to my code to another. The program we are submitting
% is our own original work.
end