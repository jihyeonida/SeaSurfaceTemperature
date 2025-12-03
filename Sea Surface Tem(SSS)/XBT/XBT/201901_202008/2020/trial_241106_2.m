iid = fopen('data_231214.txt','r');
tnn = 533;
for i = 1:tnn
    cc = fgetl(iid);
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
%     gdata = fscanf(gfid,'%d%d%d%f%f%d%d%d%d%d%f%f',[12 inf]);
end
fclose(iid);
%%
gdata = [gord gi gj glong glatg gmm gdd ghh gmi gnumx glonx glatx];
data = gdata(:, [4:10]);
gn = gdata(end,1);
ord = gdata(:,1);
num = gdata(:,10);
for i = 1:gn
    g_idx2 = find(ord==i);
    g_idx(i,1) = g_idx2(end);
end
glon = gdata(g_idx,end-1);
glat = gdata(g_idx,end);
gnum = gdata(g_idx,end-2);
tgnum = num2str(gnum);
%%
idx = find(data(:,3)>=8 & data(:,3)<9);
data2 = data(idx,:);
%%
%boundary, bdry라고 해도 되나 내 코드가 아님.
bndy = [127.956593706, 38.8106212875
        130.117810834, 34.7292458650
        133.043766331, 34.5463736465
        133.725380963, 38.8854326496];
idx_bndy = inpolygon(data2(:,1),data2(:,2),bndy(:,1),bndy(:,2));

datax = data2(idx_bndy,:);
%%
lon = datax(:,1);
lat = datax(:,2);
mm = datax(:,3);
dd = datax(:,4);
hh = datax(:,5);
mi = datax(:,6);


dx = 0.25;
dlon = 128.5:dx:133.0;
dlat =  35.5:dx: 38.5;
font_s = dx*50;


[xx yy] = meshgrid(dlon,dlat);
%%

mapfile = '/Users/huiyo/Documents/HDD/과제, 연구 자료 및 시행착오 (박사 수료, 23.12.23-25.02.28)/MATLAB/coastline/coast_sin.txt';

data = load(mapfile);
blon = data(:,1); blat = data(:,2);
nan_idx = find(isnan(blon));
for i = 1:length(nan_idx)-1
    patch(blon(nan_idx(i)+1:nan_idx(i+1)-1,1),blat(nan_idx(i)+1:nan_idx(i+1)-1,1),[.7 .7 .7])
    hold on    
end
patch(blon(nan_idx(end)+1:end,1),blat(nan_idx(end)+1:end,1),[.7 .7 .7])

%%
gn = gdata(end,1);
ord = gdata(:,1);
num = gdata(:,10);
for i = 1:gn
    g_idx2 = find(ord==i);
    g_idx(i,1) = g_idx2(end);
end
glon = gdata(g_idx,end-1);
glat = gdata(g_idx,end);
gnum = gdata(g_idx,end-2);
tgnum = num2str(gnum);
%%
figure
plot(lon,lat,'r.')
axis equal
for i = 1:gn
    text(glon-dx/5,glat,tgnum,'fontsize',font_s,'fontweight','bold')
end
axis equal
xlim([dlon(1) dlon(end)])
ylim([dlat(1) dlat(end)])
set(gca,'xtick',dlon(1):dx:dlon(end))
set(gca,'ytick',dlat(1):dx:dlat(end))
grid on
box on
hold on
for i = 1:length(nan_idx)-1
    patch(blon(nan_idx(i)+1:nan_idx(i+1)-1,1),blat(nan_idx(i)+1:nan_idx(i+1)-1,1),[.7 .7 .7])
    hold on    
end
patch(blon(nan_idx(end)+1:end,1),blat(nan_idx(end)+1:end,1),[.7 .7 .7])
title(['Grid East Sea (Grid Size:',num2str(dx),'^o)']);
fig_file = (['Grid_East_Sea',num2str((dx*100),'%3.3d')]);
print(fig_file,'-djpeg','-r500')