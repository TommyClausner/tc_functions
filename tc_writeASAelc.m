function [] = tc_writeASAelc( new_filename,elc_struct )

%tc_writeASAelc( filepath,elc_struct )
% elc_struct should have the following fields:
% elc_struct.ElectrodePoints (default = [])
% elc_struct.ElectrodeLabels (default = cell(1,1))
% elc_struct.UnitsElectrodes (default = 'mm')
% elc_struct.HeadShapePoints (default = [])
% elc_struct.UnitsHeadShapePoints (default = 'mm')
%
% if one field does not exist it will be replaced by its default

if ~isfield(elc_struct,'ElectrodePoints')
    elc_struct.ElectrodePoints  = [];
elseif ~isfield(elc_struct,'ElectrodeLabels')
    elc_struct.ElectrodeLabels  = cell(1,1);
elseif ~isfield(elc_struct,'UnitsElectrodes')
    elc_struct.UnitsElectrodes  = 'mm';
elseif ~isfield(elc_struct,'HeadShapePoints')
    elc_struct.HeadShapePoints  = [];
elseif ~isfield(elc_struct,'UnitsHeadShapePoints')
    elc_struct.UnitsHeadShapePoints  = 'mm';
end

if size(elc_struct.ElectrodePoints,1)~=size(elc_struct.ElectrodeLabels,1)   
    error('unbalanced electrode - label - pairings')
end

elec_points=cellfun(@(x) sprintf('%f\t%f\t%f',x),num2cell(elc_struct.ElectrodePoints,2),'unif',0);
elec_labels=cellfun(@(x) sprintf(['%s' repmat(' ',1,8-size(x,2)) ':'],x),elc_struct.ElectrodeLabels,'unif',0);
hs_points=cellfun(@(x) sprintf('%f\t%f\t%f',x),num2cell(elc_struct.HeadShapePoints,2),'unif',0);

electrodes=cellfun(@(x) sprintf('%s\t%s\n',x),[elec_labels,elec_points],'unif',0);
electrodes=cellfun(@(x,y) [x,y],electrodes(:,1),electrodes(:,2),'unif',0);

[pathstr,name,ext] = fileparts(which('/Users/Tommy/Documents/Studies/General_Stuff/tc_functions/template.elc'));
filename='template.elc';

copyfile([pathstr '/' filename],[name '_tmp' ext])

filename=[name '_tmp' ext];

movefile(filename, fullfile(pathstr, [name '_tmp.txt']))

filename=[name '_tmp.txt'];

fid=fopen(filename,'rt');
[pathstr,name,ext] = fileparts(which(filename));

fclose(fid);
fid=fopen([pathstr '/' name '.txt'],'rt');
elc_to_write=textscan(fid,'%s','Delimiter','\n');
fclose(fid);
delete([pathstr '/' name '.txt'])
elc_to_write=elc_to_write{1,1};

position_ind=strfind(elc_to_write,'Positions');
position_ind(find(cellfun('isempty',strfind(elc_to_write,'Positions'))==1),:)={0};
position_ind=find(cell2mat(cellfun(@(x) x==1,position_ind,'unif',0))==1)+1;

label_ind=strfind(elc_to_write,'Labels');
label_ind(find(cellfun('isempty',strfind(elc_to_write,'Labels'))==1),:)={0};
label_ind=find(cell2mat(cellfun(@(x) x==1,label_ind,'unif',0))==1)-1;

tmp=elc_to_write(label_ind+1:end,:);
elc_to_write(position_ind:end,:)=[];
elc_to_write=vertcat(elc_to_write,electrodes);

elc_to_write=vertcat(elc_to_write,tmp);

position_ind=strfind(elc_to_write,'Positions');
position_ind(find(cellfun('isempty',strfind(elc_to_write,'Positions'))==1),:)={0};
position_ind=find(cell2mat(cellfun(@(x) x==1,position_ind,'unif',0))==1)+1;

label_ind=strfind(elc_to_write,'Labels');
label_ind(find(cellfun('isempty',strfind(elc_to_write,'Labels'))==1),:)={0};
label_ind=find(cell2mat(cellfun(@(x) x==1,label_ind,'unif',0))==1)+1;

tmp=elc_to_write(label_ind:end,:);
elc_to_write(label_ind:end,:)=[];
elc_to_write=vertcat(elc_to_write,{cell2mat(cellfun(@(x) sprintf([x,'\t']),elc_struct.ElectrodeLabels','unif',0))});

elc_to_write=vertcat(elc_to_write,tmp);

hs_ind=strfind(elc_to_write,'HeadShapePoints');
hs_ind(find(cellfun('isempty',strfind(elc_to_write,'HeadShapePoints'))==1),:)={0};
hs_ind=find(cell2mat(cellfun(@(x) x==1,hs_ind,'unif',0))==1)+1;

tmp=elc_to_write(hs_ind:end,:);
elc_to_write(hs_ind:end,:)=[];
elc_to_write=vertcat(elc_to_write,hs_points);

position_ind=strfind(elc_to_write,'Positions');
position_ind(find(cellfun('isempty',strfind(elc_to_write,'Positions'))==1),:)={0};
position_ind=find(cell2mat(cellfun(@(x) x==1,position_ind,'unif',0))==1)+1;

hs_ind=strfind(elc_to_write,'HeadShapePoints');
hs_ind(find(cellfun('isempty',strfind(elc_to_write,'HeadShapePoints'))==1),:)={0};
hs_ind=find(cell2mat(cellfun(@(x) x==1,hs_ind,'unif',0))==1)+1;

elc_to_write(position_ind-5,:)={sprintf('# %s electrodes',num2str(size(electrodes,1)))};
elc_to_write(position_ind-4,:)={sprintf('NumberPositions=\t%s',num2str(size(electrodes,1)))};
elc_to_write(position_ind-3,:)={sprintf('UnitPosition\t%s',elc_struct.UnitsElectrodes)};

elc_to_write(hs_ind-4,:)={sprintf('# %s HeadShapePoints',num2str(size(hs_points,1)))};
elc_to_write(hs_ind-3,:)={sprintf('NumberHeadShapePoints=\t%s',num2str(size(hs_points,1)))};
elc_to_write(hs_ind-2,:)={sprintf('UnitHeadShapePoints\t%s',elc_struct.UnitsHeadShapePoints)};

copyfile('/Users/Tommy/Documents/Studies/General_Stuff/tc_functions/template.elc','/Users/Tommy/Documents/Studies/General_Stuff/tc_functions/template_tmp.elc')
fid = fopen(['/Users/Tommy/Documents/Studies/General_Stuff/tc_functions/template_tmp.elc'],'wt');
fprintf(fid,'%s\n',elc_to_write{:});
fclose(fid);
movefile('/Users/Tommy/Documents/Studies/General_Stuff/tc_functions/template_tmp.elc',[new_filename])

end

