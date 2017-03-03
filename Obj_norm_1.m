function [obj_norm_1]=Obj_norm_1(indiv_1,reference_obj_1)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: 
%        Check #1
%        Check #2
%Description: This function calculates the normalized objective 1 value
obj_norm_1=(indiv_1.obj_1-reference_obj_1(1))/reference_obj_1(3);
end