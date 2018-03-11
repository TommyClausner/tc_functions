function densgrid_out=tc_xyz2densgrid(xyz,sizeofdensgrid)
%% densgrid_out=tc_xyz2densgrid(xyz,sizeofdensgrid)
% transforms a set of 2D coordinates with the
% respective density value resulting in a n x 3 matrix, whereby the first
% two columns reflect the coordinate and the third column the value at the
% respective location into a 2D density grid of size 'sizeofdensgrid'

densgrid_=zeros(sizeofdensgrid);
idx=sub2ind(sizeofdensgrid,round(xyz(:,2)),round(xyz(:,1)));
densgrid_(idx)=xyz(:,3);
densgrid_out=densgrid_;
end