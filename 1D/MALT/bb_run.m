% Example MALT parameter file 
%
% example_params
%
% DESCRIPTION:
%    example parameter file for IBM simulation with MALT
%
% INPUT:
%   
% OUTPUT:
%    
% EXAMPLE USAGE
%    not a standalone code, invoked by main program (malt.m)
%
% Author(s):  
%    Geoff Cowles (University of Massachusetts Dartmouth)
%
% Revision history
%   
%==============================================================================


%------------------------------------------------------------------------------
% integration parameters
%
% tbeg:   begin time for simulation [year,month,day,hour,minute,second]
% tend:   end time for simulation   [year,month,day,hour,minute,second]
% deltaT: time step in seconds
% spatial_dim: spatial dimension 
%              = 1 (z)
%              = 2 (x,y)
%              = 3 (x,y,z)
% RK_method: Runge-Kutta scheme for integrating scheme
%              = 0 Use 1-stage Explicit Euler step for integration 
%              = 1 Use classical 4-Stage RK4 scheme
% interp_method: option for interpolation of model forcing on particle positions
%              = 0 Use 0th order of scalars (u,v,S,T) to particle positions
%              = 1 Use FVCOM-based linear interpolation of fields
%              = 2 Use Matlab-based linear interpolation of fields 
% bndry_cond: boundary condition for particles at the wall
%              = 0 allow particles to exit domain through coast
%              = 1 do not allow particles to penetrate coast - reset to last position
% 
% Note:
%  if tend > tbeg, model will perform forwards in time tracking (FITT)
%  if tbeg > tend, model will perform backwardsin time tracking (BITT)
%------------------------------------------------------------------------------

tbeg = greg2mjulian(2009,06,1,0,0,0);  
tend = greg2mjulian(2009,08,1,0,0,0);
deltaT        = 240.0;            
spatial_dim   = 3; 
RK_method     = 1;
interp_method = 1;
bndry_cond    = 1;

deltaT = abs(deltaT); %ensure positive time step
        
%------------------------------------------------------------------------------
% model diffusion
% hdiff_type:  selector for horizontal diffusion scheme
%             = 0 no horizontal diffusion
%             = 1 constant value (hdiff_const) random walk
%             = 2 something yet to be implemented
%
% vidff_type:  selector for vertical diffusion scheme
%             = 0 no vertical diffusion
%             = 1 random walk with constant value (vdiff_const)
%             = 2 Visser random walk with variable eddy diffusivity
%             = 3 binned random walk (not yet implemented)
%
% vdiff_nstep:  number of substeps for vertical diffusion scheme  (> 0)            
% 
% tens_spline: switch for activiting tensioned splines (active for vdiff > 1)
%             = 1 reconstruct eddy diffusivity field using tensioned splines
%             = 0 do not reconstruct eddy diffusivity fields
%
% Note:
%  a.) vdiff only active for spatial_dim = 1 or 3
%  b.) hdiff only active for spatial_dim = 2 or 3
%  c.) if model is running backwards in time, diffusion will be deactivated
%------------------------------------------------------------------------------

hdiff_type = 0;
hdiff_const = .1;

vdiff_type = 1;
vdiff_const = 0.0;
tens_spline = 0;
vdiff_nstep = 10;

%------------------------------------------------------------------------------
% add fields to structure for use in postprocessing or biology
% comment if no extra fields are needed
%------------------------------------------------------------------------------

user_defined_fields = @bb_add_state;; 

%------------------------------------------------------------------------------
% user defined states (e.g. biology)
%
% ud_state:       switch [=1, active, =0 not active]
% ud_state_func:     pointer to user defined advanced function
% ud_state_intvl: interval at which to advance user-defined states (s)
%
%------------------------------------------------------------------------------

ud_state = 1;
ud_state_func = @bb_update_state;  
ud_state_intvl = 3600;

%------------------------------------------------------------------------------
% initial particle position file (full path)
%------------------------------------------------------------------------------

init_lag_file = './preproc/init_bb.nc';  

%------------------------------------------------------------------------------
% forcing file (full path)
% 
% Note:
%  if spatial_dim = 1:    forcing file is a GOTM NetCDF output file
%  if spatial_dim = 2,3:  forcing file is an FVCOM NetCDF file
%
% from_thredds
%           = true, forcing file is accessed through a thredds server
%                   This will require having installed the netcdf-java interface 
%                   for MATLAB.  See: 
%                   http://sourceforge.net/apps/trac/njtbx/wiki/
%           = false, forcing file is locally accessible
%
%------------------------------------------------------------------------------
forcing_file = '/Volumes/zuse/BUZZBAY/HINDCASTS/local/output/scp4.1_ss2009_hind_v2.nc';  
from_thredds = false;

%------------------------------------------------------------------------------
% archiving parameters
%  archive_file:  NetCDF output file containing time-dependent particle data
%  archive_intvl: archiving interval in seconds, 
%                  = 0 for no archiving
%                  = -1 for archiving initial and final particle positions only
%------------------------------------------------------------------------------

archive_file = '/Users/cliu/bb_out.nc';
archive_intvl = 3600; 

%------------------------------------------------------------------------------
% plotting and reporting parameters
%
% plot_intvl:   interval in seconds at which to update realtime particle display
%               = 0 for NO DISPLAY
% plot_stride:  plot every plot_stride particles
% report_intvl  interval in seconds at which to dump summary of particle status
%               to screen.  =0 for NO DUMP
%------------------------------------------------------------------------------

plot_intvl   = 0;
plot_stride  = 1;    
report_intvl = 1200;

%------------------------------------------------------------------------------
% code parameters
%------------------------------------------------------------------------------

multicore_acceleration = 0;
