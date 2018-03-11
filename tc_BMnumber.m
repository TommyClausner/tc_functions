function [class,p,I]=tc_BMnumber(W,T,MC,drawsize)
% [class,p,new_Img2]=tc_BMnumber(W,T,MC,drawsize)
%
% Boltzmann Machine handwritten number classifier
%
% Input:    W - training weights obtained from boltzmanntrain
%           T - threshold obtained from boltzmanntrain
%           MC - mean field obtained from boltzmanntrain
%           drawsize - n x n size of pen, such that n = 1 +- drawsize
%
% Output:   class - Predicted number / digit (0 - 9)
%           p - log(p) for the classification of each number (0 - 9)
%           I - image drawn - downsampled to 28 x 28 pixel

clicked=0;

[rr,~]=meshgrid(1:56,1:56);

raw_img=rr;
raw_img=zeros(size(raw_img));

imObj = raw_img;
h=figure('WindowButtonMotionFcn',@ImageDragCallback,'WindowButtonUpFcn',@NImageClickCallback,'Color','w');
set(h, 'MenuBar', 'none','ToolBar', 'none','Name','','NumberTitle','off','Units','normalized','outerposition',[0 0 1 1]);

for n=1:5
subplot(5,4,1+4*(n-1))
imagesc(reshape(MC(n+1*(n-1),:),28,28))
axis equal off
box off
subplot(5,4,2+4*(n-1))
imagesc(reshape(MC(n+1*(n-1)+1,:),28,28))
axis equal off
box off
end

subplot(5,4,[3:4:20,4:4:20])
hAxes = gca;
imageHandle = imshow(imObj);
set(imageHandle,'ButtonDownFcn',@ImageClickCallback);
new_Img=raw_img;
axis equal off
box off
suptitle('draw number according to the examples at the left')
waitfor(gcf)

for n=1:10
    [p(n,:)]=boltzmanntest(I(:),squeeze(W(n,:,:)),T(n,:),MC(n,:)');
end

[~,class]=max(p,[],1);
class=class-1;
    function ImageDragCallback ( objectHandle , eventData )
        if clicked
            coordinates = get(gca,'CurrentPoint');
            coordinates = coordinates(1,1:2);
            if coordinates(1)>drawsize && coordinates(2)>drawsize && coordinates(1)<(size(raw_img,2)-drawsize) && coordinates(2)<(size(raw_img,1)-drawsize)
                new_Img(round(coordinates(2)-drawsize:coordinates(2)+drawsize),round(coordinates(1)-drawsize:coordinates(1)+drawsize))=1;
                I=new_Img(2:2:end,2:2:end);
                set(imageHandle,'CData',new_Img)
            end
        end
    end

    function ImageClickCallback ( objectHandle , eventData )
        clicked=1;
    end
    function NImageClickCallback ( objectHandle , eventData )
        clicked=0;
    end

end

