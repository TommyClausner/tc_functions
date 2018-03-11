function calibmat=tc_transmatEGIimg()

for n=1:11
        
    if n==2 || n==9
        
        transmats{n} = tc_transmat( [0.1 0.1 1],'scale' ) *tc_transmat( [-320 240 50],'translate' )*tc_transmat( [0 0 degtorad(-90)],'rotate' );
        
    elseif n==1
        transmats{n} = tc_transmat( [0.1 0.1 1],'scale' )*tc_transmat( [320 -240 50],'translate' )*tc_transmat( [0 0 degtorad(90)],'rotate' );
        
    else
        transmats{n} = tc_transmat( [0.1 0.1 1],'scale' )*tc_transmat( [-240 -320 50],'translate' );
        
    end
    
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





%transmats{1}=eye(4);

rot_1=[radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),radtodeg(acos(1/sqrt(5))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5)))),(180-radtodeg(acos(1/sqrt(5))))];
rot_2=[0,-72,-144,-216,-288,-36,-108,-180,-252,-324];
which_=[1,2,3,4,5,6,7,8,9,10];
for n=1:10
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
    
    transmats{n+1}=transmat4*transmat3*transmat2*transmat1*transmats{n+1};
    
    
    
end
calibmat=transmats;
end