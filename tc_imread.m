function img_out=tc_imread(path)
%% img_out=tc_imread(path)
% reads image and corrects for orientation, yielding the same orientation
% as if using the preview on your computer 
% (source: https://nl.mathworks.com/matlabcentral/answers/260607-how-to-load-a-jpg-properly#answer_203481)

IM = imread(path);
info = imfinfo(path);
if isfield(info,'Orientation')
    orient = info(1).Orientation;
    switch orient
        case 1
            %normal, leave the data alone
        case 2
            IM = IM(:,end:-1:1,:);         %right to left
        case 3
            IM = IM(end:-1:1,end:-1:1,:);  %180 degree rotation
        case 4
            IM = IM(end:-1:1,:,:);         %bottom to top
        case 5
            IM = permute(IM, [2 1 3]);     %counterclockwise and upside down
        case 6
            IM = rot90(IM,3);              %undo 90 degree by rotating 270
        case 7
            IM = rot90(IM(end:-1:1,:,:));  %undo counterclockwise and left/right
        case 8
            IM = rot90(IM);                %undo 270 rotation by rotating 90
        otherwise
            warning(sprintf('unknown orientation %g ignored\n', orient));
    end
end
img_out=IM;
end