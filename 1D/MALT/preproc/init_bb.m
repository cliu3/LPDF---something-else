% example file for initializing an offline Lagrangian tracking model (or IBM)
%
% function init_bb 
%
% DESCRIPTION:
%    Dump initial particle positions and release (spawning) times to a netcdf file
%
% INPUT
%   
% OUTPUT:
%    Initial particle position file
%
% Author(s):  
%    Geoff Cowles (University of Massachusetts Dartmouth)
%
% Revision history
%   
%==============================================================================
close all; clear all;
%------------------------------------------------------------------------------
% set parameters 
%------------------------------------------------------------------------------

lag_pos_file = 'init_bb.nc';
lag_pos_file_ascii = 'init_bb.dat';
grid_file = '~/Dropbox/IBM/MALT/examples/preproc/scp4.1_grid.nc';
kml_file = 'ClevelandLedge.kml';
mytitle = 'kml test';
multifac = 4;
nlag = 6000;
t_release_start = greg2mjulian(2009,06,1,0,0,0);  
t_release_end   = greg2mjulian(2009,06,1,0,0,0);   
spawning_sigma = 5; %standard deviation of spawning distribution in days


t_release = -99*ones(nlag,1);  %time of release in modified Julian day
x_release = zeros(nlag,1);  %x-coordinate of release location
y_release = zeros(nlag,1);  %y-coordinate of release location
s_release = zeros(nlag,1);  %s-coordinate of release location

%------------------------------------------------------------------------------
% read in grid and bathymetry
%------------------------------------------------------------------------------
nc = netcdf(grid_file);
x = nc{'x'}(:);
y = nc{'y'}(:);
h = nc{'h'}(:);
tri = nc{'nv'}(:,:)';
nVerts = numel(x);
[nElems,dum] = size(tri);
fprintf('min depth %f max depth %f\n',min(h),max(h));
fprintf('bathymetry reading complete\n');
close(nc);


%------------------------------------------------------------------------------
% set a uniform distribution in a google-earth defined domain with   
% release varying over  
%------------------------------------------------------------------------------

% read in the kml file
[latb,lonb,dumz] = read_kml(kml_file);
fprintf('projecting to Euclidean\n')
[xb,yb] = sp_proj('1802','forward',lonb,latb,'m');
x1 = min(xb);
x2 = max(xb);
y1 = min(yb);
y2 = max(yb);

% create a uniform grid of points containing the kml perimeter
% use twice the number of points because we want at least nlag inside the kml box
% we will cull randomly later to get to nlag
x_release = x1 + (x2-x1).*rand(nlag*multifac,1);
y_release = y1 + (y2-y1).*rand(nlag*multifac,1);

% tag the points inside the box
mark = inpolygon(x_release,y_release,xb,yb); 
pts = find(mark==1);


% make sure we have enough
ncull = length(pts) - nlag;
if(ncull < 0)
	fprintf('found %d points in the kml zone\n',length(pts))
	fprintf('you wanted %d points\n',nlag)
	error('not enough points in the kmlbox, increase multifac\n')
end;


% report number
fprintf('distributed %d points in the kml perimeter\n',length(pts))
fprintf('culling %d points randomly\n',ncull);

% randomly select points to remove
random_order = shuffle(1:length(pts));
retain = pts(random_order(ncull+1:length(pts))); 
x_release = x_release(retain);
y_release = y_release(retain);

figure
patch('Vertices',[x,y],'Faces',tri,...
        'Cdata',h,'edgecolor','interp','facecolor','interp');
caxis([0,100])
hold on;
plot(x_release,y_release,'w+');


%------------------------------------------------------------------------
% set release time
%------------------------------------------------------------------------

% set release time using normal distribution
if(t_release_start ~= t_release_end);
figure
ndays = t_release_end-t_release_start;
probs = round(nlag*normpdf(1:ndays,ndays/2+1,spawning_sigma));
plot(0:ndays-1,probs);
xlabel('release time (days from start)');
ylabel('number of releases in a day');

% randomly select particles to be released on each day
% issue is that randomly selecting integers from a small set of integers
% can result in repeats, for example, randomly selecting five integers
% from 1:10 can result in 1,4,2,4,5 being selected, thus we would 
% only be removing four integers from the set
tvec = t_release_start:1:t_release_end-1;
% shuffle a vector
random_order = shuffle(1:nlag);
i1 = 1;
for i=1:ndays
   if(probs(i) > 0)
     i2 = i1 + probs(i)-1;
     t_release(random_order(i1:i2)) = tvec(i); 
     i1 = i2 + 1;
   end
end;
% still some issue with shuffling, but minor, quick fix here
pts = find(t_release<0); 
if(~isempty(pts))
  t_release(pts) = mean(tvec);
end;
figure
plot(t_release-min(t_release),1:nlag,'r+')
%axis([t_release_start,t_release_end,0,nlag]);
xlabel('days after initial release')
ylabel('particle # released on that day');

else %release start and end are the same, assign uniform t_release

t_release = t_release_start*ones(nlag,1);

end;

% set group id
tmid = mean(t_release);
pts = t_release <  tmid; gid(pts) = 0; %early spawners
pts = find(t_release >= tmid); gid(pts) = 1; %late spawners


% set s-coordinate of release (0 = surface, .5 = mid-depth, -1, bottom)
s_release = 0.0*s_release;                 %release at surface


%--------------------------------------------------------------
% dump to netcdf file
%--------------------------------------------------------------
write_offline_lagfile(lag_pos_file,mytitle,x_release, ...
    y_release,s_release,'s',t_release,gid);

%--------------------------------------------------------------
% dump to ascii file 
%--------------------------------------------------------------
write_offline_lagfile_ascii(lag_pos_file_ascii,mytitle,x_release, ...
    y_release,s_release,'s',t_release);
