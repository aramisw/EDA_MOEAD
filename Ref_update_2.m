%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function [reference_obj_2,indic_ref_obj_2]=Ref_update_2(indiv_1,reference_obj_2)
%Description: This function checks if the reference of the ovjective 1
%should be changed according to the input individual

if indiv_1.obj_2>reference_obj_2(1)
    indic_ref_obj_2=1;
    reference_obj_2(2)=indiv_1.obj_1;
    reference_obj_2(3)=reference_obj_2(2)-reference_obj_2(1);
end
if indiv_1.obj_2<reference_obj_2(1)
    indic_ref_obj_2=1;
    reference_obj_2(1)=indiv_1.obj_1;
    reference_obj_2(3)=reference_obj_2(2)-reference_obj_2(1);
end
end