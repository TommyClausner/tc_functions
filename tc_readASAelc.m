function [ elc_file ] = tc_readASAelc( filename )

[pathstr,name,ext] = fileparts((filename));

name_org=name;

copyfile(filename,[name '_tmp' ext])

filename=[name '_tmp' ext];

movefile(filename, fullfile(pathstr, [name '_tmp.txt']))

filename=[pathstr,'/',name '_tmp.txt'];

fid=fopen(filename,'rt');
[pathstr,name,ext] = fileparts((filename));

fid=fopen([pathstr,'/',name '.txt'],'rt');
file_orig=textscan(fid,'%s','Delimiter','\n');
fclose(fid);

position_ind=strfind(file_orig{1,1},'Positions');
position_ind(find(cellfun('isempty',strfind(file_orig{1,1},'Positions'))==1),:)={0};
position_ind=find(cell2mat(cellfun(@(x) x==1,position_ind,'unif',0))==1);

label_ind=strfind(file_orig{1,1},'Labels');
label_ind(find(cellfun('isempty',strfind(file_orig{1,1},'Labels'))==1),:)={0};
label_ind=find(cell2mat(cellfun(@(x) x==1,label_ind,'unif',0))==1);

hs_ind=strfind(file_orig{1,1},'HeadShapePoints');
hs_ind(find(cellfun('isempty',strfind(file_orig{1,1},'HeadShapePoints'))==1),:)={0};
hs_ind=find(cell2mat(cellfun(@(x) x==1,hs_ind,'unif',0))==1);
hs_ind=hs_ind+1;

electrodes_ind=[position_ind+1 label_ind-1];

electrodes=file_orig{1,1}(electrodes_ind(1):electrodes_ind(2));

electrodes_points(find(cell2mat(cellfun(@(x) strcmpi(x(end),':'),cellfun(@(x) sscanf(x,'%s:'),electrodes,'unif',0),'unif',0))==1),:)=cell2mat(cellfun(@(x) sscanf(x,'%*s %f %f %f',[1, inf]),electrodes,'unif',0));
electrodes_points(find(cell2mat(cellfun(@(x) strcmpi(x(end),':'),cellfun(@(x) sscanf(x,'%s:'),electrodes,'unif',0),'unif',0))==0),:)=cell2mat(cellfun(@(x) sscanf(x,'%*s : %f %f %f',[1, inf]),electrodes,'unif',0));

electrodes_label=file_orig{1,1}(electrodes_ind(2)+2,:);
electrodes_label=strsplit(electrodes_label{1,1},'\t')';
electrodes_label(find(cellfun('isempty',electrodes_label)==1),:)=[];

electrodes_hspoints=cell2mat(cellfun(@(x) sscanf(x,'%f %f %f',3)',file_orig{1,1}(hs_ind:end,:),'unif',0));

elc_file.ElectrodePoints=electrodes_points;
elc_file.ElectrodeLabels=electrodes_label;
elc_file.UnitsElectrodes=sscanf(file_orig{1,1}{find(strcmpi(cellfun(@(x) sscanf(x,'UnitPosition %s',1)',file_orig{1,1},'unif',0),'')==0),:},'UnitPosition %s',1);
elc_file.HeadShapePoints=electrodes_hspoints;
elc_file.UnitsHeadShapePoints=sscanf(file_orig{1,1}{find(strcmpi(cellfun(@(x) sscanf(x,'UnitHeadShapePoints %s',1)',file_orig{1,1},'unif',0),'')==0),:},'UnitHeadShapePoints %s',1);
elc_file.OriginalFile=file_orig;

delete([pathstr,'/',name '.txt'])
end

