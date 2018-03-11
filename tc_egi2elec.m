function [CEN_out CARD_out Is_out] = tc_egi2elec()



Is=tc_egi2jpg;

for n=1:11
    m=0;
    new_centers=[];
    new_radii=[];
    while m<100
        
        m=m+1;
        [centers, radii, ~] = imfindcircles(imfill(im2bw(Is{n},m/100),'holes'),[7 14]);
        if size(centers,1)>=1
            
            new_centers=vertcat(new_centers,centers);
            new_radii=vertcat(new_radii,radii);
            cla
            hold on
            imshow(imfill(im2bw(Is{n},m/100),'holes'))
            viscircles(centers, radii,'EdgeColor','b');
            hold off
            drawnow
        else
            m=m+3;
        end
        
        CEN{n}=new_centers;
        RAD{n}=new_radii;
        
        
    end
    if size(CEN{n},1)<1
        CEN{n}(1,1:2)=zeros;
    end
    dist{1,1}=find(pdist2(CEN{n},CEN{n}(1,:)) <=10);
    
    for k=2:size(CEN{n},1)
        
        if sum(ismember(vertcat(dist{1:k-1,1}),find(pdist2(CEN{n},CEN{n}(k,:)) <=10)))<=0
            dist{k,1}=find(pdist2(CEN{n},CEN{n}(k,:)) <=10);
        else
            dist{k,1}=[];
            
        end
        
    end
    dist=dist(find(cellfun(@length,dist)>1),1);
    new_cents=zeros(size(dist,1),2);
    new_rads=zeros(size(dist,1),1);
    for k=1:size(dist,1)
        new_cents(k,:)=mean(CEN{n}(dist{k,1},:),1);
        new_rads(k,:)=mean(RAD{n}(dist{k,1},:),1);
    end
    
    CEN{n}=new_cents;
    RAD{n}=new_rads;
end
close all
figure
n=1;
cla
imshow(Is{n})
hold on
scatter(CEN{n}(:,1), CEN{n}(:,2),'*','b');
CARD=cell(1,11);
hold off
drawnow
axis off
card_norm_ind=1;
btn_prev = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'PREVIOUS',...
    'Position', [0 0 0.101 0.05],...
    'Callback', @prev_img_callback);

btn_next = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'NEXT',...
    'Position', [0.899 0 0.101 0.05],...
    'Callback', @next_img_callback);

btn_card = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'CARDINAL',...
    'Position', [0.899 0.95 0.101 0.05],...
    'Callback', @card_callback);

btn_norm = uicontrol('Style', 'pushbutton', 'Units','normalized','String', 'NORMAL',...
    'Position', [0 0.95 0.101 0.05],...
    'Callback', @norm_callback);
    function norm_callback(varargin)
        card_norm_ind=2;
    end

    function card_callback(varargin)
        card_norm_ind=1;
        
    end
    function prev_img_callback(varargin)
        if n>1
            set(gcf, 'Pointer', 'circle');
            n=n-1;
            cla
            imshow(Is{n})
            hold on
            scatter(CEN{n}(:,1), CEN{n}(:,2),'*','b');
            scatter(CARD{n}(:,1), CARD{n}(:,2),'*','r');
            hold off
            drawnow
            axis off
        end
    end

    function next_img_callback(varargin)
        if n<11
            set(gcf, 'Pointer', 'circle');
            n=n+1;
            cla
            imshow(Is{n})
            hold on
            scatter(CEN{n}(:,1), CEN{n}(:,2),'*','b');
            scatter(CARD{n}(:,1), CARD{n}(:,2),'*','r');
            hold off
            drawnow
            axis off
        end
    end
set (gcf, 'WindowButtonUpFcn', @mouseButton);
set(gcf, 'Pointer', 'circle');


    function mouseButton(source,callback)
        
        button_press = get(gcf,'selectiontype');
        val = get(gca,'CurrentPoint');
        set(gcf, 'Pointer', 'circle');
        
        if strcmpi(button_press,'normal')
            if card_norm_ind==2
                CEN{n}(end+1,1:2)=val(1,1:2);
            elseif card_norm_ind==1
                CARD{n}(end+1,1:2)=val(1,1:2);
            end
            cla
            imshow(Is{n})
            hold on
            scatter(CEN{n}(:,1), CEN{n}(:,2),'*','b');
            scatter(CARD{n}(:,1), CARD{n}(:,2),'*','r');
            hold off
            drawnow
            axis off
        elseif strcmpi(button_press,'alt')
            point=val(1,1:2);
            point=find(min(pdist2(CEN{n},point))==pdist2(CEN{n},point) & min(pdist2(CEN{n},point))<=15);
            if size(point,1)>1
                point=point(1,1);
            end
            CEN{n}(point,:)=[];
            if size(CARD{n},1)>0
                point=val(1,1:2);
                point=find(min(pdist2(CARD{n},point))==pdist2(CARD{n},point) & min(pdist2(CARD{n},point))<=15);
                if size(point,1)>1
                    point=point(1,1);
                end
                CARD{n}(point,:)=[];
            end
            cla
            imshow(Is{n})
            hold on
            scatter(CEN{n}(:,1), CEN{n}(:,2),'*','b');
            scatter(CARD{n}(:,1), CARD{n}(:,2),'*','r');
            hold off
            drawnow
            axis off
        end
    end

waitfor(gcf)
CEN_out=CEN;
CARD_out=CARD;
Is_out=Is;
end