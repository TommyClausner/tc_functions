function antsmat = tc_ANTsTransform2human(ANTs_transform_file)
%% from https://github.com/netstim/leaddbs/blob/master/helpers/ea_antsmat2mat.m
load(ANTs_transform_file, 'fixed', 'AffineTransform*')

 if ~exist('AffineTransform_float_3_3','var')
 AffineTransform_float_3_3 = AffineTransform_double_3_3;
 end

antsmat=[reshape(AffineTransform_float_3_3(1:9),[3,3])',AffineTransform_float_3_3(10:12)];

m_Translation=antsmat(:,4);
antsmat=[antsmat;[0,0,0,1]];
m_Offset = [0, 0, 0];
for i=1:3
    m_Offset(i) = m_Translation(i) + fixed(i);
    for j=1:3
       m_Offset(i) = m_Offset(i)-(antsmat(i,j)*fixed(j));  % (i,j) should remain the same since in C indexing rows before cols, too.
    end
end

antsmat(1:3,4)=m_Offset;
antsmat=inv(antsmat);

% convert RAS to LPS (ITK uses LPS)
antsmat=antsmat.*[1  1 -1 -1;1  1 -1 -1;-1 -1  1  1;1  1  1  1];
end