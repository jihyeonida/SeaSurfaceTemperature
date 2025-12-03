fid = fopen('post_time.txt','r');
%%

num_f = 8906;
for fn = 1:num_f
    aa = fgetl(fid);
    bb = strsplit(aa);
    lon(fn,1) = str2num(bb{2});
    lat(fn,1) = str2num(bb{3});
    mm(fn,1) = str2num(bb{4});
    dd(fn,1) = str2num(bb{5});
    hh(fn,1) = str2num(bb{6});
    mi(fn,1) = str2num(bb{7});
    fname(fn,:) = bb{8};
end
%data = fscanf(fid,'%f %f %d %d %d %d %s\n',[7 inf]);
fclose(fid);
%% 
ffid = fopen('grid_pos025.txt','r');
%%
% 7,8월 데이터만 가져온다는 뜻임.
data = [lon lat mm dd hh mi];
idx = find(mm>=7 & mm<9);
data2 = data(idx,:);
fname2 = fname(idx,:);

%boundary, bdry라고 해도 되나 내 코드가 아님.
bndy = [127.956593706, 38.8106212875
        130.117810834, 34.7292458650
        133.043766331, 34.5463736465
        133.725380963, 38.8854326496];
idx_bndy = inpolygon(data2(:,1),data2(:,2),bndy(:,1),bndy(:,2));

datax = data2(idx_bndy,:);
fnamex = fname2(idx_bndy,:);

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
outfile = (['grid_pos',num2str((dx*100),'%3.3d'),'.txt']);
fid = fopen(outfile,'w');
            %    5   10   15   20   25   30   35   40   45   50   55   60
fprintf(fid,'Order    i    j         lon         lat   mm   dd   hh   mi ');
            %  65   70   75   80   85   90
fprintf(fid,' num        glon        glat ');
            %   95  100  105  110  115  120  125  130
fprintf(fid,'                        XBT_File_Name\n');
fmt = '%5d%5d%5d%12.7f%12.7f%5.2d%5.2d%5.2d%5.2d%5.2d%12.7f%12.7f  %s\n';
nn = 0;
tnn = 0;
for i = 1:size(xx,2)-1
    for j = 1:size(yy,1)-1
        idxg = find(lon>=xx(j,i) & lon<xx(j,i+1) & lat>=yy(j,i) & lat<yy(j+1,i));
        if idxg; nn = nn+1; tnn = tnn + length(idxg); end
        n = 1;
        for k = 1:length(idxg)
            fprintf(fid,fmt,nn,i,j,lon(idxg(k)),lat(idxg(k)),mm(idxg(k)),dd(idxg(k)),hh(idxg(k)),mi(idxg(k)), ...
            n,xx(j,i)+dx/2,yy(j,i)+dx/2,fnamex(idxg(k),:));
            n = n+1;
        end
        disp(['Grid infomation: i - ',num2str(i),'  j - ',num2str(j)])
    end
end
fclose(fid);
%%
mapfile = '/Users/huiyo/Documents/HDD/과제, 연구 자료 및 시행착오 (박사 수료, 23.12.23-24.09.25)/MATLAB/coastline/coast_sin.txt';

dtd = load(mapfile);
blon = dtd(:,1); blat = dtd(:,2);
nan_idx = find(isnan(blon));
for i = 1:length(nan_idx)-1
    patch(blon(nan_idx(i)+1:nan_idx(i+1)-1,1),blat(nan_idx(i)+1:nan_idx(i+1)-1,1),[.7 .7 .7])
    hold on    
end
patch(blon(nan_idx(end)+1:end,1),blat(nan_idx(end)+1:end,1),[.7 .7 .7])

%%
gfid = fopen('data_231214.txt', 'r');
aa = fgetl(gfid);
%%
% 
% for i = 1:tnn %553
%     cc = fgetl(gfid); %안돌아감.
%     ee = strsplit(cc);
%     gord(i,1) = str2num(ee{2});
%     gi(i,1) = str2num(ee{3});
%     gj(i,1) = str2num(ee{4});
%     glong(i,1) = str2num(ee{5});
%     glatg(i,1) = str2num(ee{6});
%     gmm(i,1) = str2num(ee{7});
%     gdd(i,1) = str2num(ee{8});
%     ghh(i,1) = str2num(ee{9});
%     gmi(i,1) = str2num(ee{10});
%     gnumx(i,1) = str2num(ee{11});
%     glonx(i,1) = str2num(ee{12});
%     glatx(i,1) = str2num(ee{13});
% %     gdata = fscanf(gfid,'%d%d%d%f%f%d%d%d%d%d%f%f',[12 inf]);
% end
% %fclose(gfid);
%%
gdata = [gord gi gj glong glatg gmm gdd ghh gmi gnumx glonx glatx];
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
title(['Grid East Sea (Grid Size:',num2str(dx),'^o)']);
fig_file = (['Grid_East_Sea',num2str((dx*100),'%3.3d')]);
print(fig_file,'-djpeg','-r500')
hold off