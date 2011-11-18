%%
clear all;close all;
% open nc file and read data
fname='my2_0001.nc';

nc=netcdf(fname);
x=nc{'x'}(:);
y=nc{'y'}(:);
nv=nc{'nv'}(:)';
% calculate coordinates for centroids
xc=mean(x(nv),2);
yc=mean(y(nv),2);


zeta=nc{'zeta'}(:);
temp=nc{'temp'}(:);
salinity=nc{'salinity'}(:);
u=nc{'u'}(:);
v=nc{'v'}(:);
h=nc{'h'}(:);
siglay=nc{'siglay'}(:);


%%
p1=[4.729e5,3.347e6];
p2=[5.041e5,3.34e6];
xl=linspace(p1(1),p2(1));
yl=linspace(p1(2),p2(2));

hl=gIDW(x,y,h,xl,yl,-2);
zetal=gIDW(x,y,zeta(100,:)',xl,yl,-2);

z=gIDW(x,y,siglay(1,:)',xl,yl,-2);
for i=2:5
    z=[z;gIDW(x,y,siglay(i,:)',xl,yl,-2)];
end
[hl_5,~]=meshgrid(hl,1:5);
[zetal_5,~]=meshgrid(zetal,1:5);
[xl_5,~]=meshgrid(xl,1:5);
z=(hl_5+zetal_5).*z+zetal_5;

% sl=gIDW(x,y,squeeze(salinity(100,1,:)),xl,yl,-2);
% for i=2:5
%     sl=[sl;gIDW(x,y,squeeze(salinity(100,i,:)),xl,yl,-2)];
% end

sl=gIDW(xc,yc,squeeze(u(100,1,:)),xl,yl,-2);
for i=2:5
    sl=[sl;gIDW(xc,yc,squeeze(u(100,i,:)),xl,yl,-2)];
end

contourf(xl_5,z,sl)