% 데이터 로딩 및 변수 초기화
% XBT 데이터에서 하나의 데이터만 선택하여 분석
load('xbtarray.mat');  % XBT 데이터 예: (층, 개수, 깊이.)
%%
data_xbt = squeeze(t_tem_3D(1,:,:));
% Initialize an empty array to store cleaned data without NaNs
data_cleaned = [];
row = [];
%%
% Loop through each time step (1st dimension)
for t = 1:size(data_xbt, 2)
    % Extract a 2D slice for the current time step
    location_slice = squeeze(data_xbt(:, t));
    
    % Identify rows in the slice without any NaNs
    valid_rows = all(~isnan(location_slice), 2);
    
    % Append rows without NaNs to data_cleaned
    data_cleaned = [data_cleaned; location_slice(valid_rows, :)];
    row = [row; valid_rows];
end
%%
location = reshape(row, [72 45]);

numofel = [];
for i = 1:45
    doc =numel(find(location(:,i)==1));
    numofel = [numofel; doc];
end
%%
% Perform std on the cleaned data
lenapark = [];
serenade = [];
j = 1;

for i = 1:45
    tilde = find(location(:,i)==1);
    xbt_usable = data_cleaned(j:j+length(tilde),:);
    j = length(tilde);
    jhp = mean(xbt_usable);
    serenade = [serenade; jhp]; 
end

%%
figure
boxplot(data_xbt)
%%
% Assuming lonxbt, latxbt, and layer1 represent the coordinates and temperature data 
% for the 45 available grid points

anomaly=nanvar(data_xbt);

% Define the full grid (10x8) in the domain
lon_full = linspace(min(lonxbt), max(lonxbt), 100);
lat_full = linspace(min(latxbt), max(latxbt), 80);
[Lon_grid, Lat_grid] = meshgrid(lon_full, lat_full);

% Use scatteredInterpolant for mapping layer1 to the full grid with natural neighbor interpolation
F = scatteredInterpolant(lonxbt, latxbt, anomaly', 'natural', 'linear');

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
% grid on
% box on
% for i = 1:length(nan_idx)-1
%     patch(blon(nan_idx(i)+1:nan_idx(i+1)-1,1),blat(nan_idx(i)+1:nan_idx(i+1)-1,1),[.7 .7 .7])
%     hold on    
% end 
% %patch(blon(nan_idx(end)+1:end,1),blat(nan_idx(end)+1:end,1),[.7 .7 .7])

title('Anomaly Interpolated Temperature over Full 10x8 Grid');


%%
% Perform EOF on the cleaned data
lenapark = [];
serenade = [];
j = 1;

for i = 1:45
    tilde = find(location(:,i)==1);
    xbt_usable = data_cleaned(j:j+length(tilde),:);
    j = length(tilde);
    [V, D] = eig(xbt_usable * xbt_usable' / numel(xbt_usable));
    EOFs = fliplr(V);
    lenapark = [lenapark; EOFs(1,:)];
    serenade = [serenade; D(end-1,end-1)/sum(diag(D))]; 
end



%%
 % Flip to get the top EOFs in descending order
