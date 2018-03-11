function [ wb_handle ] = tc_waitbar( handle,value,max_value )

clear color
counter=0;
for n=51:100
counter=counter+1;
color(counter,:)=[n/100 0 0];
end
for n=1:100
counter=counter+1;
color(counter,:)=[1 n/100 0];
end
for n=1:100
counter=counter+1;
color(counter,:)=[1-(n/100) 1 0];
end

color_patch=color(value*25,:);
pause(0.2)
patch([1,1,2,2],[value,value+max_value/10,value+max_value/10,value],color_patch,'Edgecolor','none')
ylim([1 max_value])
xlim([1 5])
drawnow;
end

% t=[];
% figure
% xlim([-1 1])
% ylim([-1 1])
% set(gca,'Units','points');
% axpos=get(gca,'Position');
% size_c=min(axpos(3:4));
% scatter(0,0,size_c^2,'filled','Cdata',[1 1 1])
% axis off
% hold on
% for n=25:25:2500
%     pause(0.2)
% scatter(0,0,size_c^2*(n/2500),'filled','Cdata',[0.502 0.502 0.502])
% axis off
% drawnow;
% end
% delete(t)
