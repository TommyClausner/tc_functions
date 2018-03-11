function densgrid_out=tc_makedensitygrid(gridsize,data,varargin)
%% densgrid_out=tc_makedensitygrid(gridsize,data,varargin)
% computes the density for [x,y]-coordinates in a n x 2 matrix data, with
% respect to a a matrix of size nrow x ncol
% Input:
% - gridsize: 2 element vector stating nrow and ncol of the matrix
% - data: n x 2 matrix having x,y coordinates in columns and datapoints in
% rows
% - optional scalar input of the kernelsize for smoothing (default is gridsize.*0.01)
if isempty(varargin)
    kernelwidth=gridsize.*0.01;
else
    if varargin{1}>1
        warning('kernelwidth exceeds maximum of 1 - assume 0.01 - set kernelwidth between 0 and 1 - the resulting kernelwidth that will be used is gridsize.*kernelwidth')
        kernelwidth=gridsize.*0.01;
    else
        kernelwidth=gridsize.*varargin{1};
    end
end
data_new=ceil(data);

ind=sum(isnan(data_new),2)>0;
data_new(ind,:)=[];

densgrid_out=accumarray([data_new(:,2),data_new(:,1)],1,gridsize);
if kernelwidth>0
densgrid_out=imgaussfilt(densgrid_out,mean(kernelwidth));
end
densgrid_out=densgrid_out./(max(densgrid_out(:)));
