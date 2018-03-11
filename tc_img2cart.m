function [I] = tc_img2cart (input_image)
%[I] = tc_img2cart (input_image)
%transforms an image into carthesian coordinate points
%x=1:number_of_Xpixels
%y=1:number_of_Ypixels
%z=0
%color either in MATLAB RGB triplets or singular

    [x,y]=meshgrid(1:size(input_image,2), 1:size(input_image,1));
    I=[x(:),y(:)];
    I(:,3)=zeros;

    if size(input_image,3)==1
    I(:,4:6)=[reshape(input_image(:),size(input_image,1)*size(input_image,2),1)];    
    elseif size(input_image,3)==3
    I(:,4:6)=[reshape(input_image(:),size(input_image,1)*size(input_image,2),3)];
    else
        error('not a valid image format')
    end
    
end