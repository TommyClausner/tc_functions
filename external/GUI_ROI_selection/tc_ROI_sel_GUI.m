function [ROI_out,niftiinfo]=tc_ROI_sel_GUI(varargin)
%% ROI_out=tc_ROI_sel_GUI(varargin)
%
% GUI for easy ROI definition on NIFTI files
%
% Input: path to NIFTI file (e.g. '/Users/User/Desktop/oT1.nii')
%
% if called without an argument the function will bring up a file selection
% window to select the respective NIFTI file
%
% Output: Structure containing the respective selection polygon, voxel
% inidces and masks for each selected brain area
%
% © Tommy Clausner 2017

if size(varargin,2)<1
    [file_,path_]=uigetfile('.nii');
    if ischar(file_)==0
        return
    end
    pathtonifti=[path_,file_];
else
    if ischar(varargin{1})
        if exist(varargin{1}, 'file') == 2
            pathtonifti=varargin{1};
        else
            error(['either file ' [varargin{1}] ' does not exist or path is not specified correctly'])
        end
    else
        error('please specify valid path string')
    end
end
ROI=struct;
sel_free=[];
[v,niftiinfo]=ReadData3D(pathtonifti);

v=double(v);
index_mat=reshape(1:numel(v),size(v));

index_mat_sag=fliplr(permute(index_mat,[1,3,2]));
index_mat_hor=flipud(index_mat);

contr_start=max(v(:))./2;

sagview=fliplr(permute(v,[1,3,2]))./contr_start;
horview=flipud(v)./contr_start;
corview=flipud(permute(v,[3,1,2]))./contr_start;

horpersp=0;

sag_slice=round(size(sagview,1)/2);
hor_slice=round(size(horview,3)/2);
cor_slice=round(size(corview,2)/2);

tfig
uicontrol('Style','pushbutton','Units','normalized','Position',[0.8 0.5 0.1 0.05],'String','perspective','FontSize',10,'callback',@perspfct);

uicontrol('Style','pushbutton','Units','normalized','Position',[0.75 0.3 0.1 0.05],'String','add to L V3','FontSize',10,'callback',@LV3A);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.75 0.35 0.1 0.05],'String','add to L V2','FontSize',10,'callback',@LV2A);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.75 0.4 0.1 0.05],'String','add to L V1','FontSize',10,'callback',@LV1A);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.85 0.3 0.1 0.05],'String','add to R V3','FontSize',10,'callback',@RV3A);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.85 0.35 0.1 0.05],'String','add to R V2','FontSize',10,'callback',@RV2A);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.85 0.4 0.1 0.05],'String','add to R V1','FontSize',10,'callback',@RV1A);

uicontrol('Style','text','units','normalized','Position',[0.75 0.2625 0.2 0.025],'String','calcarina fissura','FontSize',12)

uicontrol('Style','pushbutton','Units','normalized','Position',[0.75 0.1 0.1 0.05],'String','add to L V3','FontSize',10,'callback',@LV3B);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.75 0.15 0.1 0.05],'String','add to L V2','FontSize',10,'callback',@LV2B);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.75 0.2 0.1 0.05],'String','add to L V1','FontSize',10,'callback',@LV1B);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.85 0.1 0.1 0.05],'String','add to R V3','FontSize',10,'callback',@RV3B);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.85 0.15 0.1 0.05],'String','add to R V2','FontSize',10,'callback',@RV2B);
uicontrol('Style','pushbutton','Units','normalized','Position',[0.85 0.2 0.1 0.05],'String','add to R V1','FontSize',10,'callback',@RV1B);

main_plot=subplot(3,4,[1,2,3,5,6,7,9,10,11]);
imshow(squeeze(sagview(sag_slice,:,:)));

sliceselplot=subplot(344);
imshow(squeeze(horview(:,:,hor_slice)))
line(xlim,[sag_slice sag_slice],'color','w');

