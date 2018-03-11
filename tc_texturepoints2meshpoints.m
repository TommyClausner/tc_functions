function [ points ] = tc_texturepoints2meshpoints( V,VT,F,FT,texture,texture_points )
% [ points ] = tc_texturepoints2meshpoints( V,VT,F,FT,texture )
load('/Users/Tommy/Desktop/test_texture/SM_texture_test.mat')
V=session.model.VCoord;
VT=session.model.VTCoord;
F=session.model.FCoord(:,[1,3,5]);
FT=session.model.FCoord(:,[2,4,6]);

texture_points = tc_getelectrodesbytexture( '/Users/Tommy/Desktop/test_texture/SM_texture_test.jpg',129 );
I=imread('/Users/Tommy/Desktop/test_texture/SM_texture_test.jpg');
texture=rgb2gray(I);

code_test=double(texture);

code_test(texture_points(:,1),texture_points(:,2))=ones.*999;

coord=round(abs(round((VT).*10000)./10000).*size(code_test,1));

coord(find(coord(:,1)<1),1)=ones;
coord(find(coord(:,2)<1),2)=ones;
coord(find(coord(:,1)>size(code_test,1)),1)=repmat(size(code_test,1),size(find(coord(:,1)>size(code_test,1)),1),1);
coord(find(coord(:,2)>size(code_test,1)),2)=repmat(size(code_test,1),size(find(coord(:,2)>size(code_test,1)),2),1);

code_test=flipud(code_test);

new_mat=zeros(size(coord,1),3);
for n=1:size(coord,1)
new_mat(n,:)=code_test(coord(n,2),coord(n,1),:);
end

test=new_mat(FT);

ind_F_1=find(test(:,1)==999);
ind_F_2=find(test(:,2)==999);
ind_F_3=find(test(:,3)==999);

Coord_V1=V(F(ind_F_1),:);
Coord_V2=V(F(ind_F_2),:);
Coord_V3=V(F(ind_F_3),:);

scatter3(Coord_V1(:,1),Coord_V1(:,2),Coord_V1(:,3))
hold on
scatter3(Coord_V2(:,1),Coord_V2(:,2),Coord_V2(:,3))
scatter3(Coord_V3(:,1),Coord_V3(:,2),Coord_V3(:,3))
hold off

imshow(texture)
hold on
plot(texture_points(:,1),texture_points(:,2),'*')

