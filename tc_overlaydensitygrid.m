function [overlay_out,H_out]=tc_overlaydensitygrid(I,densgrid,varargin)
%% overlay_out=tc_overlaydensitygrid(I,densgrid,varargin)
% Overlays image I and desity grid densgrid according to a MATLAB
% colorcoding. The respective colormap can be defined.
%
% Input:
%
% - Image I (MATLAB RGB (m x n x 3) or MATLAB grayscale (m x n))
% - density grid densgrid (m x n) of values between 0 and 1; can be created 
%   using 'tc_makedensitygrid'
% - varargin:
%          {1}: MATLAB colormap (e.g.'jet' - default)
%          {2}: threshold for displaying color range [0 - 1] (e.g. 0.05 
%           to exclude the lowest 5% of color coded values)
%          {3}: high pass for values greater than the specified [0 - 1]
%           (e.g. 0.2 would exclude all values smaller than 0.2)
%          {4}: alpha value of the overlay [0 - 1] (default: 0.5)
%
% Output:
%
% - MATLAB RGB image (m x n x 3) overlayed with the respective density grid according to the
% specifications
%
% Note: the output image is converted to grayscale while overlayed with the
% colormap. Hence, the resulting image is in RGB color space. Depending on
% how the alpha level for the overlay was set, the grauscale contrast of
% the underlying image will shade the respective colorcode data in the user specified amount.


% default settings
C = colormap(jet);
threshval=1; % note that this is the final values used as index (not to be confused with the value that serves as input)
threshdensg=0;
transp=0.5;

if size(I,3)<3
    I=repmat(I,1,1,3);
end
if ~isempty(varargin)
    C = colormap(varargin{1});
    if size(varargin,2)>2
        if size(varargin,2)>3
            transp=varargin{4};
        end
        if varargin{3}>=1
            warning('the respective threshold set for the density grid would exclude all data - value set to 0.5')
            threshdensg=0.5;
        elseif varargin{3}<0
            warning('the respective threshold set for the density grid is lower than zero - value set to 0')
            threshdensg=0;
        end
        densgrid(densgrid<threshdensg)=min(densgrid(densgrid>=threshdensg));
    end
end

SizeDG=size(unique(densgrid),1);
C=hsv2rgb(interp1(linspace(0,1,size(C,1)),rgb2hsv(C),linspace(0,1,SizeDG)));

L = size(C,1);
Gs = round(interp1(linspace(min(densgrid(:)),max(densgrid(:)),L),1:L,densgrid));
H = reshape(C(Gs,:),[size(Gs) 3]);

if ~isempty(varargin)
    if size(varargin,2)>1
        if ischar(varargin{2})
            switch varargin{2}
                case 'lowest'
                    threshval=1-((size(C,1)-1)/size(C,1));
                case 'highest'
                    threshval=1-(1/size(C,1));
            end
        else
            threshval=varargin{2};
        end
        if (size(C,1)+1)*threshval<1
            warning('threshold for color code lower than 1/nunique_datapoints - set to minimum value (1-((nunique_datapoints-1)/nunique_datapoints))')
            threshval=1-((size(C,1)-1)/size(C,1));
        elseif size(C,1)*threshval>size(C,1)
            warning('threshold for color code higher than 1 - set to maximum value (1-(1/nunique_datapoints))')
            threshval=1-(1/size(C,1));
        end
        threshval=round(size(C,1).*threshval);
    end
end

idx=repmat(ismember(H(:,:,1),C(1:threshval,1))&ismember(H(:,:,2),C(1:threshval,2))&ismember(H(:,:,3),C(1:threshval,3)),1,1,3);
H_out=H;
H_out(idx)=0;
H(idx)=I(idx);
overlay_out=(H.*(1-transp)+I.*transp);
