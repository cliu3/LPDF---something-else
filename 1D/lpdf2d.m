% 2-D lagrangian pdf simulator
clear all; close all;


%
nlag = 10000;
ntimes = 75;
deltat = .1;
Cdiff = .2; %diffusivity coefficient
mean_vel = .5; 
sigma = 3.; %standard deviation for Gaussian filter (same unit as nbin)

% set up the domain
xmesh  = [0:1:100, 0:1:100];   %bounds between cells
xc_mesh = [.5:1:99.5, .5:1:99.5]; %cell centers (100 cells)
nbin = numel(xc_mesh);
cnt = zeros(nbin,1);

% we will have 5 regions 0-20, 20-40, 40-60, etc.



% initialize source at 2 locations
xp = [ones(nlag/2,2)*30.5; ones(nlag-(nlag/2),2)*40.5];

for i=1:deltat:ntimes
  %plot(cnt); axis([0,100,0,nlag]);
  if(mod(i,1)==0)
  dist = hist3(xp,[100,100])/nlag;
%   hist3(xp/nlag,[100,100])
  end;


  % compute random walk
  xdir = 2*randi(0:1,nlag,2)-1;
  dx   = sqrt(2.0*deltat*Cdiff); 
  xp   = xp + dx*xdir;

  % add some mean advection
  xp   = xp + mean_vel*deltat;

  % bin the individuals into cells
  bin = ceil(xp);
  cnt = zeros(nbin,1);
  for n=1:nlag
    if(bin(n) > 1 && bin(n) <=nbin)
      cnt(bin(n)) = cnt(bin(n)) + 1;
    end
  end;
  if(mod(i,5)==0)
  plot(xp(:,1),xp(:,2),'r+')
  axis([0,100,0,100])
  pause(1)
  end;
end;



surf(dist);
fprintf('number of original particles %d\n',nlag)
h = fspecial('gaussian',nbin, sigma);
dist_filtered=imfilter(dist,h,'replicate','conv');
figure
surf(dist_filtered); hold on;
fprintf('%f\n',sum(sum(dist_filtered))*nlag)
% 
% 
% 
% h = fspecial('gaussian',20,sigma);
% dist_filtered=imfilter(dist,h,'replicate','conv');
% plot(dist_filtered,'r-+'); hold on;
% fprintf('%f\n',sum(dist_filtered)*nlag)
% 
% legend('orig','test1','test2')
% figure
% surf(h)% pcolor(h)
% colorbar
% %sshading interp
% 
% %close all; I = imread('cameraman.tif'); H = fspecial('gaussian',256,500);MotionBlur = imfilter(I,H,'conv');imshow(MotionBlur); fprintf('mean of I %f\n mean of Filtered Image %f\n',mean(mean(I)),mean(mean(MotionBlur)))
