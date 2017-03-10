function [indic_new_domi,indic_EP_domi]=Domi_check_expand(indiv_new_1,indiv_EP)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%       Check #3
%       Check #4
%Description: This function checks the relationship between the new
%individual and the input EP individual to decide the next processing
%procedure of the two individuals. ATTENTION: The status of the new
%individual will be left to
% Result Explanation:
% For indic_new_domi:
%ATTENTION: The results are only related to the relative variables.
% 1:  The new individual dominates the current objective values of the EP
%     individual.
% -1: The new individual is dominated by the current objective values of
%     the EP individual.
% 0:  The new individual and the EP individual do not dominate each other.
% For indic_EP_domi:
% 1:  The EP individual dominates the new individual or they do not dominate eath other
%     according to its objectives of the current generation and the past generations.
% -1: The EP individual is dominated by the new individual according to its
%     objectives of the current generation and the past generations.

cnt_2=0;
%Check the relationship based on the current user distribution
if ((indiv_new_1.obj_1==indiv_EP.obj_1)||(indiv_new_1.obj_2==indiv_EP.obj_2))
    %The cases that have equality equations
    if ((indiv_new_1.obj_1==indiv_EP.obj_1)&&(indiv_new_1.obj_2>indiv_EP.obj_2))||((indiv_new_1.obj_1>indiv_EP.obj_1)&&(indiv_new_1.obj_2==indiv_EP.obj_2))
        cnt_2=2;
    end
    if ((indiv_new_1.obj_1==indiv_EP.obj_1)&&(indiv_new_1.obj_2<indiv_EP.obj_2))||((indiv_new_1.obj_1<indiv_EP.obj_1)&&(indiv_new_1.obj_2==indiv_EP.obj_2))
        cnt_2=-2;
    end
    if ((indiv_new_1.obj_1==indiv_EP.obj_1)&&(indiv_new_1.obj_2==indiv_EP.obj_2))
        cnt_2=-2;
    end
else
    %The cases where no equality exists
    if indiv_new_1.obj_1>indiv_EP.obj_1
        cnt_2=cnt_2+1;
    else
        cnt_2=cnt_2-1;
    end
    if indiv_new_1.obj_2>indiv_EP.obj_2
        cnt_2=cnt_2+1;
    else
        cnt_2=cnt_2-1;
    end
end
%Check if we should keep the new individual
switch cnt_2
    case 0
        indic_new_domi=0;
    case 2
        indic_new_domi=1;
    case -2
        indic_new_domi=-1;
end

%Check if we should keep the EP individual
indic_EP_domi=-1; %The initial value of the returned result is set as negative which stands for that the EP individual should be deleted
indic_EP_record=Domi_core(indiv_new_1.obj_1,indiv_new_1.obj_2,indiv_EP.obj_past_1,indiv_EP.obj_past_2);
%ATTENTION: According to the theory, we have to compare the relationships
%           of the new individual's objective values and the EP
%           individual's current objective values and the new individual's
%           objective values and the EP individual's history objective
%           values. However, the EP individual's history objective values
%           definitely dominate its current objective values. Therefore, we
%           only have to compare the relation between the new individual's
%           objective value and the EP individual's history objective
%           values.
if ((indic_EP_record(cnt_1)==-1)||(indic_EP_record(cnt_1)==0))
    indic_EP_domi=1;
end
end