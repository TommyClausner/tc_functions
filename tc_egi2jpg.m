function [ Images ] = tc_egi2jpg()

%tc_egi2jpg
%
%type tc_egi2jpg into your MATLAB command window and select the EGI image
%container in the following dialog
%
%all Images will be saved in the same folder and given as output to the
%MATLAB workspace

   [FileName,PathName]=uigetfile('*','select EGI Image Container');
    file=[PathName FileName];
        
    unix(['xxd -p -seek 10 ' file ' > ' file '_tmp.txt']);
    
   fid = fopen([file '_tmp.txt']);
   hexvalues = textscan(fid, '%s');
   fclose(fid);
   
   hexvalues=hexvalues{1,1};

   new_hex=cell2mat(reshape(hexvalues(1:end-1,:),[],1)');
   
   Pic_start_Ind=strfind(new_hex,'0012de00')+8;
   
   Pic_stop_Ind=strfind(new_hex,'0000000000000000000000000000000000000006')-1;
   
   Pix_Inds(:,1)=Pic_start_Ind;
   
   Pix_Inds(:,2)=Pic_stop_Ind;
   
   for n=1:11   
   Pix{n,1}=lower(new_hex(Pix_Inds(n,1):Pix_Inds(n,2)));
   Pix{n,2}=strfind(Pix{n,1},'00000000000000000000000000000000ff');
   Pix{n,3}=size(Pix{n,1},2);
   end

   
   
   for m=1:11
      
   for n=1:size(Pix{m,2},2)
       
       if n==1
       acc_pic{n,1}=Pix{m,1}(1:Pix{m,2}(n));   
       else
       acc_pic{n,1}=Pix{m,1}(Pix{m,2}(n-1)+32:Pix{m,2}(n));
       end

       R{n,1}=hex2dec(reshape([acc_pic{n,1}(:,3:8:end);acc_pic{n,1}(:,4:8:end)],2,[])');
       G{n,1}=hex2dec(reshape([acc_pic{n,1}(:,5:8:end);acc_pic{n,1}(:,6:8:end)],2,[])');
       B{n,1}=hex2dec(reshape([acc_pic{n,1}(:,7:8:end);acc_pic{n,1}(:,8:8:end)],2,[])');       
       RGB{n,1}=[R{n,1},G{n,1},B{n,1}];
        
       Image_(n,:,:)=RGB{n,1};
  
   end
   
   acc_pic{n+1,1}=Pix{m,1}(Pix{m,2}(n)+32:end);

       R{n+1,1}=hex2dec(reshape([acc_pic{n+1,1}(:,3:8:end);acc_pic{n+1,1}(:,4:8:end)],2,[])');
       G{n+1,1}=hex2dec(reshape([acc_pic{n+1,1}(:,5:8:end);acc_pic{n+1,1}(:,6:8:end)],2,[])');
       B{n+1,1}=hex2dec(reshape([acc_pic{n+1,1}(:,7:8:end);acc_pic{n+1,1}(:,8:8:end)],2,[])');       
       RGB{n+1,1}=[R{n+1,1},G{n+1,1},B{n+1,1}];
        
       Image_(n+1,:,:)=RGB{n+1,1};
   
   Image_=Image_./255;
   imwrite(Image_,[file '_cam_' num2str(m) '.jpg'])
   
   Images{m}=Image_;
   
   end
   
   unix(['rm ' file '_tmp.txt']);

end

