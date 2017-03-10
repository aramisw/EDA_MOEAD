function EP_list=EP_add(EP_list,indiv_new_1,type_new)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%       Check #3
%       Check #4
%Description: This function add the new individual to the EP.
%             The other comparative operators do not need the history
%             objective value.

%Struct declaration
pop_array_field_1=...
    {...
    'obj_1';...
    'obj_2';...
    'pst_x_1';...
    'pst_y_1';...
    'pst_x_2';...
    'pst_y_2';...
    'w1';...
    'w2';...
    'nb';...
    'obj_norm_1';...
    'obj_norm_2';...
    'obj_decomp';...
    'obj_past_1';...
    'obj_past_2'...
    };
switch type_new
    case 1
        %This is the case where the best history objective value is needed
        [~,amount_EP]=size(EP_list);
        indic_new_add=zeros(amount_EP,1);
        indic_EP_domi=zeros(amount_EP,1);
        
        if amount_EP~=0
            for cnt_1=1:1:amount_EP
                [indic_new_add(cnt_1),indic_EP_domi(cnt_1)]=Domi_check_expand(indiv_new_1,EP_list(cnt_1));
            end
            
            %Select the next EP generation
            cnt_2=1;
            EP_list_tmp=struct(...    %The EP_list_tmp should be initialized in case that all EP individuals should be deleted
                pop_array_field_1{1},cell(0),...
                pop_array_field_1{2},cell(0),...
                pop_array_field_1{3},cell(0),...
                pop_array_field_1{4},cell(0),...
                pop_array_field_1{5},cell(0),...
                pop_array_field_1{6},cell(0),...
                pop_array_field_1{7},cell(0),...
                pop_array_field_1{8},cell(0),...
                pop_array_field_1{9},cell(0),...
                pop_array_field_1{10},cell(0),...
                pop_array_field_1{11},cell(0),...
                pop_array_field_1{12},cell(0),...
                pop_array_field_1{13},cell(0),...
                pop_array_field_1{14},cell(0)...
                );
            for cnt_1=1:1:amount_EP
                if indic_EP_domi(cnt_1)==1
                    EP_list_tmp(cnt_2)=EP_list(cnt_1);
                    cnt_2=cnt_2+1;
                end
            end
            %Check if we can add the new individual to the EP
            indic_new_total_ok=1;
            for cnt_1=1:1:amount_EP
                if indic_new_add(cnt_1)==-1
                    indic_new_total_ok=0;
                    break;
                end
            end
            if indic_new_total_ok==1
                %The new individual is totally ok to be added to the new individual
                [~,amount_EP_tmp]=size(EP_list_tmp);
                EP_list_tmp(amount_EP_tmp+1)=indiv_new_1;
                EP_list_tmp(amount_EP_tmp+1).obj_past_1=EP_list_tmp(amount_EP_tmp+1).obj_1;
                EP_list_tmp(amount_EP_tmp+1).obj_past_2=EP_list_tmp(amount_EP_tmp+1).obj_2;
            end
            
            %Prepare the result to be returned
            EP_list=EP_list_tmp;
        else
            EP_list=indiv_new_1;
            EP_list.obj_past_1=EP_list.obj_1;
            EP_list.obj_past_2=EP_list.obj_2;
        end
    otherwise
        %This is the case where we do not use the best history objective
        %value
        [~,amount_EP]=size(EP_list);
        indic_new_domi=zeros(amount_EP,1);
        
        if amount_EP~=0
            for cnt_1=1:1:amount_EP
                indic_new_domi(cnt_1)=Domi_core(indiv_new_1.obj_1,indiv_new_1.obj_2,EP_list(cnt_1).obj_1,EP_list(cnt_1).obj_2);
            end
            
            %Select the next EP generation
            cnt_2=1;
            EP_list_tmp=struct(...    %The EP_list_tmp should be initialized in case that all EP individuals should be deleted
                pop_array_field_1{1},cell(0),...
                pop_array_field_1{2},cell(0),...
                pop_array_field_1{3},cell(0),...
                pop_array_field_1{4},cell(0),...
                pop_array_field_1{5},cell(0),...
                pop_array_field_1{6},cell(0),...
                pop_array_field_1{7},cell(0),...
                pop_array_field_1{8},cell(0),...
                pop_array_field_1{9},cell(0),...
                pop_array_field_1{10},cell(0),...
                pop_array_field_1{11},cell(0),...
                pop_array_field_1{12},cell(0),...
                pop_array_field_1{13},cell(0),...
                pop_array_field_1{14},cell(0)...
                );
            for cnt_1=1:1:amount_EP
                if indic_new_domi(cnt_1)~=1
                    EP_list_tmp(cnt_2)=EP_list(cnt_1);
                    cnt_2=cnt_2+1;
                end
            end
            %Check if we can add the new individual to the EP
            indic_new_total_ok=1;
            for cnt_1=1:1:amount_EP
                if indic_new_domi(cnt_1)==-1
                    indic_new_total_ok=0;
                    break;
                end
            end
            if indic_new_total_ok==1
                %The new individual is totally ok to be added to the new individual
                [~,amount_EP_tmp]=size(EP_list_tmp);
                EP_list_tmp(amount_EP_tmp+1)=indiv_new_1;
                EP_list_tmp(amount_EP_tmp+1).obj_past_1=EP_list_tmp(amount_EP_tmp+1).obj_1;
                EP_list_tmp(amount_EP_tmp+1).obj_past_2=EP_list_tmp(amount_EP_tmp+1).obj_2;
            end
            
            %Prepare the result to be returned
            EP_list=EP_list_tmp;
        else
            EP_list=indiv_new_1;
            %No history objective values are recorded
        end
end
end