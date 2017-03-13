function hv=Hypervolumn(pop_array)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170311
%Status: 
%       Check #5
%Description: This function calculates the hypervolumn of the input
%             pop_array.

%Calculate the size of the population array
[~,amount_pop]=size(pop_array);

%Initialize the retrieved objective value array
obj_array=zeros(amount_pop,2);

%Initialize the hv
hv=0;

%Retrieve the objective value from the population structure
for cnt_1=1:1:amount_pop
    %ATTENTION: The hypervolumn is calculated using the current objective
    %           value.
    obj_array(cnt_1,1)=pop_array(cnt_1).obj_past_1;
    obj_array(cnt_1,2)=pop_array(cnt_1).obj_past_2;
end

%Refine the objecitve vector array
indic_add=EP_add_core2(obj_array);
amount_add=sum(indic_add);
obj_array_tmp=zeros(amount_add,2);
cnt_2=1;
for cnt_1=1:1:amount_pop
    if indic_add(cnt_1)==1
        obj_array_tmp(cnt_2,:)=obj_array(cnt_1,:);
        cnt_2=cnt_2+1;
    end
end
obj_array=obj_array_tmp;
amount_pop=amount_add;

%Sort the objective value array
obj_array=sortrows(obj_array);

%Calculate the hypervolumn
for cnt_1=1:1:amount_pop
    if cnt_1==1
        hv=obj_array(cnt_1,1)*obj_array(cnt_1,2);
    else
    hv=hv+(obj_array(cnt_1,1)-obj_array(cnt_1-1,1))*obj_array(cnt_1,2);
    end
end

end

