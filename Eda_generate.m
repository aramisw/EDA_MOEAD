function [...
    pst_x_1,...%-----------------INPUT------------------
    pst_y_1,...
    pst_x_2,...
    pst_y_2,...
    eda_history_1,...
    eda_history_2,...
    eda_history_clean_1,...
    eda_history_clean_2,...
    pipe_eda_1,...
    pipe_eda_2,...
    pipe_eda_clean_1,...
    pipe_eda_clean_2...%--------------------------------
    ]=Eda_generate(...
    cnt_parent,...%-----------------OUTPUT--------------
    pop_array,...
    ratio_balance,...
    amount_airship,...
    amount_neighbor,...
    type_new,...
    eda_history_1,...
    eda_history_2,...
    length_history,...
    cnt_time,...
    prec_EDA,...
    area_x,...
    area_y,...
    eda_history_clean_1,...
    eda_history_clean_2,...
    pipe_eda_1,...
    pipe_eda_2,...
    pipe_eda_clean_1,...
    pipe_eda_clean_2,...
    pr_crossover,...
    yita_SBX,...
    F_DE,...
    alpha_BLX)%-----------------------------------------
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%       Check #3
%Description: This function generate the new individual according to the
%reproduction type
%ATTENTION: This function only perform the crossover operation for the
%check experiments and the mutation is performed in the main loop:
%EDA_moead
%Reproduction type
% 1: the EDA reproduction type (MOEA/D-EDA)
% 2: MOEA/D-SBX and polynominal mutation (MOEA/D-SBX)
% 3: MOEA/D-DE with polynominal mutation (MOEA/D-DE)
% 4: MOEA/D with blend crossover and uniform mutation (MOEA/D-BLX)
% 5: MOEA/D with geometrical crossover and non-uniform mutation (MOEA/D-GC)

%Calculate the common information
x_block=area_x/prec_EDA;  %Calculate the size of the blocks of EDA model
y_block=area_y/prec_EDA;
amount_block=prec_EDA*prec_EDA; %This is the total number of blocks
amount_airship_total=amount_neighbor*amount_airship;
amount_balance=ceil(ratio_balance*amount_airship_total);
pst_x_1=zeros(1,amount_airship);
pst_y_1=zeros(1,amount_airship);
pst_x_2=zeros(1,amount_airship);
pst_y_2=zeros(1,amount_airship);

