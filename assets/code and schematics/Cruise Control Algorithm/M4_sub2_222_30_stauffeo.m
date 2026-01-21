function [clean_v_vals] = M4_sub2_222_30_stauffeo(v_vals)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This function helps to manage the data noise and makes sure that the data
% is usable and accurate for parameters identification. 
% Function Call
% [clean_v_vals] = M4_sub2_SSS_TT_stauffeo(v_vals)
% Input Arguments 
% v_vals = a matrix of all of the raw velocities.
% Output Arguments
% clean_v_vals = this is a row vector of the new velocity values without any
% NaNs at a given time 
% Assignment Information
%   Assignment:     M4, Problem 2
%   Team member:    Olivia Stauffer, stauffer@purdue.edu, TJ Bielefeld, 
%   tbielefe@purdue.edu, Arvin Bhasin, bhasin15@purdue.edu, Bridgett 
%   O'Donnell, odonne62@purdue.edu 
%   Team ID:        222-30
%   Academic Integrity:
%     [] We worked with one or more peers but our collaboration
%        maintained academic integrity.
%     Peers we worked with: Name, login@purdue [repeat for each]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OLD CODE
%% ____________________
%% INITIALIZATION
%total_val = 0;% initalize the total value for a given row 
%total_data = 0; % initalize the number of data points at a given row
%avg_v_vals = zeros(length(v_vals), 1); % create the output which is the
% average of each row in a row vector sequence 


%% ____________________
%% CALCULATIONS
%for row=1:size(v_vals,1)% create a nested for loop the outer going through 
    % the rows
 %   for col=1:size(v_vals,2)% create the inner for loop that goes through the cols
  %      if ~isnan(v_vals(row,col))% test if the index at the given r,c value 
            % is a number or not
   %         total_val = total_val + v_vals(row,col); % if it is a number add it 
            % to the total for the row
   %         total_data = total_data + 1; % add one to the total number of 
            % numerical values in the row
   %     end 
   % end 
  %  avg_v_vals(row) = total_val / total_data;% after going through all the
    % columns find the average of the row and add it the row vector
  %  total_val = 0;% reset the total value
  %  total_data = 0;% reset the number of data points
%end 
%transpose(avg_v_vals);% return the output


%% IMPROVEMENT #1
% doesn't average across 5 function but fills NaN values for each test with
% averaged numbers from data left and right of the NaN value.
%% ____________________
%% INITIALIZATION
clean_v_vals = v_vals;

%% ____________________
%% CALCULATIONS
for row = 1:length(v_vals) %loop through raw data
    if isnan(clean_v_vals(row))  % check if the value at the index is NaN
        left = row - 1; % initialize left and right index
        right = row + 1;

        % Keep expanding outward until we find valid neighbors
        while (left >= 1 && isnan(clean_v_vals(left)))
            left = left - 1;
        end
        while (right <= length(v_vals) && isnan(clean_v_vals(right)))
            right = right + 1;
        end

        % Average the two sides if both exist
        if left >= 1 && right <= length(v_vals)
            clean_v_vals(row) = (clean_v_vals(left) + clean_v_vals(right)) / 2; % replace the NaN with the average 
            % of the values to the right and left
        elseif left >= 1 % for end points
            clean_v_vals(row) = clean_v_vals(left);
        elseif right <= length(v_vals) % for end points
            clean_v_vals(row) = clean_v_vals(right);
        end
    end
end

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



