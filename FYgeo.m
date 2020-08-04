clc;
clear;
LOFF = 1375.5;    %行偏移 500m：10991.5 1000m：5495.5 2000m：2747.5 4000m：1373.5  unit in km
LFAC = 10233137;   %行比例因子 500m：81865099 1000m：40932549 2000m：20466274 4000m：10233137  unit in km
CFAC = 10233137;  %列比例因子 500m：81865099 1000m：40932549 2000m：20466274 4000m：10233137  unit in km
COFF = 1375.5;  %列偏移 500m：10991.5 1000m：5495.5 2000m：2747.5 4000m：1373.5  unit in km
PI = pi; 
ea = 6378.137;    %地球的半长轴  unit in km
eb = 6356.7523;   %地球的短半轴  unit in km
h = 42164;  %地心到卫星质心的距离 unit in km
lambda_d = 104.7;  %卫星星下点所在 经度 
lon1=zeros(2748,2748);
lat1=zeros(2748,2748);
for i=0:2747
    for j=0:2747
            x = PI*(i-COFF)/(180*(power(2,-16))*CFAC);
            y = PI*(j-LOFF)/(180*(power(2,-16))*LFAC);
            a=power(h*cos(x)*cos(y),2)-(power(cos(y),2)+(ea^2/eb^2)*power(sin(y),2))*(h^2-ea^2);
            if a>0
                sd = sqrt(a);
                sn = (h*cos(x)*cos(y)-sd)/(power(cos(y),2)+(ea^2/eb^2)*power(sin(y),2));
                s1 = h - sn*cos(x)*cos(y);
                s2 = sn*sin(x)*cos(y);
                s3 = -1*sn*sin(y);
                sxy = sqrt(s1^2+s2^2);
                lon1(i+1,j+1) =double(180/PI*atan(s2/s1) + lambda_d);
                lat1(i+1,j+1) =double(180/PI*atan((ea^2/eb^2)*(s3/sxy)));
            else
                lon1(i+1,j+1)=nan;
                lat1(i+1,j+1)=nan;
            end
    end
end