gca_pos=get(gca,'Position');
start_val=sag_slice;
slice_slider=uicontrol('Style','slider','Units','normalized','Position',[gca_pos(1)+gca_pos(3)+0.025 gca_pos(2) 0.01 gca_pos(4)],'value',start_val, 'min',1, 'max',size(sagview,1),'callback',@sliceselection);


gca_pos=get(main_plot,'Position');
contrast_slider=uicontrol('Style','slider','Units','normalized','Position',[gca_pos(1)+gca_pos(3)+0.025 gca_pos(2) 0.01 gca_pos(4)],'value',contr_start, 'min',min(v(:)), 'max',contr_start*2,'callback',@contrastselection);

uicontrol('Style','pushbutton','Units','normalized','Position',[gca_pos(1)+gca_pos(3)/2-0.05 1-gca_pos(2)+0.05 0.1 0.05],'String','flip','FontSize',10,'callback',@flipfct);
drawnow;

    function contrastselection(varargin)
        val_=get(contrast_slider,'max')-get(contrast_slider,'value')+get(contrast_slider,'min');
        sagview=fliplr(permute(v,[1,3,2]))./val_;
        horview=flipud(v)./val_;
        corview=flipud(permute(v,[3,1,2]))./val_;
        if horpersp==1
            set(get(main_plot,'children'),'CData',horview(:,:,hor_slice));
            set(findobj(sliceselplot,'type','Image'),'CData',squeeze(corview(:,:,cor_slice)));
        else
            set(get(main_plot,'children'),'CData',squeeze(sagview(sag_slice,:,:)));
            set(findobj(sliceselplot,'type','Image'),'CData',squeeze(horview(:,:,hor_slice)));
        end
        drawnow;
    end

    function perspfct(varargin)
        set(gcf, 'pointer', 'watch')
        drawnow;
        if horpersp==0
            set(slice_slider,'value',hor_slice);
            set(slice_slider,'max',size(horview,3));
            set(get(main_plot,'children'),'CData',horview(:,:,hor_slice));
            set(findobj(sliceselplot,'type','Image'),'CData',squeeze(corview(:,:,cor_slice)));
            set(findobj(sliceselplot,'type','Line'),'XData',xlim,'YData',[round(get(slice_slider,'max')+1-hor_slice) round(get(slice_slider,'max')+1-hor_slice)]);
            horpersp=1;
        else
            set(slice_slider,'value',sag_slice);
            set(slice_slider,'max',size(sagview,1));
            set(get(main_plot,'children'),'CData',squeeze(sagview(sag_slice,:,:)));
            set(findobj(sliceselplot,'type','Image'),'CData',squeeze(horview(:,:,hor_slice)));
            set(findobj(sliceselplot,'type','Line'),'XData',xlim,'YData',[sag_slice sag_slice]);
            horpersp=0;
        end       
        set(gcf, 'pointer', 'arrow')
        drawnow;
    end

    function flipfct(varargin)
        if strcmp(get(main_plot,'XDir'),'normal')
            set(main_plot,'XDir','reverse')
        else
            set(main_plot,'XDir','normal')
        end
        drawnow;
    end
    function sliceselection(varargin)
        if horpersp==1
            hor_slice=round(get(slice_slider,'value'));
            set(findobj(main_plot,'type','Image'),'CData',squeeze(horview(:,:,hor_slice)));
            set(findobj(sliceselplot,'type','Line'),'XData',xlim,'YData',[round(get(slice_slider,'max')+1-hor_slice) round(get(slice_slider,'max')+1-hor_slice)]);
        else
            sag_slice=round(get(slice_slider,'value'));
            set(findobj(main_plot,'type','Image'),'CData',squeeze(sagview(round(sag_slice),:,:)));
            set(findobj(sliceselplot,'type','Line'),'XData',xlim,'YData',[round(get(slice_slider,'max')+1-sag_slice) round(get(slice_slider,'max')+1-sag_slice)]);
        end
        drawnow;
    end
    function LV1A(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.LV1A.hor=sel_free;
        else
            ROI.LV1A.sag=sel_free;
        end
    end
    function LV2A(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.LV2A.hor=sel_free;
        else
            ROI.LV2A.sag=sel_free;
        end
    end
    function LV3A(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.LV3A.hor=sel_free;
        else
            ROI.LV3A.sag=sel_free;
        end
    end
    function RV1A(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.RV1A.hor=sel_free;
        else
            ROI.RV1A.sag=sel_free;
        end
    end
    function RV2A(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.RV2A.hor=sel_free;
        else
            ROI.RV2A.sag=sel_free;
        end
    end
    function RV3A(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.RV3A.hor=sel_free;
        else
            ROI.RV3A.sag=sel_free;
        end
    end

    function LV1B(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.LV1B.hor=sel_free;
        else
            ROI.LV1B.sag=sel_free;
        end
    end
    function LV2B(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.LV2B.hor=sel_free;
        else
            ROI.LV2B.sag=sel_free;
        end
    end
    function LV3B(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.LV3B.hor=sel_free;
        else
            ROI.LV3B.sag=sel_free;
        end
    end
    function RV1B(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.RV1B.hor=sel_free;
        else
            ROI.RV1B.sag=sel_free;
        end
    end
    function RV2B(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.RV2B.hor=sel_free;
        else
            ROI.RV2B.sag=sel_free;
        end
    end
    function RV3B(varargin)
        btnhandler=gco;
        currstate=get(btnhandler,'backgroundcolor');
        
        free_=imfreehand(main_plot);
        sel_free=wait(free_);
        delete(free_)
        
        if sum(currstate==[.94 .94 .94])==3
            set(btnhandler,'backgroundcolor','y')
        elseif sum(currstate==[1 1 0])==3
            set(btnhandler,'backgroundcolor','g')
        end
        drawnow;
        
        if horpersp==1
            ROI.RV3B.hor=sel_free;
        else
            ROI.RV3B.sag=sel_free;
        end
        %[0 0.5 0.2] set color to yellow if one is selected and green if
        %both are selected
    end

waitfor(gcf)

fields_=fieldnames(ROI);

for n=1:numel(fields_)
    
    test_hor_sag_existance=fieldnames(ROI.(fields_{n}));
    
    if sum(strcmp(test_hor_sag_existance,'sag')|strcmp(test_hor_sag_existance,'hor'))<2
        warning(['no corresponding second selection in ' (fields_{n}) ' - selecting all voxels from first'])
    end
    
    if sum(strcmp(test_hor_sag_existance,'sag'))==1
        I_sag=squeeze(sagview(sag_slice,:,:));
        bw_sag=roipoly(I_sag,ROI.(fields_{n}).sag(:,1),ROI.(fields_{n}).sag(:,2));
        bw_sag=reshape(bw_sag,1,size(bw_sag,1),size(bw_sag,2));
        bw_sag=repmat(bw_sag,size(sagview,1),1,1);
        idx_sag=index_mat_sag(bw_sag);
    else
        idx_sag=index_mat_sag;
    end
    if sum(strcmp(test_hor_sag_existance,'hor'))==1
        I_hor=squeeze(horview(:,:,hor_slice));
        bw_hor=roipoly(I_hor,ROI.(fields_{n}).hor(:,1),ROI.(fields_{n}).hor(:,2));
        bw_hor=reshape(bw_hor,1,size(bw_hor,1),size(bw_hor,2));
        bw_hor=repmat(bw_hor,1,1,size(horview,3));
        idx_hor=index_mat_hor(bw_hor);
    else
        idx_hor=index_mat_hor;
    end
    
    ROI.(fields_{n}).idx=idx_sag(ismember(idx_sag,idx_hor));
    ROI.(fields_{n}).mask=zeros(size(v));
    ROI.(fields_{n}).mask(ROI.(fields_{n}).idx)=1;
end
ROI_out=ROI;
end