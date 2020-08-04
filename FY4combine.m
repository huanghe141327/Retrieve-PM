function FY4(year,month)
%year=2019;
%month=1;

addpath('/home/huoyanfeng/FYcode')

if (month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12)
    nday=31;
elseif (month==4 || month==6 || month==9 || month==11)
    nday=30;
elseif (mod(year,4)==0 && month==2)
    nday=29;
else
    nday=28;
end

agri_pm=importdata('/home/huoyanfeng/agri_pm2019.mat');

uhour  = unique(agri_pm.hour_utc);
uyear  = unique(agri_pm.year_utc);
umonth = unique(agri_pm.month_utc);
uday   = unique(agri_pm.day_utc);


FY=[];
ind3= find(agri_pm.month_utc == month);
N=ind3(1);
for day=1:nday
	tic	
 for hour=0:23
  


filepath=['/mnt/FY4/FY4A/AGRI/L1/FDI/DISK/',num2str(year,'%.4d'),'/',num2str(year,'%.4d'),num2str(month,'%.2d'),num2str(day,'%.2d'),'/'];

fn=dir([filepath,'FY4A-_AGRI--_N_DISK_1047E_L1-_FDI-_MULT_NOM_',num2str(year,'%.4d'),num2str(month,'%.2d'),num2str(day,'%.2d'),num2str(hour,'%.2d'),'0000_*_4000M_V0001.HDF']);
file=[filepath,fn.name];

try 

for i=1:14
    name_string3=['NOMChannel' num2str(i,'%02d')];
    name_string4=['CALChannel' num2str(i,'%02d')];%lut
    NOM=hdf5read(file, name_string3);
    CAL=hdf5read(file, name_string4);%lut
    NOM=int32(NOM);
    
    if (i<7) 
     
      for j=1:length(agri_pm.row)
             if(CAL(NOM(agri_pm.row(1,j),agri_pm.col(1,j)))>0 & CAL(NOM(agri_pm.row(1,j),agri_pm.col(1,j)))<=1.5)
                a1(1,j)=CAL(NOM(agri_pm.row(1,j),agri_pm.col(1,j)));
             else
             	 a1(1,j)=nan;
            end
     end
     
     else 
    	
    	for j=1:length(agri_pm.row)
             if(CAL(NOM(agri_pm.row(1,j),agri_pm.col(1,j)))>100 & CAL(NOM(agri_pm.row(1,j),agri_pm.col(1,j)))<500)
                a1(1,j)=CAL(NOM(agri_pm.row(1,j),agri_pm.col(1,j)));
             else
             	a1(1,j)=nan;
            end
        end
    end

    eval(['nc',num2str(i,'%02d'),'=','a1',';']);
end

fs=dir([filepath,'FY4A-_AGRI--_N_DISK_1047E_L1-_GEO-_MULT_NOM_',num2str(year,'%.4d'),num2str(month,'%.2d'),num2str(day,'%.2d'),num2str(hour,'%.2d'),'0000_*_4000M_V0001.HDF']);
fsn=[filepath,fs.name];

SAA=hdf5read(fsn,'NOMSatelliteAzimuth');%(0,180)
SAZ=hdf5read(fsn,'NOMSatelliteZenith');%(0,360)
SOA=hdf5read(fsn,'NOMSunAzimuth');%(0,360)
SOZ=hdf5read(fsn,'NOMSunZenith');%(0,180)
for j=1:length(agri_pm.row)

FY.SAA(N,j)=SAA(agri_pm.row(j),agri_pm.col(j));
FY.SAZ(N,j)=SAZ(agri_pm.row(j),agri_pm.col(j));
FY.SOA(N,j)=SOA(agri_pm.row(j),agri_pm.col(j));
FY.SOZ(N,j)=SOZ(agri_pm.row(j),agri_pm.col(j));
end

FY.ch01(N,:)=nc01;
FY.ch02(N,:)=nc02;
FY.ch03(N,:)=nc03;
FY.ch04(N,:)=nc04;
FY.ch05(N,:)=nc05;
FY.ch06(N,:)=nc06;%vaild number range (0,1.5)
FY.ch07(N,:)=nc07;
FY.ch08(N,:)=nc08;
FY.ch09(N,:)=nc09;
FY.ch10(N,:)=nc10;
FY.ch11(N,:)=nc11;
FY.ch12(N,:)=nc12;
FY.ch13(N,:)=nc13;
FY.ch14(N,:)=nc14;%vaild number range (100,500)
%FY.date{N}=strcat(num2str(year,'%.4d'),num2str(year,'%.4d'),num2str(month,'%.2d'),num2str(day,'%.2d'));
FY.year(N)=year;
FY.month(N)=month;
FY.day(N)=day;
FY.hour(N)=hour;
FY.pm25(N,:)=agri_pm.pm25(N,:);
FY.lat(N,:)=agri_pm.lat;
FY.lon(N,:)=agri_pm.lon;

catch
disp(['error:',file])
end
N=N+1;
disp(['number:',num2str(N)])

end
toc
end

save(['/pub/work/huoyf/FY/FY',num2str(year,'%.4d'),num2str(month,'%.2d'),'.mat'],'FY');

