%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function [pst_x_1,pst_y_1,pst_x_2,pst_y_2,eda_history_clean_1,eda_history_clean_2,pipe_eda_1,pipe_eda_2]=Eda_generate(...
    cnt_parent,pop_array,...
    amount_pop,...
    ratio_balance,...
    amount_airship,...
    amount_neighbor,...
    type_new,...
    eda_history_1,...
    eda,history_2,...
    length_history,...
    cnt_time,...
    prec_EDA,...
    area_x,...
    area_y,...
    eda_history_clean_1,...
    eda_history_clean_2,...
    pipe_eda_1,...
    pipe_eda_2)
%Description: This function generate the new individual according to the
%reproduction type
%Reproduction type
% 1: the EDA reproduction type (MOEA/D-EDA)
% 2: MOEA/D-SBX and polynominal mutation (MOEA/D-SBX)
% 3: MOEA/D-DE with polynominal mutation (MOEA/D-DE)
% 4: MOEA/D with blend crossover and uniform mutation (MOEA/D-BLX)
% 5: MOEA/D with geometrical crossover and non-uniform mutation (MOEA/D-GC)

%Calculate the common information
x_block=area_x/prec_EDA;  %Calculate the size of the blocks of EDA model
y_block=area_y/prec_EDA;
amount_block=x_block*y_block; %This is the total number of blocks
amount_airship_total=amount_neighbor*amount_airship;
amount_balance=ratio_balance*amount_airship_total;
pst_x_1=zeros(amount_airship,1);
pst_y_1=zeros(amount_airship,1);
pst_x_2=zeros(amount_airship,1);
pst_y_2=zeros(amount_airship,1);

%Phase 1
switch type_new
    case 1
        indic_gain=zeros(x_block,y_block);
        if cnt_time<=length_history  %If not enough records are available
            %Get the statistic data
            for cnt_1=1:1:amount_neighbor
                for cnt_2=1:1:amount_airship
                    x_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_x_1(cnt_2)/x_block);
                    y_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_y_1(cnt_2)/y_block);
                    eda_history_1(x_label,y_label)=eda_history_1(x_label,y_label)+1;
                    eda_history_clean_1(x_label,y_label)=eda_history_clean_1(x_label,y_label)+1;
                    indic_gain(x_label,y_label)=1;
                    % ATTENTION:
                    % 1). The eda_history is reverse in y coordinate
                    % 2). The eda_history_1 is the accumulation of the last
                    % length_history generations. We do not use the
                    % averaged data here so that the programming is
                    % simplified
                end
            end
            %Set the pipe
            [pipe_eda_1]=Pipe_insert(pipe_eda_1,indic_gain);
            %Add balance to the blocks that do not have new airships in
            %this generations.
            avg_balance=amount_balance/(amount_block-sum(sum(indic_gain)));  %Calculate the averaged gain assigned to each blocks which have not airship deployed in
            for cnt_1=1:1:prec_EDA %Search the whole area to balance the blocks that have no airship deployed
                for cnt_2=1:1:prec_EDA
                    if indic_gain(cnt_1,cnt_2)
                        eda_history_1(cnt_1,cnt_2)=avg_balance;
                    end
                end
            end
            %Sample the new position
            amount_point=sum(sum(eda_history_1)); %Calculate the number of the total airships in the neighbors
            for cnt_3=1:1:amount_airship
                %Sample the block for the current airship
                tmp_2=0;
                tmp_1=rand()*amount_point;  %Calculate the position of the current sampled point in the EDA model
                for cnt_1=1:1:prec_EDA %Search the whole area to determin where the sampled data dropped\
                    for cnt_2=1:1:prec_EDA
                        tmp_2=tmp_2+eda_history_1(cnt_1,cnt_2);
                        if tmp_2>=tmp_1
                            break;
                        end
                    end
                    if tmp_2>=tmp_1
                        break;
                    end
                end
                % Determine the specific coordinates of the current airship
                bound_left=(cnt_1-1)*x_block;
                bound_bottom=cnt_2*y_block;
                %Randomly select a position in the current sampled block
                pst_x_1(cnt_3)=rand()*x_block+bound_left;
                pst_y_1(cnt_3)=rand()*y_block+bound_bottom;
            end
        else %enough records are available
            %Set the eda_history_1 and eda_history_clean_1
            eda_history_1=eda_history_1-pipe_eda_1(:,:,length_history);
            eda_history_clean_1=eda_history_clean_1-pipe_eda_1(:,:,length_history);
            %Get the statistic data
            for cnt_1=1:1:amount_neighbor
                for cnt_2=1:1:amount_airship
                    x_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_x_1(cnt_2)/x_block);
                    y_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_y_1(cnt_2)/y_block);
                    eda_history_1(x_label,y_label)=eda_history_1(x_label,y_label)+1;
                    eda_history_clean_1(x_label,y_label)=eda_history_clean_1(x_label,y_label)+1;
                    indic_gain(x_label,y_label)=1;
                    % ATTENTION:
                    % 1). The eda_history is reverse in y coordinate
                    % 2). The eda_history_1 is the accumulation of the last
                    % length_history generations. We do not use the
                    % averaged data here so that the programming is
                    % simplified
                end
            end
            %Add new information to the pipe_eda
            [pipe_eda_1]=Pipe_insert(pipe_eda_1,indic_gain);
            %Add balance to the blocks that do not have new airships in
            %this generations.
            avg_balance=amount_balance/(amount_block-sum(sum(indic_gain)));  %Calculate the averaged gain assigned to each blocks which have not airship deployed in
            for cnt_1=1:1:prec_EDA %Search the whole area to balance the blocks that have no airship deployed
                for cnt_2=1:1:prec_EDA
                    if indic_gain(cnt_1,cnt_2)
                        eda_history_1(cnt_1,cnt_2)=avg_balance;
                    end
                end
            end
            %Sample the new position
            amount_point=sum(sum(eda_history_1)); %Calculate the number of the total airships in the neighbors
            for cnt_3=1:1:amount_airship
                %Sample the block for the current airship
                tmp_2=0;
                tmp_1=rand()*amount_point;  %Calculate the position of the current sampled point in the EDA model
                for cnt_1=1:1:prec_EDA %Search the whole area to determin where the sampled data dropped\
                    for cnt_2=1:1:prec_EDA
                        tmp_2=tmp_2+eda_history_1(cnt_1,cnt_2);
                        if tmp_2>=tmp_1
                            break;
                        end
                    end
                    if tmp_2>=tmp_1
                        break;
                    end
                end
                % Determine the specific coordinates of the current airship
                bound_left=(cnt_1-1)*x_block;
                bound_bottom=cnt_2*y_block;
                %Randomly select a position in the current sampled block
                pst_x_1(cnt_3)=rand()*x_block+bound_left;
                pst_y_1(cnt_3)=rand()*y_block+bound_bottom;
            end
        end
    case 2
    case 3
    case 4
    case 5
end
end