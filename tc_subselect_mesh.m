function [new_faces, new_verts, verts_sel] = tc_subselect_mesh(vertices, faces, sel_inds, varargin)
%tc_subselect_mesh recomputes faces of a vertex sub-selection of a mesh. 
%   Each row of a face matrix of a given mesh is a set of indices corresponding
%   to a row of the vertex matrix. In case of a triangulated mesh each row of
%   "faces" carries 3 values that point to 3 vertices or rows in the vertices
%   matrix. In case a sub-selection of points is performed (e.g. to select only
%   one half of a sphere), the face indices must be reorganized in order to fit
%   the row indices of the new (sub-selected) vertex list. This is what this
%   functions does.
%
%   [new_faces, new_verts, verts_sel] = tc_subselect_mesh(vertices, faces, sel_inds)
%
%       vertices        N x k (mostly N x 3) array with vertex coordinates
%
%       faces           M x l (M x 3 for triangular meshes) array with indices
%                       pointing to rows in "vertices" that make up a face.
%
%       sel_inds        vector containing indices of the sub-selection
%                       (corresponding to vertices)
%
%
%   An additional argument can be provided (integer smaller than the number of
%   spatial dimensions), which changes the connectivity of the remaining faces.
%   For vertices at the edge of the sub-selection, faces are no longer complete
%   (i.e. parts of the faces are not selected with the sub-selection). In that
%   case it can be defined how the sub-selection is performed. The default case
%   is conn = 1, which means a face is included if it contains at least 1 point
%   from "sel_inds". Setting conn to e.g. 3 (in case of a triangulated
%   mesh) will only include faces that are fully covered by the sub-selection.
%   Vertices that are included to complete the face (e.g. conn =1) are added to
%   "sel_inds" in order to ensure complete faces.
%
%   [new_faces, new_verts, verts_sel] = tc_subselect_mesh(vertices, faces, sel_inds, conn)

% set connectivity (default = 1)
if ~isempty(varargin) > 0
    conn = varargin{1};
else
    conn = 1;
end

%%
% find faces that contain more than "conn" of the selected vertices
sel_inds_faces = sum(ismember(faces, sel_inds), 2) >= conn;

% (sub-)select faces
faces_sel = faces(sel_inds_faces, :);

% select all vertex indices that are contained in the (sub-) selected faces
verts_sel = unique(faces_sel(:));

% (sub-)select vertices
new_verts = vertices(verts_sel, :);

% adjust face index values to match vertex (sub-) selection
new_faces = tc_changem(faces_sel, 1:length(verts_sel), verts_sel);
