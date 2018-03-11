function new_gen_out=tc_evolute(old_gen,fitness_gen)
%%

[~,I]=sort(fitness_gen,'ascend');

partner_fct=tanh(linspace(-3,3,size(I,1)))/2+0.5;
%partner_fct=linspace(0,1,size(I,1));
%partner_fct=rand(size(I,1));

[~,apply_partner_selection]=sort(rand(1,size(I,1)).*partner_fct,'ascend');

apply_partner_selection=I(apply_partner_selection);

partn1=apply_partner_selection(1:2:end);
partn2=apply_partner_selection(2:2:end);


new_gen=zeros(size(old_gen));
for child=0:1
    ccc=0;
    for n=ceil(0.5:0.5:size(partn1,1)/2)
        ccc=ccc+1;
        DNA_cuts=round(rand*50/2)+2;
        snip_pos=randperm(size(old_gen,1)-2)+1;
        snip_pos=[1,sort(snip_pos(1:DNA_cuts)),size(old_gen,1)];
        new_ind=zeros(size(old_gen,1),1);
        for crossover=1:size(snip_pos,2)-1
            if rem(crossover,2)
                new_ind(snip_pos(crossover):snip_pos(crossover+1))=old_gen(snip_pos(crossover):snip_pos(crossover+1),partn1(n));
            else
                new_ind(snip_pos(crossover):snip_pos(crossover+1))=old_gen(snip_pos(crossover):snip_pos(crossover+1),partn2(n));
            end
        end
        
        %new_ind(old_gen(:,[partn1(n)])==old_gen(:,[partn2(n)]))=old_gen(old_gen(:,[partn1(n)])==old_gen(:,[partn2(n)]),partn1(n));
        
        mutation_ind=rand(size(new_ind))<0.1;
        new_ind(mutation_ind)=new_ind(mutation_ind)==0;
        new_gen(:,ccc+child*size(partn1,1))=new_ind;
    end
end
new_gen_out=new_gen;

