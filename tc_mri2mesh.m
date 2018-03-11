function [meshMR,MRsegments]=tc_mri2mesh(segments,varargin)
%% [meshMR,MRsegments] = tc_mri2mesh(segments,varargin)
% uses fieldtrip's ft_volumesegment and ft_prepare_mesh
%
% possible optinal input arguments as MATLAB name-value pairs:
%
% 'coordsys' MRI coordinate system as used by fieldtrip (default 'xyz')
% 'scalpsmooth' smoothing for scalp tissue (default 5)
% 'meshmethod' method used by fieldtrip to create the mesh (default 'projectmesh')
% 'numvertices' number of vertices for the output mesh (default 24000)

[FileName,PathName]=uigetfile('.nii');

if PathName~=0
    
    % define defaults
    MRI_coordsys='xyz';
    MRI_scalpsmooth=5;
    MRI_meshmethod='projectmesh';
    MRI_numvertices=24000;
    
%     if size(varargin,2)>1
%         for n=1:2:size(varargin,2)
%             switch varargin{n}
%                 case 'coordsys'
%                     MRI_coordsys=varargin{n+1};
%                 case 'scalpsmooth'
%                     MRI_scalpsmooth=varargin{n+1};
%                 case 'meshmethod'
%                     MRI_meshmethod=varargin{n+1};
%                 case 'numvertices'
%                     MRI_numvertices=varargin{n+1};
%             end
%         end
%     end
    
    disp('reading file...')
    MRI=ft_read_mri([PathName,FileName]);
    disp('done.')
    MRI.coordsys=MRI_coordsys;
    cfg           = [];
    cfg.output    = segments;
    cfg.scalpsmooth = MRI_scalpsmooth;
    %cfg.scalpthreshold = 0.085;
    disp('start segmentation...')
    segment_tpm   = ft_volumesegment(cfg,MRI);
    disp('done.')
    
    cfg             = [];
    cfg.method      = MRI_meshmethod;
    cfg.tissue      = segments;
    cfg.numvertices = MRI_numvertices;
    disp('start mesh transformation...')
    bnd             = ft_prepare_mesh(cfg, segment_tpm);
    disp('done.')
    
    Mesh_MRI=bnd;
    Mesh_MRI.VCoord=bnd.pos;
    Mesh_MRI.FCoord(:,[1,3,5])=bnd.tri;
    
    meshMR=Mesh_MRI;
    MRsegments=segment_tpm;
end
end