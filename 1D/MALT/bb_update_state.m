function G = example1_ud_state(M,G,F,simtime,simdir)

% Example routine for setting user-defined states
%
% DESCRIPTION:
%    Bunch of examples for forcing user-defined states
%
% INPUT:
%    M: mesh structure
%    G: MALT data structure
%    F: forcing structure
%    simtime: simulation time in MJD
%
% OUTPUT:
%    G with updated particle states
%
% EXAMPLE USAGE
%    G = ud_state_func(M,F,G,simtime) [assuming ud_state_func = @example1_ud_state]
%
% Author(s):  
%    Geoff Cowles (University of Massachusetts Dartmouth)
%
% Revision history
%
% Note:
%
%    status: status of particle
%       -3:  settled
%       -2:  dead 
%       -1:  individual exited domain
%        0:  unknown status
%        1:  alive and active
%   
%==============================================================================


%------------------------------------------------------------------------------
% set a vertical swimming velocity (m/s)
%   a negative velocity is a sinking velocity.  
%   a positive velocity could represent buoyancy.  
%
%  In both cases, if a vertical random walk is
%   active, the vertical distribution will be a balance of this velocity with
%   turbulence.
%------------------------------------------------------------------------------
%G.wswim = -.01;

%------------------------------------------------------------------------------
% identify all particles with days at liberty larger than settle_time
% set status of these particles to SETTLED (-3)
%------------------------------------------------------------------------------
 settle_time = 14;  %days
 if(simdir==1)
 	pts = find((simtime-G.trel) > settle_time);
 else
 	pts = find((G.trel-simtime) > settle_time);
 end;
 	
 G.status(pts) = -3;


%------------------------------------------------------------------------------
% set particle depth (positive distance below surface) strictly
%------------------------------------------------------------------------------
%G = set_vert_coord(G,'d',2,0.0);  
	
%------------------------------------------------------------------------------
% set particle z-coordinate strictly
%------------------------------------------------------------------------------
%G = set_vert_coord(G,'z',-3,0.0);

%------------------------------------------------------------------------------
% set particle height above bottom
%------------------------------------------------------------------------------
%G = set_vert_coord(G,'b',1,0.0);

%------------------------------------------------------------------------------
% set particle s-coordinate strictly
%     = 0, constrain to surface
%     = -1, constrain to bottom
%     = -.5, middle of water column
%------------------------------------------------------------------------------
%G = set_vert_coord(G,'s',-.2,0.0);

%------------------------------------------------------------------------------
% set particle depth of specific particles
%------------------------------------------------------------------------------
%mature = find(G.stage==3);    
%G = set_vert_coord(G,'d',2,0.0,[1,2]);

%------------------------------------------------------------------------------
% use vertical velocity to relax individuals towards a given z-coordinate
%  if vertical-random walk is active, the final distribution will be a balance
%  of vertical turbulence and attraction to the z-coordinate through swimming
%------------------------------------------------------------------------------
%pts = find(G.status==1);
%relax_timescale = .04; % relaxation time scale in days
%G = set_vert_coord(G,'d',2,relax_timescale,pts);
%G = set_vert_coord(G,'z',-7,relax_timescale,pts);
%G = set_vert_coord(G,'b',2,relax_timescale,pts);
%G = set_vert_coord(G,'s',-.2,relax_timescale,pts);

%------------------------------------------------------------------------------
% diel movement - setting z exactly
%------------------------------------------------------------------------------

%------------------------------------------------------------------------------
% diel movement - using attractors
%------------------------------------------------------------------------------


