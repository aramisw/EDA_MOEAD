function [reference_obj_1,indic_ref_obj_1]=Ref_update_1(indiv_1,reference_obj_1)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%Description: This function checks if the reference of the ovjective 1
%should be changed according to the input individual

%Set the initial returing value
indic_ref_obj_1=0;

if indiv_1.obj_1>reference_obj_1(2)
    indic_ref_obj_1=1;
    reference_obj_1(2)=indiv_1.obj_1;
    reference_obj_1(3)=reference_obj_1(2)-reference_obj_1(1);
end
if ((indiv_1.obj_1<reference_obj_1(1))||(reference_obj_1(1)==0))
    %ATTENTION:
    %Here, the initial value will mask all the objective values if the
    %initial value is not checked
    indic_ref_obj_1=1;
    reference_obj_1(1)=indiv_1.obj_1;
    reference_obj_1(3)=reference_obj_1(2)-reference_obj_1(1);
end
end