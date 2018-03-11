function calibmat=tc_createcalibmatEGI()

clear all
close all
cd('/Users/Tommy/Documents/Studies/General_Stuff/tc_functions')
Is=tc_egi2jpg;
%%% images to cart + correction of orientation %%
for n=1:11
    
    Im_as_XYCoor{n}=tc_img2cart(Is{n});
    
    if n==2 || n==9
        
        transmat = tc_transmat( [0 0 degtorad(-90)],'rotate' );
        
        Im_as_XYCoor{n}(:,1:3) = tc_transform3D(Im_as_XYCoor{n}(:,1:3),transmat);
        
        Im_as_XYCoor{n}(:,2)=Im_as_XYCoor{n}(:,2)-min(Im_as_XYCoor{n}(:,2))/2;
        Im_as_XYCoor{n}(:,1)=Im_as_XYCoor{n}(:,1)-max(Im_as_XYCoor{n}(:,1))/2;
    elseif n==1
        transmat = tc_transmat( [0 0 degtorad(90)],'rotate' );
        
        Im_as_XYCoor{n}(:,1:3) = tc_transform3D(Im_as_XYCoor{n}(:,1:3),transmat);
        
        Im_as_XYCoor{n}(:,2)=Im_as_XYCoor{n}(:,2)-max(Im_as_XYCoor{n}(:,2))/2;
        Im_as_XYCoor{n}(:,1)=Im_as_XYCoor{n}(:,1)-min(Im_as_XYCoor{n}(:,1))/2;
    else
        Im_as_XYCoor{n}(:,2)=Im_as_XYCoor{n}(:,2)-max(Im_as_XYCoor{n}(:,2))/2;
        Im_as_XYCoor{n}(:,1)=Im_as_XYCoor{n}(:,1)-max(Im_as_XYCoor{n}(:,1))/2;
    end
    
    Im_as_XYCoor{n}(:,3)=ones*50;
    
    Im_as_XYCoor{n}(:,1:2)=Im_as_XYCoor{n}(:,1:2)./10;
    
end

%%% getting transformation matrices for point back projection out of ikosaedric contruction%%

radius=50;

Iko=[-(1+sqrt(5))/2,0,-1;-(1+sqrt(5))/2,0,1;-1,-(1+sqrt(5))/2,0;0,-1,-(1+sqrt(5))/2;...
    0,1,-(1+sqrt(5))/2;-1,(1+sqrt(5))/2,0;0,-1,(1+sqrt(5))/2;1,-(1+sqrt(5))/2,0;(1+sqrt(5))/2,0,-1;...
    1,(1+sqrt(5))/2,0;0,1,(1+sqrt(5))/2].*radius./2;
transmat=tc_transmat([0,acos(1/sqrt(5))/2+degtorad(90),0],'rotate');

Iko=tc_transform3D(Iko,transmat);
Iko(:,3)=Iko(:,3)+(50-max(Iko(:,3)));
coordinates_Dome=Iko;
vertices=zeros(44,3);

vertices(1:11,:)=[coordinates_Dome(:,1),coordinates_Dome(:,2),coordinates_Dome(:,3)]+repmat(3.2.*[0,1,0.75],11,1);
vertices(12:22,:)=[coordinates_Dome(:,1),coordinates_Dome(:,2),coordinates_Dome(:,3)]+repmat(3.2.*[0,-1,0.75],11,1);
vertices(23:33,:)=[coordinates_Dome(:,1),coordinates_Dome(:,2),coordinates_Dome(:,3)]+repmat(3.2.*[0,-1,-0.75],11,1);
vertices(34:end,:)=[coordinates_Dome(:,1),coordinates_Dome(:,2),coordinates_Dome(:,3)]+repmat(3.2.*[0,1,-0.75],11,1);

act_which=[1,12,23,34];
mean_=coordinates_Dome(1,:);
[ vertices(act_which,:) ]=[ vertices(act_which,:) ]-repmat(mean_,4,1);
transmat = tc_transmat( [0 degtorad(-90) 0],'rotate' );

[ vertices(act_which,:) ] = tc_transform3D(vertices(act_which,:),transmat);
[ vertices(act_which,:) ]=[ vertices(act_which,:) ]+repmat(mean_,4,1);

axis equal
hold on
scatter3(Im_as_XYCoor{1}(:,1),Im_as_XYCoor{1}(:,2),Im_as_XYCoor{1}(:,3),'.','CData',[Im_as_XYCoor{1}(:,4:6)])


transmats{1}=eye(4);

rot_1=[radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5))))];
rot_2=[0,-72,-144,-216,-288,-36,-108,-180,-252,-324];
which_=[1,2,3,4,5,6,7,8,9,10];
for n=1:10
    
    if n==1 || n==
        
        transmat = tc_transmat( [0 0 degtorad(-90)],'rotate' );
        
        Im_as_XYCoor{n}(:,1:3) = tc_transform3D(Im_as_XYCoor{n}(:,1:3),transmat);
        
        Im_as_XYCoor{n}(:,2)=Im_as_XYCoor{n}(:,2)-min(Im_as_XYCoor{n}(:,2))/2;
        Im_as_XYCoor{n}(:,1)=Im_as_XYCoor{n}(:,1)-max(Im_as_XYCoor{n}(:,1))/2;
    elseif n==1
        transmat = tc_transmat( [0 0 degtorad(90)],'rotate' );
        
        Im_as_XYCoor{n}(:,1:3) = tc_transform3D(Im_as_XYCoor{n}(:,1:3),transmat);
        
        Im_as_XYCoor{n}(:,2)=Im_as_XYCoor{n}(:,2)-max(Im_as_XYCoor{n}(:,2))/2;
        Im_as_XYCoor{n}(:,1)=Im_as_XYCoor{n}(:,1)-min(Im_as_XYCoor{n}(:,1))/2;
    else
        Im_as_XYCoor{n}(:,2)=Im_as_XYCoor{n}(:,2)-max(Im_as_XYCoor{n}(:,2))/2;
        Im_as_XYCoor{n}(:,1)=Im_as_XYCoor{n}(:,1)-max(Im_as_XYCoor{n}(:,1))/2;
    end
    
    
    act_which=repmat(which_(1),1,4)+[0,11,22,33];
    mean_=coordinates_Dome(which_(1),:);
    new_one=vertices(act_which,:);
    
    transmat1=tc_transmat(-mean_,'translate');
    
    new_one=tc_transform3D(new_one,transmat1);
    
    transmat2 = tc_transmat( [0 degtorad(rot_1(n)) degtorad(rot_2(n))],'rotate' );
    
    [ new_one ] = tc_transform3D(new_one,transmat2);
    
    transmat3=tc_transmat(mean_,'translate');
    
    new_one=tc_transform3D(new_one,transmat3);
    
    transmat4 = tc_transmat( mean(vertices(act_which+n,:))-mean(vertices([1,12,23,34],:)),'translate' );
    
    transmats{n+1}=transmat4*transmat3*transmat2*transmat1;
    
    new_imgs{n}=Im_as_XYCoor{n+1};
    
    new_imgs{n}(:,1:3)=tc_transform3D(new_imgs{n}(:,1:3),transmats{n+1});
    
    scatter3(new_imgs{n}(:,1),new_imgs{n}(:,2),new_imgs{n}(:,3),'.','CData',[new_imgs{n}(:,4:6)])
    
end

set(gca,'visible','off')

end