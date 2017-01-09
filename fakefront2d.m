clear all
% Randomly choose points
% for observations
%
% Number of observation points
N = 4;
x = (2*rand(2,N)-1)
% randomly choose a velocity
u = rand(1,2)-.5;
u = u/sqrt(u*u');
% assuming the front is perpendicular1
% to the front velocity then
% the condition for an observation is
% (x-u*t)*u+(y-v*t)*v+(z-w*t)*w=0
% (x - u*t ) dotted into u =0
t = (u*x)/(u*u');
s = t+.25*(rand(1,N)-.5*ones(size(t)));
%
% now we have the fake data
% x is a list of x-coordinates of the observations
% y is a list of y-coordinates of the observations
% t is a list of times of the observations
% s is a list of times + noise
%
[us,dus] = frontvel(s,x(1,:),x(2,:));
[xx,yy] = meshgrid(linspace(-1,1,20),linspace(-1,1,20));
close
figure(1)
clf
#
subplot(1,1,1)
hold on
contour(xx,yy,(u(1)*xx+u(2)*yy)./(u*u'),'LineWidth',3)
colorbar
plot(x(1,:),x(2,:),'ok;;','LineWidth',3);
quiver(0*u(1), 0*u(2), u(1), u(2),'Color',[0,0,0],'LineWidth',3)
quiver(0*us(1),0*us(2),us(1),us(2),'Color',[.3,.3,.3],'LineWidth',3)
quiver(u(1),u(2),us(1)-u(1),us(2)-u(2),'Color',[.7,.7,.7],'LineWidth',2)
axis([-1,1,-1,1],"square")
title("arrival time contours, front velocity vectors, observation locations, error");
hold off
#
magdus = sqrt(abs(dus*dus'))
err = sqrt(sum((us-u).^2))
print("fakefront2d.png","-dpng",'-S1280,1024','-F:10')
