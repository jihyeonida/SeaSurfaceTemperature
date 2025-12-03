load('xbtarray.mat')
dx = 0.25;
dlon = 128.5:dx:133.0;
dlat =  35.5:dx: 38.5;
font_s = dx*50;
num_f = 546;
% 549; % fixed 553
inc1 = 2; inc2 = 5; inc3 = 10; inc4 = 20; inc5 = 50; inc6 = 60;
std_dep = [0:inc1:8 10:inc2:95 100:inc3:190 200:inc4:280 300:inc5:350 400:inc6:460];
std_dep = std_dep';
%%
outfile = (['grid_pos',num2str((dx*100),'%3.3d'),'.txt']);
gfid = fopen(outfile);
aa = fgetl(gfid);
for i = 1:num_f
    cc = fgetl(gfid);
    ee = strsplit(cc);
    gord(i,1) = str2num(ee{2});
    gi(i,1) = str2num(ee{3});
    gj(i,1) = str2num(ee{4});
    glong(i,1) = str2num(ee{5});
    glatg(i,1) = str2num(ee{6});
    gmm(i,1) = str2num(ee{7});
    gdd(i,1) = str2num(ee{8});
    ghh(i,1) = str2num(ee{9});
    gmi(i,1) = str2num(ee{10});
    gnumx(i,1) = str2num(ee{11});
    glonx(i,1) = str2num(ee{12});
    glatx(i,1) = str2num(ee{13});
    fname(i,:) = ee{14};
end
fclose(gfid);

%%
xlon = glonx(idx(end));
xlat = glatx(idx(end));
%%
% 시각화할 특정 깊이층을 선택
layer = 1; % std_dep의 첫 번째 깊이층

% 45x45의 Lon, Lat meshgrid 생성
[Lon, Lat] = meshgrid(dlon, dlat);

% 선택한 깊이층에 해당하는 모든 그룹과 파일에 대한 데이터를 추출하여 reshape
data = squeeze(t_tem_3D(layer, :, :)); % 데이터는 (y, z) 크기로 추출됩니다
data = data(1:13,1:19); % 45x45로 reshape하여 Lon, Lat에 맞춤

% 데이터 시각화
figure;
surf(Lon, Lat, data);
shading flat;
colorbar;
title(['Depth Layer ' num2str(layer)]);
xlabel('Longitude');
ylabel('Latitude');