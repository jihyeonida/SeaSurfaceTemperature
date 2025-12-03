% Load datasets A and B (assuming they are loaded as variables `A` and `B`)

B = t_tem_3D;

% Initialize parameters for comparison
selected_grid_B = 10;       % Choose a specific grid point in the range 1-45 for B
selected_day_B = 44;        % Choose a specific day in the range 1-62 for B
depth_levels = 1;         % Number of depth levels to compare

% 1. Extract data for the selected grid and day from dataset B
% B structure: (depth x elements x time), so we extract one element and one day
data_B = B(:, selected_day_B, selected_grid_B:selected_grid_B+9);

% 2. Extract and average the corresponding day from dataset A
% A structure: (lon x lat x depth x time)
% Assuming spatial alignment between datasets, we select a region of A
% that corresponds to `selected_grid_B` in B. You may need to adjust based on actual coordinates.
%%

A = data_3D_m;
%%
% Define indices for the longitude and latitude range in A that matches the grid point in B.
% This is an example; replace with appropriate indices that correspond to the grid in B.
lon_idx = 1; % Adjust based on the spatial location of the selected grid in A
lat_idx = 1; % Adjust as well based on the spatial location in A

% Calculate daily average for A over 8 time intervals (3-hour intervals in a day)
daily_data_A = A(lon_idx, 1:10, :);

C = (squeeze(data_B) - squeeze(daily_data_A));
%%
% 3. Calculate RMSE between A and B data for the selected day and grid
rmse = sqrt(mean(C.^2, 'omitnan'));  % Handles NaNs in the calculation

figure;
plot(rmse)
%%
% Display the RMSE result
fprintf('RMSE between datasets A and B at grid %d and day %d: %.4f\n', selected_grid_B, selected_day_B, rmse);