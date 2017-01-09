clear all
% Randomly choose points
% for observations
%
% Number of observation points
N = 16;
A = 1;
S = 1;
x = (rand(3,N)-.5)*2*A;
% randomly choose a velocity
u = rand(1,3);
% normalize to magnitude 1
u = u/sqrt(u*u');
% assuming the front is perpendicular
% to the front velocity then
% the condition for an observation is
% (x-u*t)*u+(y-v*t)*v+(z-w*t)*w=0
t = (u*x)/(u*u');
s = t+S*2*A*(rand(1,N)-.5*ones(size(t)));
%
% now we have the fake data
% x is a list of x-coordinates of the observations
% y is a list of y-coordinates of the observations
% t is a list of times of the observations
% s is a list of times + noise
%
[ut,dut] = frontvel(t,x(1,:),x(2,:),x(3,:));
[us,dus] = frontvel(s,x(1,:),x(2,:),x(3,:));
[[ut-u;us-u],sqrt(sum([ut.^2;us.^2],2))-[1;1]]
[[abs(ut-u)./dut;abs(us-u)./dus],abs(sqrt(sum([ut.^2;us.^2],2))-[1;1])./sqrt(sum([dut.^2;dus.^2],2))]
figure(1)
subplot(1,1,1)
plot3(x(1,:),x(2,:),x(3,:),'x;;');
axis([-1,1,-1,1,-1,1]*max(max(abs(x))))
title("observation locations, vectors");
hold('on')
quiver3(0,0,+0.0,A*u(1) ,A*u(2) ,A*u(3))
quiver3(0,0,+0.1,A*ut(1),A*ut(2),A*ut(3))
quiver3(0,0,-0.1,A*us(1),A*us(2),A*us(3))
hold('off')
