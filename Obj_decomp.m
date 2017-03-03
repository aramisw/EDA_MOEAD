function [obj_decomp]=Obj_decomp(indiv_1,type_decomp,penalty_PBI)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%Description: This function calculate the decomposed objective value of the
%individual. The aim of the subproblem is to minimize the decompsed
%objective value
% 1: weighted Sum Approach
% 2: Tchebycheff Approach
% 3. PBI
switch type_decomp
    case 1
        obj_decomp=1/(indiv_1.obj_norm_1*indiv_1.w1+indiv_1.obj_norm_2*indiv_1.w2);
    case 2
        tmp_1=(1-indiv_1.obj_norm_1)*indiv_1.w1;
        tmp_2=(1-indiv_1.obj_norm_2)*indiv_1.w2;
        if tmp_1>tmp_2
            obj_decomp=tmp_1;
        else
            obj_decomp=tmp_2;
        end
    case 3
        %The distance from the solution to the line crossing reference
        %point
        tmp_1=(abs(indiv_1.obj_norm_1*indiv_1.w2/indiv_1.w1-indiv_1.obj_norm_2+1-indiv_1.w2/indiv_1.w1))/sqrt((indiv_1.w2/indiv_1.w1).^2+1);
        %The distance from the projected solution to the reference point
        tmp_2=sqrt((1-indiv_1.obj_norm_1)^2+(1-indiv_1.obj_norm_2)^2-tmp_1^2);
        obj_decomp=tmp_2+penalty_PBI*tmp_1;
end

end