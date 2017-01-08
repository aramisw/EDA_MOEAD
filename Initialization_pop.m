%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function Initialization_pop(pop_array,amount_pop,area_x,area_y,amount_airship,amount_neighbor)
%Description: This function initialize the pop_array

%initialize the field as zero
for cnt_1=1:1:amount_pop
    pop_array(cnt_1).obj_1=0;
    pop_array(cnt_1).obj_2=0;
    pop_array(cnt_1).pst_x_1=zeros(amount_airship,1);
    pop_array(cnt_1).pst_y_1=zeros(amount_airship,1);
    pop_array(cnt_1).pst_x_2=zeros(amount_airship,1);
    pop_array(cnt_1).pst_y_2=zeros(amount_airship,1);
    pop_array(cnt_1).w1=0;
    pop_array(cnt_1).w2=0;
    pop_array(cnt_1).nb=zeros(amount_neighbor);
    pop_array(cnt_1).obj_norm_1=0;
    pop_array(cnt_1).obj_norm_2=0;
    pop_array(cnt_1).obj_decomp=0;
end

%initialize the position
for cnt_1=1:1:amount_pop
    for cnt_2=1:1:amount_airship
        pop_array(cnt_1).pst_x_1(cnt_2)=area_x*rand;
        pop_array(cnt_1).pst_y_1(cnt_2)=area_y*rand;
        pop_array(cnt_1).pst_x_2(cnt_2)=area_x*rand;
        pop_array(cnt_1).pst_y_2(cnt_2)=area_y*rand;
    end
end

%initialize the weight vector
for cnt_1=1:1:amount_pop
    tmp_1=rand*pi/2;
    pop_array(cnt_1).w1=sin(tmp_1);
    pop_array(cnt_1).w2=cos(tmp_1);
end

%initialize the neighborhood of the population
dist_w=zeros(amount_pop,amount_pop);
for cnt_1=1:1:amount_pop  %calculate the distance between any two weight vectors
    for cnt_2=cnt_1:1:amount_pop
        if cnt_1==cnt_2
            dist_w(cnt_1,cnt_2)=0;
        else
            dist_w(cnt_1,cnt_2)=(pop_array(cnt_1).w1-pop_array(cnt_2).w1).^2+(pop_array(cnt_1).w2-pop_array(cnt_2).w2).^2;
        end
    end
end
for cnt_1=1:1:amount_pop  %dumplicate the information
    for cnt_2=1:1:cnt_1
        if cnt_1~=cnt_2
            dist_w(cnt_1,cnt_2)=dist_w(cnt_2,cnt_1);
        end
    end
end
[tmp_1,tmp_2]=sort(dist_w,2);  %#ok<ASGLU> sort the distance matrix
for cnt_1=1:1:amount_pop  %record the neighbor indexes
    pop_array(cnt_1).nb=tmp_2(1:amount_neighbor,cnt_1);
end

end