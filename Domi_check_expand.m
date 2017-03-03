function [indic_new_domi,indic_EP_domi]=Domi_check_expand(indiv_new_1,indiv_EP)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%Description: This function checks the relationship between the new
%individual and the input EP individual to decide the next processing
%procedure of the two individuals. ATTENTION: The status of the new
%individual will be left to
% Result Explanation:
% For indic_new_domi
% 1: The new individual should be kept according to the current EP
%    individual. Pay attention, the new individual might be dominated by
%    the other EP individuals.
% -1: The new individual should be deleted according to the current EP
%     individual
% For indic_EP_domi
% 1: We should keep the EP individual
% -1: We should not keep the EP individual

%Information Preparation
[amount_record,~]=size(indiv_EP.obj_past_1);
%ATTENTION: It is necessary to inquire the length of the objective value
%           list because the length of the objective values lists of different EP
%           individuals are not necessarily equal.

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
        indic_new_domi=1;
    case 2
        indic_new_domi=1;
    case -2
        indic_new_domi=-1;
end

%Check if we should keep the EP individual
indic_EP_domi=-1;
indic_EP_record=zeros(amount_record,1);
for cnt_1=1:1:amount_record  %Get the comparison results
    indic_EP_record(cnt_1)=Domi_core(indiv_new_1.obj_1,indiv_new_1.obj_2,indiv_EP.obj_past_1,indiv_EP.obj_past_2);
end
for cnt_1=1:1:amount_record  %Check the results
    if ((indic_EP_record(cnt_1)==-1)||(indic_EP_record(cnt_1)==0))
        indic_EP_domi=1;
        break;
    end
end

end