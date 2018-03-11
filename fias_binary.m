function vec_bin=fias_binary(i,n)
%% vec_bin=fias_binary(i,n)
% clones decimalToBinaryVector(decimalNumber,numberOfBits)
if size(dec2base(i,2),2)>n
    n=size(dec2base(i,2),2);
end
vec_bin=num2str(zeros(size(i,2),n));
vec_bin(vec_bin==' ') = [];
vec_bin=reshape(vec_bin,size(i,2),n);
binary=dec2base(i,2);
vec_bin(:,end-size(binary,2)+1:end)=binary;
vec_bin=vec_bin-'0';

end