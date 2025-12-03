load('xbtarray.mat')

% depth (1-42) , maximum number of XBT  , xbtlocation (1-45)
aa = mean(t_tem_3D, 1); % depth 정보를 지움. xbt의 넘버에 따른 평균 온도(42층)를 시사함.
bb = mean(t_tem_3D, 2); % xbt 개수의 평균임. 552/45를 했는데, 10, 14가 나오는 이유는 모르겠음.
cc = mean(t_tem_3D, 3); % xbt 위치에 대해 정보를 지워서, 층별 평균 온도를 나타냄.

%%
figure
subplot(311)
pcolor(squeeze(aa))
subplot(312)
pcolor(squeeze(bb))
subplot(313)
pcolor(transpose(squeeze(cc)))
%%
figure
pcolor(transpose(squeeze(t_tem_3D(1,:,:))))
shading flat; colorbar;
dd = nanmean(t_tem_3D, 2); 
figure;
pcolor(flipud(squeeze(dd)))
%%
load('mtem.mat')

% depth and mean temperature

%층별, xbt 위치별 평균임.
figure
for i = 1:42
    plot(mtem(i,:))
    hold on
end
%%
% location 전체
figure
plot(mtem(1,:))
%%
% grid-by-grid mean temperature

figure
for i = 1:45
    plot(mtem(:,i))
    hold on
end
%%
figure;
for i = 1:72
     subplot(8,9,i)
     plot(t_tem_3D(:,i,10))
end

%%
% 51번째 칸에 결측치가 있음.
figure;
for i = 1:72
     subplot(8,9,i)
     plot(mean(t_tem_3D(:,i,14),2))
end
%%
figure;
for i = 1:45
     subplot(9,5,i)
     plot(t_tem_3D(:,14,i))
end
%%
% figure;
% for i = 1:9
%      subplot(3,3,i)
%      plot(1:42,squeeze(t_tem_3D(i,:,:)))
% end
%%
% figure;
% plot(lon,lat,'r.')
% axis equal
% for i = 1:gn
%     text(glon-dx/5,glat,tgnum,'fontsize',font_s,'fontweight','bold')
% end

%%
% figure
% subplot(311)
% pcolor(t_tem_3D(28, :, :))
% subplot(312)
% pcolor(t_tem_3D(32, :, :))
% subplot(313)
% pcolor(t_tem_3D(40, :, :))

%%
idk = nanmean(t_tem_3D,3);

%%

%표층에서 각 그리드에 해당하는 xbt의 평균을 잰거임. 의미는 모르곘음.
figure;
plot(idk(1,:))
%%
%층별 평균인데, NaN값은 없는걸로 치고 구했음.
figure;
plot(idk(:,1))

%%
figure
pcolor(idk)
%%
idk = squeeze(nanmean(t_tem_3D,2));
idk = flipud(idk);

%%
figure;
plot(idk(1,:))
%%
figure;
bar(idk(:,1))
%% 
%nanmean이 없으면 할 수 있는게 없다.
jdk = squeeze(mean(t_tem_3D,2));
jdk = flipud(jdk);
%%
figure;
plot(jdk(1,:))
%%
figure;
plot(jdk(:,1))

%%
figure
for i = 1:45
    plot(t_tem_3D(1,:,i)) % depth (1-42) , maximum number of XBT  , xbtlocation (1-45)
    hold on
end

%%
load('lonxbt.mat')
load('latxbt.mat')
good=t_tem_3D(1,:,:);
layer1=squeeze(nanmean(good, 2));

%%
lonxbt_re = lonxbt(1:0.1:end);
latxbt_re = latxbt(1:0.1:end);
%%
F = scatteredInterpolant(lonxbt, latxbt, layer1, 'natural', 'linear');
value_grid = F(lonxbt, latxbt);
%%
F = scatteredInterpolant(dlon', dlat', layer1, 'natural', 'linear');
value_grid = F(dlon, dlat);
%%
[Lon Lat] = meshgrid(lonxbt, latxbt);
%%
figure
pcolor(Lon, Lat, Lon)

%%
figure;
mesh(xx,yy,xx)
hold on
mesh(Lon,Lat,Lat)
for i = 1:gn
    text(glon-dx/5,glat,tgnum,'fontsize',font_s,'fontweight','bold')
end
%%
lon_re = dlon(1:12);
lat_re = dlat(1:8);

[Lon_re Lat_re] = meshgrid(lon_re, lat_re);
%%
figure;
pcolor(Lon_re, Lat_re,mtem(1:8,1:12))
shading flat;
%%
doc_lon = lonxbt(lonxbt<=131.25 & lonxbt>128.5);
doc_lat = latxbt(latxbt<=37.25 & latxbt>=35.5);
%lonxbt_re = 
[Lon Lat] = meshgrid(doc_lon, doc_lat);
%%
figure
mesh(Lon, Lat, Lon)
%%