switch type_new
    case 1
        
        %Phase 1
        cnt_clean_gain=zeros(prec_EDA,prec_EDA);
        cnt_gain=zeros(prec_EDA,prec_EDA);
        indic_gain=zeros(prec_EDA,prec_EDA);
        %ATTENTION
        %cnt_clean_gain: This variables records the clean gain of each
        %block in the last generation (in this generation, the current
        %generation is to be generated.). The clean gain excludes the
        %balanced portion
        %cnt_gain:This variable records the total gain of each block in the
        %last generation. It includes two parts: the clean gain, which is
        %actually which the cnt_clean_gain records, and the balanced
        %portion.
        %indic_gain: This variable labels the blocks with '1' if any
        %airships fall into this block, and '0' if not.
        if cnt_time-1<length_history  %If not enough records are available
            %ATTENTION: Pay attention to the 'length_history-1' item. This is
            %because the cnt_time is the current time when the current
            %population has not been generated yet.
            %Get the statistic data
            for cnt_1=1:1:amount_neighbor
                for cnt_2=1:1:amount_airship
                    x_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_x_1(cnt_2)/x_block);
                    y_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_y_1(cnt_2)/y_block);
                    eda_history_1(x_label,y_label)=eda_history_1(x_label,y_label)+1;
                    eda_history_clean_1(x_label,y_label)=eda_history_clean_1(x_label,y_label)+1;
                    cnt_gain(x_label,y_label)=cnt_gain(x_label,y_label)+1;
                    cnt_clean_gain(x_label,y_label)=cnt_clean_gain(x_label,y_label)+1;
                    indic_gain(x_label,y_label)=1;
                    % ATTENTION:
                    % 1). The eda_history is reverse in y coordinate
                    % 2). The eda_history_1 is the accumulation of the last
                    % length_history generations. We do not use the
                    % averaged data here so that the programming is
                    % simplified
                end
            end
            %Calculate the balance that should be added to the empty blocks
            avg_balance=amount_balance/(amount_block-sum(sum(indic_gain)));  %Calculate the averaged gain assigned to each blocks which have not airship deployed in
            %Add balance to the blocks that do not have new airships in
            %this generations.
            for cnt_1=1:1:prec_EDA %Search the whole area to balance the blocks that have no airship deployed
                for cnt_2=1:1:prec_EDA
                    if indic_gain(cnt_1,cnt_2)==0
                        eda_history_1(cnt_1,cnt_2)=eda_history_1(cnt_1,cnt_2)+avg_balance;
                        cnt_gain(cnt_1,cnt_2)=cnt_gain(cnt_1,cnt_2)+avg_balance;
                    end
                end
            end
            
            %Set the pipe
            [pipe_eda_clean_1]=Pipe_insert(pipe_eda_clean_1,cnt_clean_gain);
            [pipe_eda_1]=Pipe_insert(pipe_eda_1,cnt_gain);
            
            %ATTENTION: All the generations so far have been added to the
            %EDA model.
            
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
                bound_bottom=(cnt_2-1)*y_block;
                %Randomly select a position in the current sampled block
                pst_x_1(cnt_3)=rand()*x_block+bound_left;
                pst_y_1(cnt_3)=rand()*y_block+bound_bottom;
            end
        else %enough records are available
            %Get the statistic data
            for cnt_1=1:1:amount_neighbor
                for cnt_2=1:1:amount_airship
                    x_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_x_1(cnt_2)/x_block);
                    y_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_y_1(cnt_2)/y_block);
                    eda_history_1(x_label,y_label)=eda_history_1(x_label,y_label)+1;
                    eda_history_clean_1(x_label,y_label)=eda_history_clean_1(x_label,y_label)+1;
                    cnt_gain(x_label,y_label)=cnt_gain(x_label,y_label)+1;
                    cnt_clean_gain(x_label,y_label)=cnt_clean_gain(x_label,y_label)+1;
                    indic_gain(x_label,y_label)=1;
                    % ATTENTION:
                    % 1). The eda_history is reverse in y coordinate
                    % 2). The eda_history_1 is the accumulation of the last
                    % length_history generations. We do not use the
                    % averaged data here so that the programming is
                    % simplified
                end
            end
            %Add balance to the blocks that do not have new airships in
            %this generations.
            avg_balance=amount_balance/(amount_block-sum(sum(indic_gain)));  %Calculate the averaged gain assigned to each blocks which have not airship deployed in
            for cnt_1=1:1:prec_EDA %Search the whole area to balance the blocks that have no airship deployed
                for cnt_2=1:1:prec_EDA
                    if indic_gain(cnt_1,cnt_2)==0
                        eda_history_1(cnt_1,cnt_2)=eda_history_1(cnt_1,cnt_2)+avg_balance;
                        cnt_gain(cnt_1,cnt_2)=cnt_gain(cnt_1,cnt_2)+avg_balance;
                    end
                end
            end
            
            %Set the eda_history_1 and eda_history_clean_1
            eda_history_1=eda_history_1-pipe_eda_1(:,:,length_history);
            eda_history_clean_1=eda_history_clean_1-pipe_eda_clean_1(:,:,length_history);
            
            %Set the pipe
            [pipe_eda_clean_1]=Pipe_insert(pipe_eda_clean_1,cnt_clean_gain);
            [pipe_eda_1]=Pipe_insert(pipe_eda_1,cnt_gain);
            
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
                bound_bottom=(cnt_2-1)*y_block;
                %Randomly select a position in the current sampled block
                pst_x_1(cnt_3)=rand()*x_block+bound_left;
                pst_y_1(cnt_3)=rand()*y_block+bound_bottom;
            end
        end
        
        %Phase 2
        cnt_clean_gain=zeros(prec_EDA,prec_EDA);
        cnt_gain=zeros(prec_EDA,prec_EDA);
        indic_gain=zeros(prec_EDA,prec_EDA);
        if cnt_time-1<length_history  %If not enough records are available
            %Get the statistic data
            for cnt_1=1:1:amount_neighbor
                for cnt_2=1:1:amount_airship
                    x_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_x_2(cnt_2)/x_block);
                    y_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_y_2(cnt_2)/y_block);
                    eda_history_2(x_label,y_label)=eda_history_2(x_label,y_label)+1;
                    eda_history_clean_2(x_label,y_label)=eda_history_clean_2(x_label,y_label)+1;
                    cnt_gain(x_label,y_label)=cnt_gain(x_label,y_label)+1;
                    cnt_clean_gain(x_label,y_label)=cnt_clean_gain(x_label,y_label)+1;
                    indic_gain(x_label,y_label)=1;
                    % ATTENTION:
                    % 1). The eda_history is reverse in y coordinate
                    % 2). The eda_history_1 is the accumulation of the last
                    % length_history generations. We do not use the
                    % averaged data here so that the programming is
                    % simplified
                end
            end
            %Calculate the balance that should be added to the empty blocks
            avg_balance=amount_balance/(amount_block-sum(sum(indic_gain)));  %Calculate the averaged gain assigned to each blocks which have not airship deployed in         
            %Add balance to the blocks that do not have new airships in
            %this generations.
            for cnt_1=1:1:prec_EDA %Search the whole area to balance the blocks that have no airship deployed
                for cnt_2=1:1:prec_EDA
                    if indic_gain(cnt_1,cnt_2)==0
                        eda_history_2(cnt_1,cnt_2)=eda_history_2(cnt_1,cnt_2)+avg_balance;
                        cnt_gain(cnt_1,cnt_2)=cnt_gain(cnt_1,cnt_2)+avg_balance;
                    end
                end
            end
            
            %Set the pipe
            [pipe_eda_clean_2]=Pipe_insert(pipe_eda_clean_2,cnt_clean_gain);
            [pipe_eda_2]=Pipe_insert(pipe_eda_2,cnt_gain);
            
            %Sample the new position
            amount_point=sum(sum(eda_history_2)); %Calculate the number of the total airships in the neighbors
            for cnt_3=1:1:amount_airship
                %Sample the block for the current airship
                tmp_2=0;
                tmp_1=rand()*amount_point;  %Calculate the position of the current sampled point in the EDA model
                for cnt_1=1:1:prec_EDA %Search the whole area to determin where the sampled data dropped\
                    for cnt_2=1:1:prec_EDA
                        tmp_2=tmp_2+eda_history_2(cnt_1,cnt_2);
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
                bound_bottom=(cnt_2-1)*y_block;
                %Randomly select a position in the current sampled block
                pst_x_2(cnt_3)=rand()*x_block+bound_left;
                pst_y_2(cnt_3)=rand()*y_block+bound_bottom;
            end
        else %enough records are available
            %Get the statistic data
            for cnt_1=1:1:amount_neighbor
                for cnt_2=1:1:amount_airship
                    x_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_x_2(cnt_2)/x_block);
                    y_label=ceil(pop_array(pop_array(cnt_parent).nb(cnt_1)).pst_y_2(cnt_2)/y_block);
                    eda_history_2(x_label,y_label)=eda_history_2(x_label,y_label)+1;
                    eda_history_clean_2(x_label,y_label)=eda_history_clean_2(x_label,y_label)+1;
                    cnt_gain(x_label,y_label)=cnt_gain(x_label,y_label)+1;
                    cnt_clean_gain(x_label,y_label)=cnt_clean_gain(x_label,y_label)+1;
                    indic_gain(x_label,y_label)=1;
                    % ATTENTION:
                    % 1). The eda_history is reverse in y coordinate
                    % 2). The eda_history_1 is the accumulation of the last
                    % length_history generations. We do not use the
                    % averaged data here so that the programming is
                    % simplified
                end
            end
            %Add balance to the blocks that do not have new airships in
            %this generations.
            avg_balance=amount_balance/(amount_block-sum(sum(indic_gain)));  %Calculate the averaged gain assigned to each blocks which have not airship deployed in
            for cnt_1=1:1:prec_EDA %Search the whole area to balance the blocks that have no airship deployed
                for cnt_2=1:1:prec_EDA
                    if indic_gain(cnt_1,cnt_2)==0
                        eda_history_2(cnt_1,cnt_2)=eda_history_2(cnt_1,cnt_2)+avg_balance;
                        cnt_gain(cnt_1,cnt_2)=cnt_gain(cnt_1,cnt_2)+avg_balance;
                    end
                end
            end
            
            %Set the eda_history_1 and eda_history_clean_1
            eda_history_2=eda_history_2-pipe_eda_2(:,:,length_history);
            eda_history_clean_2=eda_history_clean_2-pipe_eda_clean_2(:,:,length_history);
            
            %Set the pipe
            [pipe_eda_clean_2]=Pipe_insert(pipe_eda_clean_2,cnt_clean_gain);
            [pipe_eda_2]=Pipe_insert(pipe_eda_2,cnt_gain);
            
            %Sample the new position
            amount_point=sum(sum(eda_history_2)); %Calculate the number of the total airships in the neighbors
            for cnt_3=1:1:amount_airship
                %Sample the block for the current airship
                tmp_2=0;
                tmp_1=rand()*amount_point;  %Calculate the position of the current sampled point in the EDA model
                for cnt_1=1:1:prec_EDA %Search the whole area to determin where the sampled data dropped\
                    for cnt_2=1:1:prec_EDA
                        tmp_2=tmp_2+eda_history_2(cnt_1,cnt_2);
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
                bound_bottom=(cnt_2-1)*y_block;
                %Randomly select a position in the current sampled block
                pst_x_2(cnt_3)=rand()*x_block+bound_left;
                pst_y_2(cnt_3)=rand()*y_block+bound_bottom;
            end
        end
    case 2
        %SBX with polynominal mutation
        
        %Randomly select two individuals
        cnt_3=0;
        cnt_4=0;
        while cnt_3==cnt_4
            cnt_3=ceil(rand()*amount_neighbor);
            cnt_4=ceil(rand()*amount_neighbor);
        end
        
        %Phase 1 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_1(cnt_1)<=0)||(pst_x_1(cnt_1)>=area_x)
                    %Perform crossover
                    tmp_2=rand();
                    if tmp_2<=0.5
                        tmp_3=(2*tmp_2)^(1/(yita_SBX+1));
                    else
                        tmp_3=(1/(2*(1-tmp_2)))^(1/(yita_SBX+1));
                    end
                    tmp_4=rand();
                    if tmp_4>=0.5
                        pst_x_1(cnt_1)=0.5*((1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1)+(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_1(cnt_1));
                    else
                        pst_x_1(cnt_1)=0.5*((1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1)+(1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_1(cnt_1));
                    end
                end
            else
                %Not perform crossover
                pst_x_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1);
            end
        end
        %Phase 1 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_1(cnt_1)<=0)||(pst_y_1(cnt_1)>=area_y)
                    %Perform crossover
                    tmp_2=rand();
                    if tmp_2<=0.5
                        tmp_3=(2*tmp_2)^(1/(yita_SBX+1));
                    else
                        tmp_3=(1/(2*(1-tmp_2)))^(1/(yita_SBX+1));
                    end
                    tmp_4=rand();
                    if tmp_4>=0.5
                        pst_y_1(cnt_1)=0.5*((1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1)+(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_1(cnt_1));
                    else
                        pst_y_1(cnt_1)=0.5*((1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1)+(1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_1(cnt_1));
                    end
                end
            else
                %Not perform crossover
                pst_y_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1);
            end
        end
        
        %Phase 2 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_2(cnt_1)<=0)||(pst_x_2(cnt_1)>=area_x)
                    %Perform crossover
                    tmp_2=rand();
                    if tmp_2<=0.5
                        tmp_3=(2*tmp_2)^(1/(yita_SBX+1));
                    else
                        tmp_3=(1/(2*(1-tmp_2)))^(1/(yita_SBX+1));
                    end
                    tmp_4=rand();
                    if tmp_4>=0.5
                        pst_x_2(cnt_1)=0.5*((1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1)+(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_2(cnt_1));
                    else
                        pst_x_2(cnt_1)=0.5*((1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1)+(1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_2(cnt_1));
                    end
                end
            else
                %Not perform crossover
                pst_x_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1);
            end
        end
        %Phase 2 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_2(cnt_1)<=0)||(pst_y_2(cnt_1)>=area_y)
                    %Perform crossover
                    tmp_2=rand();
                    if tmp_2<=0.5
                        tmp_3=(2*tmp_2)^(1/(yita_SBX+1));
                    else
                        tmp_3=(1/(2*(1-tmp_2)))^(1/(yita_SBX+1));
                    end
                    tmp_4=rand();
                    if tmp_4>=0.5
                        pst_y_2(cnt_1)=0.5*((1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1)+(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_2(cnt_1));
                    else
                        pst_y_2(cnt_1)=0.5*((1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1)+(1+tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_2(cnt_1));
                    end
                end
            else
                %Not perform crossover
                pst_y_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1);
            end
        end
    case 3
        %DE
        
        %Record the origin F_DE
        F_DE_ori=F_DE;
        
        %Randomly select two individuals
        cnt_3=0;
        cnt_4=0;
        cnt_5=0;
        while ((cnt_3==cnt_4)||(cnt_3==cnt_5)||(cnt_4==cnt_5))
            cnt_3=ceil(rand()*amount_neighbor);
            cnt_4=ceil(rand()*amount_neighbor);
            cnt_5=ceil(rand()*amount_neighbor);
        end
        
        %Phase 1 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_1(cnt_1)<=0)||(pst_x_1(cnt_1)>=area_x)
                    %Perform the crossover
                    pst_x_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1)+F_DE*(pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_1(cnt_1)-pop_array(pop_array(cnt_parent).nb(cnt_5)).pst_x_1(cnt_1));
                    F_DE=F_DE*0.95;
                end
            else
                %Not perform the crossover
                pst_x_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1);
            end
            F_DE=F_DE_ori;
        end
        %Phase 1 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_1(cnt_1)<=0)||(pst_y_1(cnt_1)>=area_y)
                    %Perform the crossover
                    pst_y_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1)+F_DE*(pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_1(cnt_1)-pop_array(pop_array(cnt_parent).nb(cnt_5)).pst_y_1(cnt_1));
                    F_DE=F_DE*0.95;
                end
            else
                %Not perform the crossover
                pst_y_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1);
            end
            F_DE=F_DE_ori;
        end
        
        %Phase 2 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_2(cnt_1)<=0)||(pst_x_2(cnt_1)>=area_x)
                    %Perform the crossover
                    pst_x_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1)+F_DE*(pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_2(cnt_1)-pop_array(pop_array(cnt_parent).nb(cnt_5)).pst_x_2(cnt_1));
                    F_DE=F_DE*0.95;
                end
            else
                %Not perform the crossover
                pst_x_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1);
            end
            F_DE=F_DE_ori;
        end
        %Phase 2 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_2(cnt_1)<=0)||(pst_y_2(cnt_1)>=area_y)
                    %Perform the crossover
                    pst_y_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1)+F_DE*(pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_2(cnt_1)-pop_array(pop_array(cnt_parent).nb(cnt_5)).pst_y_2(cnt_1));
                    F_DE=F_DE*0.95;
                end
            else
                %Not perform the crossover
                pst_y_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1);
            end
            F_DE=F_DE_ori;
        end
        
    case 4
        %BLX
        
        %Randomly select two individuals
        cnt_3=0;
        cnt_4=0;
        while (cnt_3==cnt_4)
            cnt_3=ceil(rand()*amount_neighbor);
            cnt_4=ceil(rand()*amount_neighbor);
        end
        
        %Phase 1 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_1(cnt_1)<=0)||(pst_x_1(cnt_1)>=area_x)
                    %Perform crossover
                    tmp_2=rand();
                    tmp_3=(1+2*alpha_BLX)*tmp_2-alpha_BLX;
                    if pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1)<pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_1(cnt_1)
                        pst_x_1(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_1(cnt_1);
                    else
                        pst_x_1(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_1(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1);
                    end
                end
            else
                %Not perform the crossover
                pst_x_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1);
            end
        end
        %Phase 1 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_1(cnt_1)<=0)||(pst_y_1(cnt_1)>=area_y)
                    %Perform crossover
                    tmp_2=rand();
                    tmp_3=(1+2*alpha_BLX)*tmp_2-alpha_BLX;
                    if pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1)<pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_1(cnt_1)
                        pst_y_1(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_1(cnt_1);
                    else
                        pst_y_1(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_1(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1);
                    end
                end
            else
                %Not perform the crossover
                pst_y_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1);
            end
        end
        
        %Phase 2 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_2(cnt_1)<=0)||(pst_x_2(cnt_1)>=area_x)
                    %Perform crossover
                    tmp_2=rand();
                    tmp_3=(1+2*alpha_BLX)*tmp_2-alpha_BLX;
                    if pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1)<pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_2(cnt_1)
                        pst_x_2(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_2(cnt_1);
                    else
                        pst_x_2(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_2(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1);
                    end
                end
            else
                %Not perform the crossover
                pst_x_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1);
            end
        end
        %Phase 2 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_2(cnt_1)<=0)||(pst_y_2(cnt_1)>=area_y)
                    %Perform crossover
                    tmp_2=rand();
                    tmp_3=(1+2*alpha_BLX)*tmp_2-alpha_BLX;
                    if pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1)<pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_2(cnt_1)
                        pst_y_2(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_2(cnt_1);
                    else
                        pst_y_2(cnt_1)=(1-tmp_3)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_2(cnt_1)+tmp_3*pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1);
                    end
                end
            else
                %Not perform the crossover
                pst_y_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1);
            end
        end
        
    case 5
        %GC
        
        %Randomly select two individuals
        cnt_3=0;
        cnt_4=0;
        while (cnt_3==cnt_4)
            cnt_3=ceil(rand()*amount_neighbor);
            cnt_4=ceil(rand()*amount_neighbor);
        end
        
        %Phase 1 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_1(cnt_1)<=0)||(pst_x_1(cnt_1)>=area_x)
                    %Perform crossover
                    pst_x_1(cnt_1)=(pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_1(cnt_1))^0.5;
                end
            else
                %Not perform the crossover
                pst_x_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_1(cnt_1);
            end
        end
        %Phase 1 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_1(cnt_1)<=0)||(pst_y_1(cnt_1)>=area_y)
                    %Perform crossover
                    pst_y_1(cnt_1)=(pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_1(cnt_1))^0.5;
                end
            else
                %Not perform the crossover
                pst_y_1(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_1(cnt_1);
            end
        end
        
        %Phase 2 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_x_2(cnt_1)<=0)||(pst_x_2(cnt_1)>=area_x)
                    %Perform crossover
                    pst_x_2(cnt_1)=(pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_x_2(cnt_1))^0.5;
                end
            else
                %Not perform the crossover
                pst_x_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_x_2(cnt_1);
            end
        end
        %Phase 2 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_crossover
                while (pst_y_2(cnt_1)<=0)||(pst_y_2(cnt_1)>=area_y)
                    %Perform crossover
                    pst_y_2(cnt_1)=(pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1)*pop_array(pop_array(cnt_parent).nb(cnt_4)).pst_y_2(cnt_1))^0.5;
                end
            else
                %Not perform the crossover
                pst_y_2(cnt_1)=pop_array(pop_array(cnt_parent).nb(cnt_3)).pst_y_2(cnt_1);
            end
        end
end
end