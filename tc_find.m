function [I]=tc_find(col_val,matrix_)
%% I=tc_find(col_val,matrix_)
% creates row indices for matrix_ selecting all rows that match
% columnvalues (col_val(:,2)) of columns col_val(:,2)
%
% example:
% matrix_=[1 4 5;1 4 3;2 4 5; 2 3 3; 3 1 5; 3 4 5];
% col_val=[1 2;2 4;3 5];
% tc_find(col_val,matrix_)
%
% ans =
%
%      0
%      0
%      1
%      0
%      0
%      0
%
% if more corresponding entries are assignmed those will be treated as "or"
% note, that because MATLAB assigns zeros to empty cells, please use NaN (or any other value that does not occure in your data) to
% indicate empty cells, otherwise they will be treated as "or value"
% the structure is (a OR b OR c) AND (d OR e OR f) AND (h OR i OR j) for a
% selecting rows [1 4 5] with the respective values one would create a col_val
% matrix col_val=[1 a b c;4 d e f;5 h i j];
%
% example:
% matrix_=[1 4 5;1 4 3;2 4 5; 2 3 3; 3 1 5; 3 4 5];
% col_val=[1 2 3;2 4 NaN;3 5 NaN];
% tc_find(col_val,matrix_)
%
% ans =
%
%      0
%      0
%      1
%      0
%      0
%      1
%
I=ones(size(matrix_,1),1);
for n=1:size(col_val,1)
    tmp=zeros(size(matrix_,1),1);
    for m=1:size(col_val(:,2:end),2)
        if size(col_val(:,2:end),2)>1
            tmp=matrix_(:,col_val(n,1))==col_val(n,m+1) | tmp;
        else
            tmp=matrix_(:,col_val(n,1))==col_val(n,2) & I;
        end
    end
    I=tmp & I;
end
end