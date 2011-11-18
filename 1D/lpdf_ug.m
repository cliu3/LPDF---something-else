clear all
close all
fname = '~/Dropbox/IBM/MALT/examples/run/bb_out_2008c.nc';
% nbin = 1000;
% sigma = 25;
sigmap = 1000;  %in meters
binp = 25;      %in meters
wrfac = 15;

% load the mass coastline
load coast_mass_25k_xy.mat
plot(coast(:,1),coast(:,2))

% open the mesh file
nc = netcdf('~/Dropbox/IBM/MALT/examples/preproc/scp4.1_grid.nc','nowrite');
xm = nc{'x'}(:);
ym = nc{'y'}(:);
xc = nc{'xc'}(:);
yc = nc{'yc'}(:);
hm = nc{'h'}(:);
nv = nc{'nv'}(:)';
art1 = nc{'art1'}(:)';
% [lonm,latm] = my_project(xm,ym,'inverse');

% open the particle data
nc = netcdf(fname,'nowrite');
times = nc{'time'}(:);

% read particl position data
xp = nc{'x'}(end,:);
yp = nc{'y'}(end,:);
incell = nc{'incell'}(end,:);
nlag   = numel(xp);
xr=max(xp)-min(xp);
yr=max(yp)-min(yp);

nbinx = ceil(xr/binp);
nbiny = ceil(yr/binp);
sigma = ceil(sigmap/binp);


tic
[dist,c]=hist3(([xp;yp]'),[nbinx,nbiny]);
dist=dist/(nlag*binp^2);
h = fspecial('gaussian',sigma*wrfac, sigma);
dist_filtered=imfilter(dist,h,'symmetric','conv');

dist_filtered=dist_filtered';

% patch('Vertices',[xm,ym],'Faces',nv,'Cdata',hm,'edgecolor','interp','facecolor','interp');

plot(xp,yp,'r.');hold on;
plot(coast(:,1),coast(:,2),'k','LineWidth',2);
axis([8.3e5,8.7e5,-1.6e5,-1.2e5]);
figure
pcolor(c{1},c{2},dist_filtered);shading interp;colorbar; hold on; %plot(xp,yp,'w.'); hold on;
plot(coast(:,1),coast(:,2),'k','LineWidth',2);
axis([8.3e5,8.7e5,-1.6e5,-1.2e5]);

[X,Y] = meshgrid(c{1},c{2});

% X = reshape(X,prod(size(X)),1);
% Y = reshape(Y,prod(size(X)),1);
% dist_filtered = reshape(dist_filtered,prod(size(X)),1);
% F = TriScatteredInterp(X,Y,dist_filtered);
% PDF =  F(xm,ym);

% [X,Y] = meshgrid(c{1},c{2});
xm=squeeze(xm);ym=squeeze(ym);
PDF = interp2(X,Y,dist_filtered,xm,ym);

toc
figure
patch('Vertices',[xm,ym],'Faces',nv,...
        'Cdata',PDF,'edgecolor','interp','facecolor','interp');
colorbar;axis([8.3e5,8.7e5,-1.6e5,-1.2e5]);
hold on;


PDF(isnan(PDF))=0;
dot(art1,PDF)/((xr/nbinx)*(yr/nbiny))



