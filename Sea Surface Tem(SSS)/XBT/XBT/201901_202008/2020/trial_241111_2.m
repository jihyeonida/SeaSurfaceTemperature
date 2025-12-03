%%
area_lon = glonx(glonx<=131.25 & glonx>128.5);
area_lat = glatx(glatx<=37.25 & glatx>=35.5);
%%
% Assuming lonxbt, latxbt, and layer1 represent the coordinates and temperature data 
% for the 45 available grid points

% Define the full grid (10x8) in the domain
lon_full = linspace(min(lonxbt), max(lonxbt), 100);
lat_full = linspace(min(latxbt), max(latxbt), 80);
[Lon_grid, Lat_grid] = meshgrid(lon_full, lat_full);

% Use scatteredInterpolant for mapping layer1 to the full grid with natural neighbor interpolation
F = scatteredInterpolant(lonxbt, latxbt, layer1, 'natural', 'linear');

% Interpolate the values over the full grid
layer_full = F(Lon_grid, Lat_grid);

% Plot to check results
figure;
pcolor(Lon_grid, Lat_grid, layer_full);
shading flat;
colormap('redbluecmap')
colorbar;
hold on;
%plot(lon,lat,'r.')
axis equal
%for i = 1:gn
%    text(glon-dx/5,glat,tgnum,'fontsize',font_s,'fontweight','bold')
%end

title('Interpolated Temperature over Full 10x8 Grid');
%%
%%3d
% Define the full 3D grid (10x8x12) in the domain
lon_full = linspace(min(lonxbt), max(lonxbt), 10);
lat_full = linspace(min(latxbt), max(latxbt), 8);
depth_full = 1:42;  % Define depth levels (1 to 12 as an example)
[Lon_grid, Lat_grid, Depth_grid] = ndgrid(lon_full, lat_full, depth_full);

% Initialize a 10x8x12 3D grid to store interpolated values
data_3D = nan(10, 8, 42);

% For each depth level, perform 2D interpolation over the 10x8 grid
for d = 1:42
    % Extract data for the current depth level from layer1 (assumed to be 45x12 for each depth)
    layer_at_depth = mtem(d,:)';  % 45x1 data for depth d

    % Use scatteredInterpolant to interpolate at this depth level
    F = scatteredInterpolant(lonxbt, latxbt, layer_at_depth, 'natural', 'linear');
    
    % Perform the interpolation over the 10x8 grid at depth d
    data_3D(:, :, d) = F(Lon_grid(:, :, d), Lat_grid(:, :, d));
end

%%
% Plot to visualize one depth layer (e.g., depth level 1)
figure;
pcolor(Lon_grid(:,:,1), Lat_grid(:,:,1), data_3D(:,:,1));
shading flat;
colorbar;
title('Interpolated Temperature at Depth Level 1');


%%
% Plot to visualize one depth layer (e.g., depth level 1)
figure;
for i = 1:9
    subplot(3,3,i)
    pcolor(Lon_grid(:,:,i), Lat_grid(:,:,i), data_3D(:,:,i));
    shading flat;
    colormap('cool');
%    caxis([mean(data_3D(:,:,i),3)-1.5 mean(data_3D(:,:,i),3)+1.5])
    colorbar;
    title('Interpolated Temperature at Depth Level', i);
    grid on
    box on
    for i = 1:length(nan_idx)-1
        patch(blon(nan_idx(i)+1:nan_idx(i+1)-1,1),blat(nan_idx(i)+1:nan_idx(i+1)-1,1),[.7 .7 .7])
        hold on    
    end 
    patch(blon(nan_idx(end)+1:end,1),blat(nan_idx(end)+1:end,1),[.7 .7 .7])
end

%%
% Permute data to match meshgrid format
Lon_grid_m = permute(Lon_grid, [2, 1, 3]);
Lat_grid_m = permute(Lat_grid, [2, 1, 3]);
Depth_grid_m = permute(Depth_grid, [2, 1, 3]);
data_3D_m = permute(data_3D, [2, 1, 3]);
data3d = data_3D_m(:,:,42:-1:1);

% 3D 시각화 (slice plot)
figure;
slice(Lon_grid_m, Lat_grid_m, Depth_grid_m, data3d, lon_full, lat_full, depth_full); 
shading interp;
colorbar;
xlabel('Longitude');
ylabel('Latitude');
zlabel('Depth');
title('3D Interpolated Temperature Data');

