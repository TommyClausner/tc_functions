function xyz_out=tc_densgrid2xyz(densgrid)
%% xyz_out=tc_densgrid2xyz(densgrid)
% transforms a density grid into a set of 2D coordinates with the
% respective density value resulting in a n x 3 matrix, whereby the first
% two columns reflect the coordinate and the third column the value at the
% respective location

[Y_,X_]=find(densgrid>0);
Z_=densgrid(densgrid>0);
xyz_out=[X_,Y_,Z_];
end