function [u,du2] = frontvel(t,x,y,z)
%function [u,du] = frontvel(t,x,y,z)
%
% from a list of observations
% t = time
% x = x-coordinate
% y = y-coordinate
% z = z-coordinate [optional]
% assumes the front is locally straight relative to the observation array
% technically it fits the inverse phase speed
%
%
%
% Given N observations there are
% N*(N-1)/2 differences in arrival times
M = length(t)*(length(t)-1)/2;
% a place to put the arrival time distance
dt = zeros(1,M);
% location distance
dx = zeros(1,M);
% do it in 2-D if a second co-ordinate is specified
if(nargin>2)
 dy = zeros(1,M);
% do it in 3-D if a third co-ordinate is specified
 if(nargin>3)
  dy = zeros(1,M);
 end%if
end%if
% Fill out the inter-observation differences
k = 0;
for i=1:length(x)
 for j=i+1:length(x)
  k = k+1;
  dt(k) = t(i)-t(j);
  dx(k) = x(i)-x(j);
  if(nargin>2)
   dy(k) = y(i)-y(j);
   if(nargin>3)
    dz(k) = z(i)-z(j);
   end%if
  end%if
 end%for
end%for
% Here begins the least squres fitting
A=[dx];
if(nargin>2)
 A = [A;dy];
 if(nargin>3)
  A = [A;dz];
 end%if
end%if
% Minimizes the difference
% by solving for the inverse phase speed c~[time/dist]
% (dt-c*A')^2
% take the derivative with respect to c
% d/dc [ (dt-c*A')^2 ] = 0
% and slove
% A * A' * c =  A*dt' 
% c = inv(A*A')*A*dt'
% The matrix A * A' will come up a lot so lets give it a name
Asq = A*A';
% Practically it is better to let octave/matlab solve the linear equation
% inverting Asq can introduce numerical errors
c = linsolve(Asq,A*dt');
% phasee speed [dist/time]
u = c'./sum(c.*c);
%
% We're done calculting the front speed here
%
% To estimate the uncertainty we need
%
% The error 
err = dt'-A'*c;
%
% and the degrees of freedom
% # of independent measurements - # of fit parameters
Ndof = length(t)-length(c);
%
%
% Calculate (if possible) the uncertainty in c
if(Ndof-1>0)
 sigsq = sum(err.*err)/(Ndof-1);
% use number of radar images rather than number of points to calculate error
 sigsq2 = sum(err.*err)/(56*2); 
 dc = sqrt(sigsq./sum(abs(Asq)));
% use number of radar images rather than number of points to calculate error
 dc2 = sqrt(sigsq2./sum(abs(Asq))); 
else
 dc = NaN*c;
end%if
du = dc*sum(u.*u);
% use number of radar images rather than number of points to calculate error
du2 = dc2*sum(u.*u); 
end%function
