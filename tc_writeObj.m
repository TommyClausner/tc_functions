function [ Output ] = tc_writeObj( Vertices,Faces)

V=num2str(Vertices,'v %f %f %f');
F=num2str(Faces,'f %d %d %d');

[FileName,PathName,FilterIndex] = uiputfile('*.obj','save .obj File','Model');

[pathstr,name,ext] = fileparts(FileName);

filename=name;

hdr=strvcat(['mtllib ' filename '.mtl'],'usemtl Solid');

Output=strvcat(hdr,V,F);

for n=1:size(Output,1)    
    tmp2{n,1}=strtrim(Output(n,:));    
end
Output=tmp2;

filename=[PathName filename];

fid = fopen([filename '.txt'],'wt');
fprintf(fid,'%s\n',Output{:});
fclose(fid);
movefile([filename '.txt'], [filename '.obj'])

end

