function [x_c_loc,y_c_loc]=tc_findcircle(input_image,radius)
%% [x_c_loc,y_c_loc]=tc_findcircle(input_image,radius)
% UNFINISHED FUNCTION

% diameter_watermaze=20;
% gridsize=diameter_watermaze+50;
% [rr,cc] = meshgrid(1:gridsize);
% 
% noise=0.5;
% elipsoidy=1;
% elipsoidx=3;
% 
% maze = double(sqrt((elipsoidy*rr-gridsize/2).^2+(elipsoidx*cc-gridsize/2).^2)<=diameter_watermaze/2 ...
%     | sqrt((elipsoidy*rr-(diameter_watermaze.*1.5/elipsoidy)-gridsize/2).^2+(elipsoidx*cc+(diameter_watermaze)-gridsize/2).^2)<=diameter_watermaze/2 ...
%     | sqrt((elipsoidy*rr-(diameter_watermaze.*3/elipsoidy)-gridsize/2).^2+(elipsoidx*cc-(diameter_watermaze)-gridsize/2).^2)<=diameter_watermaze/2 ...
%     | rand(size(maze))<noise);

[~,l,w]=findpeaks(reshape(input_image,1,[]));
subplot(121)
plot(l,w); hold on
[~,l2,w2]=findpeaks(reshape(input_image',1,[]));
plot(l2,w2)

[v,I]=max(w);
[v2,I2]=max(w2);

yloc=mod(l(I),size(input_image,1))+round(v/2)-1;
xloc=mod(l2(I2),size(input_image,2))+round(v2/2)-1;

input_image(yloc,xloc)=2;
subplot(122)
imagesc(input_image)

end