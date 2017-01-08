%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function [reference_obj_1,indic_ref_obj_1]=Ref_update_1(indiv_1,reference_obj_1)
%Description: This function checks if the reference of the ovjective 1
%should be changed according to the input individual

if indiv_1.obj_1>reference_obj_1(1)
    indic_ref_obj_1=1;
    reference_obj_1(2)=indiv_1.obj_1;
    reference_obj_1(3)=reference_obj_1(2)-reference_obj_1(1);
end
if indiv_1.obj_1<reference_obj_1(1)
    indic_ref_obj_1=1;
    reference_obj_1(1)=indiv_1.obj_1;
    reference_obj_1(3)=reference_obj_1(2)-reference_obj_1(1);
end
end