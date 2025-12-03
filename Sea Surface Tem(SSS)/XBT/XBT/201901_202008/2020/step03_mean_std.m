
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
% gdata = [gord gi gj glong glatg gmm gdd ghh gmi gnumx glonx glatx];
%%
%!md figure_n
skip_l1 = 6; % XBT file upper head lines
skip_l2 = 5; % XBT file lower head lines
for i = 1:gord(end,1)
% for i = 1:1
    idx = find(gord==i);
    t_tem = zeros(length(std_dep),length(idx));
    t_tem(:,:) = NaN;
    xlon = glonx(idx(end));
    xlat = glatx(idx(end));
    xord = gord(idx(end));
    for j = 1:length(idx)
        file = fname(j,:);
        fid = fopen(file);
        for k = 1:skip_l1
            dum = fgetl(fid);
        end
        n = fscanf(fid,'%d\n',[1 1]);
        for k = 1:skip_l2
            dum = fgetl(fid);
        end
        for k = 1:n
            aa = fgetl(fid);
            bb = strsplit(aa);
%             lon1 = bb{1}; % lon = str2num(lon1(1:9));
%             lat1 = bb{2}; % lat = str2num(lat1(1:8));
            dep1 = bb{4}; dep(k,1) = str2num(dep1);
            tem1 = bb{5}; tem(k,1) = str2num(tem1);
        end
        fclose(fid);
        inc(1,1) = inc1;
        for k = 2:length(std_dep)
            inc(k,1) = std_dep(k) - std_dep(k-1);
        end
        for l = 1:length(std_dep)
            idx_d = find(dep<std_dep(l)+inc(l)/2 & dep>= std_dep(l)-inc(l)/2);
            if idx_d
               t_tem(l,j) =tem(idx_d);
            end
        end
        figure(1)
        subplot(1,4,[1 2 3])
        hold on
        p1 = plot(t_tem(:,j),std_dep,'x-b');
        clear tem; clear dep;
        disp(['Order Number: ',num2str(i),', Total Number: ',num2str(j)])
    end
    mtem(:,i) = nanmean(t_tem,2);
    tem_std = nanstd(t_tem');
    stem(:,i) = tem_std';
    p2 = plot(mtem(:,i),std_dep,'.-r','linewidth',2);
    xlim([0 30])
    ylim([0 500])
    xlabel('Temperature (^oC)')
    ylabel('Depth (m)')
    set(gca,'ydir','reverse')
    
    txlon = (['Grided Lon. : ',num2str(xlon,'%10.3f\n')]);
    txlat = (['Grided Lat. : ',num2str(xlat,'%10.3f\n')]);
    txord = (['Order : ',num2str(xord,'%5d\n')]);
    tn    = (['Number of Data : ',num2str(length(idx),'%5d\n')]);
    text(15,300,txlon)
    text(15,325,txlat)
    text(15,350,txord)
    text(15,375,tn)
    box on
    set(gca,'linew',2)
    legend([p1 p2],{'Data','Mean'},'location','southeast')
    
    subplot(1,4,4)
    plot(stem(:,i),std_dep,'.-r','linewidth',2)
    xlim([0 3])
    ylim([0 500])
    xlabel('STD. (^oC)')
    set(gca,'ydir','reverse')
    box on
    set(gca,'linew',2)
    
    out = (['.\figure_n\Order',num2str(i,'%3.3d')]);
    print(out,'-dtiff','-r500')
     print('test','-dtiff','-r500')
    close(figure(1))
    
    lonxbt(i,1) = xlon;
    latxbt(i,1) = xlat;
end
%%
save lonxbt.mat lonxbt
save latxbt.mat latxbt
save stem.mat stem
save mtem.mat mtem
save std_dep.mat std_dep
%%
% % ============================= plot map ==================================
mapfile = '/Users/huiyo/Documents/HDD/과제, 연구 자료 및 시행착오 (박사 수료, 23.12.23-24.09.25)/MATLAB/coastline/coast_sin.txt';
data = load(mapfile);
blon = data(:,1); blat = data(:,2);
nan_idx = find(isnan(blon));
figure
for i = 1:length(nan_idx)-1
    patch(blon(nan_idx(i)+1:nan_idx(i+1)-1,1),blat(nan_idx(i)+1:nan_idx(i+1)-1,1),[.7 .7 .7])
    hold on    
end
patch(blon(nan_idx(end)+1:end,1),blat(nan_idx(end)+1:end,1),[.7 .7 .7])

