function [obj_norm_2]=Obj_norm_2(indiv_1,reference_obj_2)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: 
%        Check #1
%        Check #2
%Description: This function calculate the normalized objective 1 value
obj_norm_2=(indiv_1.obj_2-reference_obj_2(1))/reference_obj_2(3);
end