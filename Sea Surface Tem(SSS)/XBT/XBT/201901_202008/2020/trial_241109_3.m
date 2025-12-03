[Lon Lat] = meshgrid(lon, lat);

%%
F = scatteredInterpolant(lon', lat', datax', 'natural', 'linear');
value_grid = F(lon, lat);
%%
figure
pcolor(xx, yy, data2)
%%
t_tem = zeros(length(std_dep),length(idx));
t_tem(:,:) = NaN;
t_tem_3D = zeros(length(std_dep), length(idx), 72);% 깊이, XBT가 있는 위치 개수 %전체 xbt 개수.
    
%%
skip_l1 = 6; % XBT file upper head lines
skip_l2 = 5; % XBT file lower head lines
for i = 1:gord(end,1)
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
        clear tem; clear dep;

    end
    mtem(:,i) = nanmean(t_tem,2);
    tem_std = nanstd(t_tem');
    stem(:,i) = tem_std';
    lonxbt(i,1) = xlon;
    latxbt(i,1) = xlat;
end

%%

skip_l1 = 6; % XBT file upper head lines
skip_l2 = 5; % XBT file lower head lines
t_tem_cell = cell(gord(end,1), 1); % 셀 배열 생성

for i = 1:gord(end,1)
    idx = find(gord==i);
    t_tem = zeros(length(std_dep), length(idx));
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
        n = fscanf(fid, '%d\n', [1 1]);
        for k = 1:skip_l2
            dum = fgetl(fid);
        end
        for k = 1:n
            aa = fgetl(fid);
            bb = strsplit(aa);
            dep1 = bb{4}; dep(k, 1) = str2num(dep1);
            tem1 = bb{5}; tem(k, 1) = str2num(tem1);
        end
        fclose(fid);
        inc(1, 1) = inc1;
        for k = 2:length(std_dep)
            inc(k, 1) = std_dep(k) - std_dep(k-1);
        end
        for l = 1:length(std_dep)
            idx_d = find(dep < std_dep(l) + inc(l) / 2 & dep >= std_dep(l) - inc(l) / 2);
            if idx_d
               t_tem(l, j) = tem(idx_d);
            end
        end
        clear tem; clear dep;
    end
    
    % t_tem을 셀 배열에 저장
    t_tem_cell{i} = t_tem;
    
    mtem(:, i) = nanmean(t_tem, 2);
    tem_std = nanstd(t_tem');
    stem(:, i) = tem_std';
    lonxbt(i, 1) = xlon;
    latxbt(i, 1) = xlat;
end

%%
% 최대 열 크기를 구하여 3차원 배열 생성
max_cols = max(cellfun(@(x) size(x, 2), t_tem_cell));
t_tem_3D = NaN(length(std_dep), max_cols, length(t_tem_cell)); % 3차원 배열 생성

for i = 1:length(t_tem_cell)
    temp_matrix = t_tem_cell{i}; % 각 셀의 행렬 가져오기
    t_tem_3D(:, 1:size(temp_matrix, 2), i) = temp_matrix; % 3차원 배열에 삽입
end

%%
outfile = 'xbtarray.mat';
save(outfile,'t_tem_3D')