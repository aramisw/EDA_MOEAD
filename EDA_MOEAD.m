%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function EDA_MOEAD()
%Description: This function is the main function of EDA-MOEAD

%Struct declaration
pop_array_field_1='obj_1';
pop_array_field_2='obj_2';
pop_array_field_3='pst_x_1';
pop_array_field_4='pst_y_1';
pop_array_field_5='pst_x_2';
pop_array_field_6='pst_y_2';
pop_array_field_7='w1';
pop_array_field_8='w2';
pop_array_field_9='nb';
pop_array_field_10='obj_norm_1';
pop_array_field_11='obj_norm_2';
pop_array_field_12='obj_decomp';

%Load configuration
load('config_opt.mat');

%information calculation
amount_neighbor=floor(amount_pop*ratio_neighbor);

%Population Initialization
pop_array=struct(...
    pop_array_field_1,cell(amount_pop),...
    pop_array_field_2,cell(amount_pop),...
    pop_array_field_3,cell(amount_pop),...
    pop_array_field_4,cell(amount_pop),...
    pop_array_field_5,cell(amount_pop),...
    pop_array_field_6,cell(amount_pop),...
    pop_array_field_7,cell(amount_pop),...
    pop_array_field_8,cell(amount_pop),...
    pop_array_field_9,cell(amount_pop),...
    pop_array_field_10,cell(amount_pop),...
    pop_array_field_11,cell(amount_pop),...
    pop_array_field_12,cell(amount_pop)...
    );
Initialization_pop(pop_array,amount_pop,area_x,area_y,amount_neighbor);

%Calculate the values of the initial population
for cnt_1=1:1:amount_pop
    Obj_1(pop_array(cnt_1),amount_airship,user_array);
    Obj_2(pop_array(cnt_1),amount_airship,user_array);
end
reference_obj_1=[0,0];  %Set the reference objective value as [0,0], in which the first value is the maximum objective value and the second one is the minimum objective value
reference_obj_2=[0,0];
indic_ref_obj_1=0;  %#ok<NASGU> %The indicator which indicates whether the reference of the population have been changed
indic_ref_obj_2=0;  %#ok<NASGU>
for cnt_1=1:1:amount_pop  %Update the reference
    [reference_obj_1,indic_ref_obj_1]=Ref_update_1(pop_array(cnt_1),reference_obj_1); %#ok<ASGLU>
    [reference_obj_2,indic_ref_obj_2]=Ref_update_2(pop_array(cnt_1),reference_obj_2); %#ok<ASGLU>
end
for cnt_1=1:1:amount_pop  %Calculate the normed objective value
    [pop_array(cnt_1).obj_norm_1]=Obj_norm_1(pop_array(cnt_1),reference_obj_1);
    [pop_array(cnt_1).obj_norm_2]=Obj_norm_2(pop_array(cnt_1),reference_obj_2);
end
for cnt_1=1:1:amount_pop
  pop_array(cnt_1)=Obj_norm_1(pop_array(cnt_1));
end
for cnt_1=1:1:amount_pop
    Obj_decomp(pop_array(cnt_1),decomp_type);
end

%Begin iteration
while Indic_termination==0
    cnt_time=1; %This is the counter which records the current iteration
    for cnt_1=1:1:amount_pop
        [indiv_new_1]=Eda_generate(cnt_1,pop_array,type_new,eda_history,length_history,cnt_time);
    end
    
end

end

