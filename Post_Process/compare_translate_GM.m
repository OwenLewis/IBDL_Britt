load ~/Documents/Julia/RadialDiffusion/PatternTests/spots_matfile_50.mat
load ../Trans_spots_Conv/512_spot_trans.mat


xmin        = -1.5;            
ymin        = -1.5;
Ly          = 3;            % height of the domain
aspect      = 1;             % aspect ratio
Lx          = aspect*Ly;     % length of th domain
xc          = 0;             % center of the IB object xc, yc
yc          = 0;
rad         = 1;
Ny=length(a(1,:));
Nx=length(a(:,1));
dy=Ly/Ny;
dx=Lx/Nx;     
x=dx*(1/2:Nx-1/2)+xmin;
y=dx*(1/2:Ny-1/2)+ymin;
[xg,yg]=ndgrid(x,y);


chi = ((xg.^2 + yg.^2) <= 1);
chi = double(chi);
I = find(chi < eps);
chi(I) = NaN;
time = t(end);
vel = 0.02;

disp = vel*time;


xstart = mod(xg - disp- xmin,Lx) +xmin;
ystart = mod(yg - disp- ymin,Ly) +ymin;
[reorderedX,indx] = sortrows(xstart);
[reorderedY,indy] = sortrows(ystart');
reorderedY = reorderedY';

mapback = a(indx,indy);


[Xfine,Yfine,Cart] = pol2cart(thetagrid,Rgrid,solA);
matlabfine = interpn(reorderedX,reorderedY,mapback,Xfine,Yfine,'spline');
discrepancy = abs(matlabfine - Cart);


titlestring = sprintf('Time = %f',time);
figure(1)
set(gcf,'Position',[152 78 1154 719])
subplot(1,2,1)
pcolor(Xfine,Yfine,Cart)
title('Julia Fine')
shading flat
colorbar
mycaxis = caxis;
subplot(1,2,2)
% pcolor(Xfine,Yfine,matlabfine)
pcolor(xg,yg,chi.*mapback)
caxis(mycaxis);
xlim([-1 1]);
ylim([-1 1]);
title('Matlab IB')
shading flat
colorbar
% subplot(2,2,3)
% pcolor(Xfine,Yfine,discrepancy)
% title('Abs. Discrep')
% shading flat 
% colorbar
% subplot(2,2,4)
% pcolor(Xfine,Yfine,discrepancy./abs(Cart))
% title('Rel. Discrep')
% shading flat 
% colorbar
% sgtitle(titlestring,'fontsize',18)



[foo,bar,polardisc] = cart2pol(Xfine,Yfine,discrepancy);

Linf_soln = [Linf_soln,max(max(abs(solA)))];
L1_soln = [L1_soln,sum(sum(Rgrid.*abs(solA)))*dr*dtheta];
foo = sum(sum(Rgrid.*(solA.^2)))*dr*dtheta;
L2_soln = [L2_soln,sqrt(foo)];


Linf_error = [Linf_error,max(max(abs(discrepancy)))]
L1_error = [L1_error,sum(sum(Rgrid.*abs(discrepancy)))*dr*dtheta]
foo = sum(sum(Rgrid.*(discrepancy.^2)))*dr*dtheta;
L2_error = [L2_error,sqrt(foo)]



