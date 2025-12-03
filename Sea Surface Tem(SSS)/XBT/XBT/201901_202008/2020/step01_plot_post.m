 
close all; clear all; clc;

%!dir/b *.idf > list.txt

skip_l1 = 6;
skip_l2 = 5;
% skip_l = 12;

num_f = 8906;
fl = fopen('list.txt');

% !md figure
for fn = 1:num_f
    file = fgetl(fl);
    fid = fopen(file);
    add = file(23:32);
    for i = 1:skip_l1
        dum = fgetl(fid);
    end
    n = fscanf(fid,'%d\n',[1 1]);
    for i = 1:skip_l2
        dum = fgetl(fid);
    end
    for j = 1:n
        aa = fgetl(fid);
        bb = strsplit(aa);
        lon1 = bb{1}; % lon = str2num(lon1(1:9));
        lat1 = bb{2}; % lat = str2num(lat1(1:8));
        t = bb{3}; 
        yy = str2num(t(1:4)); 
        mm = str2num(t(5:6));
        dd = str2num(t(7:8)); 
        hh = str2num(t(10:11)); 
        mi = str2num(t(12:13)); 
        ss = str2num(t(14:15));
        dep1 = bb{4}; dep(j,1) = str2num(dep1);
        tem1 = bb{5}; tem(j,1) = str2num(tem1);
    end
    fclose(fid);
    lon(fn,1) = str2num(lon1(1:3)) + str2num(lon1(4:5))/60 + str2num(lon1(6:7))/3600;
    lat(fn,1) = str2num(lat1(1:2)) + str2num(lat1(3:4))/60 + str2num(lat1(5:6))/3600;
    mon(fn,1) = mm;
    day(fn,1) = dd;
    hour(fn,1) = hh;
    minu(fn,1) = mi;
    fname(fn,:) = file;
%     tlon = num2str(lon(fn,1),'%12.7f');
%     tlat = num2str(lat(fn,1),'%12.7f');
%     tyy = num2str(yy,'%4.4d');
%     tmm = num2str(mm,'%2.2d');
%     tdd = num2str(dd,'%2.2d');
%     thh = num2str(hh,'%2.2d');
%     tmi = num2str(mi,'%2.2d');
%     
%     figure(1)
%     plot(tem,dep,'.-k')
%     set(gca,'ydir','reverse')
%     xlabel('Temperature (^oC)')
%     ylabel('Depth (m)')
%     
%     tl = ([tyy,tmm,tdd,'-',thh,':',tmi,' Lon: ',tlon,' Lat: ',tlat]);
%     title(tl)
%     
%     out = (['.\figure\',tyy,tmm,tdd,'-',thh,tmi,'-',add]);
%     print(out,'-dtiff','-r500')
%     
%     close(figure(1))
%     clear tem; clear dep;
    disp(fn)
end

% pos = [lon lat];
% fid = fopen('post.txt','w');
% fprintf(fid,'%12.7f%12.7f\n',pos');
% fclose(fid);

pos_time = [lon lat mon day hour minu];
fid = fopen('post_time.txt','w');

% fprintf(fid,'%12.7f%12.7f%5.2d%5.2d%5.2d%5.2d\n',pos_time');
for fn = 1:num_f
    fprintf(fid,'%12.7f%12.7f%5.2d%5.2d%5.2d%5.2d  %s\n',lon(fn),lat(fn),mon(fn),day(fn),hour(fn),minu(fn),fname(fn,:));
end
fclose(fid);

