function [termination_1,indic_termination]=EBT(termination_1,obj_array_1,obj_array_2,cnt_time,amount_bin,amount_gen,amount_decimal)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Programming
%       Check #5
%Description: This program calculates termination status and decides whether
%             to terminate the program.
%             This program is based on the entropy based termination
%             criterion for MOEA. The theory can refer to the corresponding
%             paper.
%INPUT PARAMETERS:
% 1. termination_1: This is the data array which records the dissimilarity
%                   values of the iteration process. The format of this
%                   array is shown below
%                   _  _  _
%                   a. The first column is the dissimilarity value between
%                      this generation and the pervious generation.
%                   b. The second column is the mean value of the
%                      dissimilarity values of all the previous generations.
%                   c. The third column is the standard deviation of the
%                      dissimilarity values of all the previous generations.
% 2. indic_termination: This variable indicates the termination result.
%                       a. '0': not terminate the program
%                       b. '1': terminate the program
% 3. obj_array_1: This is the objective value vector of the previous
%                 generation. If it is the first generation, this array
%                 should be an empty array. The format is:
%                 _  _
%                 _  _
%                 ...
% 4. obj_array_2: This is the objective value vector of the current
%                 generation. The format is the same as the obj_array_1
% 5. cnt_time: This is the current generation.
% 6. amount_bin: This is the number of bins according to which the
%                dissimilarity value is calculated.
% 7. amount_gen: This is the generation during which the statistic values of
%                the dissimilarity values are compared.
% 8. amount_decimal: This is the number of decimal places to which the mean
%                    and std of the dissimilarity values are rounded to.

%Calcuate the relative number of EP individuals in each generation
[amount_pop_1,~]=size(obj_array_1);
[amount_pop_2,~]=size(obj_array_2);

%Calculate the range of the two objectives considering these two
%generations
obj_array_combine=[obj_array_1;obj_array_2];
refer_1=zeros(1,3);
refer_2=zeros(1,3);
refer_1(1)=min(obj_array_combine(:,1)); %The lower bound of the first objective
refer_1(2)=max(obj_array_combine(:,1)); %The upper bound of the first objective
refer_1(3)=refer_1(2)-refer_1(1);       %The range of the first objective
refer_2(1)=min(obj_array_combine(:,2)); %The lower bound of the second objective
refer_2(2)=max(obj_array_combine(:,2)); %The upper bound of the second objective
refer_2(3)=refer_2(2)-refer_2(1);       %The range of the second objective

%Normalize the objective array
obj_array_norm_1=zeros(amount_pop_1,2);
obj_array_norm_2=zeros(amount_pop_2,2);
for cnt_1=1:1:amount_pop_1
    obj_array_norm_1(cnt_1,1)=(obj_array_1(cnt_1,1)-refer_1(1))./refer_1(3);
    obj_array_norm_1(cnt_1,2)=(obj_array_1(cnt_1,2)-refer_2(1))./refer_2(3);
end
for cnt_1=1:1:amount_pop_2
    obj_array_norm_2(cnt_1,1)=(obj_array_2(cnt_1,1)-refer_1(1))./refer_1(3);
    obj_array_norm_2(cnt_1,2)=(obj_array_2(cnt_1,2)-refer_2(1))./refer_2(3);
end

%Calculate the size of the bins
x_block=1/amount_bin;
y_block=1/amount_bin;

switch cnt_time
    case 1
        % If it is the first generation of the iteration. Only the current
        % generation is supposed to be delt with.
        
        %Initialize the dissimilarity value
        dsm_2=0;
        
        %initialize the bin array
        block_array_2=zeros(amount_bin,amount_bin,2);
        %FORMAT: The first element of a bin in the block_array_2 is the
        %        number of points that falls into this block.
        %        The second element of a bin in the block_array_2 is the
        %        probability that a point might fall into this block.
        
        %Calculate the information of the bin array
        for cnt_1=1:1:amount_pop_2
            %ATTENTION: The recording order of the bin is not the same
            %           as the geometric order.
            x_label=ceil(obj_array_norm_2(cnt_1,1)/x_block);
            y_label=ceil(obj_array_norm_2(cnt_1,2)/y_block);
            if x_label==0
                x_label=1;
            end
            if y_label==0
                y_label=1;
            end
            block_array_2(x_label,y_label,1)=block_array_2(x_label,y_label,1)+1;
        end
        
        %Calculate the probability
        block_array_2(:,:,2)=block_array_2(:,:,1)./amount_pop_2;
        
        %Calculate the dissimilarity value of this generation
        for cnt_1=1:1:amount_bin
            for cnt_2=1:1:amount_bin
                if block_array_2(cnt_1,cnt_2,1)~=0
                    dsm_2=dsm_2-0.5*block_array_2(cnt_1,cnt_2,2)*log2(block_array_2(cnt_1,cnt_2,2));
                end
            end
        end
        
        %Prepare the result to be returned
        termination_1(1,1)=dsm_2;
        termination_1(1,2)=dsm_2;
        termination_1(1,3)=0;
        indic_termination=0; %do not terminate.
        
    otherwise
        % If it is not the first genration of the iteration
        
        %Initialize the dissimilarity value
        dsm_1=0;  %dissimilarity value of the single #1 population cells
        dsm_2=0;  %dissimilarity value of the single #2 population cells
        dsm_I=0;  %dissimilarity value of the intersection cells
        
        %initialize the bin array
        block_array_1=zeros(amount_bin,amount_bin,2);
        block_array_2=zeros(amount_bin,amount_bin,2);
        %FORMAT: The first element of a bin in block_array_1 and block_array_2 is the
        %        number of points that falls into this block.
        %        The second element of a bin in the block_array_2 is the
        %        probability that a point might fall into this block.
        
        %Calculate the information of the bin array
        for cnt_1=1:1:amount_pop_1
            %ATTENTION: The recording order of the bin is not the same
            %           as the geometric order.
            x_label=ceil(obj_array_norm_1(cnt_1,1)/x_block);
            y_label=ceil(obj_array_norm_1(cnt_1,2)/y_block);
            if x_label==0
                x_label=1;
            end
            if y_label==0
                y_label=1;
            end
            block_array_1(x_label,y_label,1)=block_array_1(x_label,y_label,1)+1;
        end
        
        %Calculate the information of the bin array
        for cnt_1=1:1:amount_pop_2
            %ATTENTION: The recording order of the bin is not the same
            %           as the geometric order.
            x_label=ceil(obj_array_norm_2(cnt_1,1)/x_block);
            y_label=ceil(obj_array_norm_2(cnt_1,2)/y_block);
            if x_label==0
                x_label=1;
            end
            if y_label==0
                y_label=1;
            end
            block_array_2(x_label,y_label,1)=block_array_2(x_label,y_label,1)+1;
        end
        
        %Calculate the probability
        block_array_1(:,:,2)=block_array_1(:,:,1)./amount_pop_1;
        block_array_2(:,:,2)=block_array_2(:,:,1)./amount_pop_2;
        
        %Calculate the dissimilarity value of the previous generation
        for cnt_1=1:1:amount_bin
            for cnt_2=1:1:amount_bin
                if (block_array_1(cnt_1,cnt_2,1)~=0)&&(block_array_2(cnt_1,cnt_2,1)==0)
                    dsm_1=dsm_1-0.5*block_array_1(cnt_1,cnt_2,2)*log2(block_array_1(cnt_1,cnt_2,2));
                end
            end
        end
        %Calculate the dissimilarity value of the present generation
        for cnt_1=1:1:amount_bin
            for cnt_2=1:1:amount_bin
                if (block_array_2(cnt_1,cnt_2,1)~=0)&&(block_array_1(cnt_1,cnt_2,1)==0)
                    dsm_2=dsm_2-0.5*block_array_2(cnt_1,cnt_2,2)*log2(block_array_2(cnt_1,cnt_2,2));
                end
            end
        end
        %Calculate the dissimilarity value of the intersected cells
        for cnt_1=1:1:amount_bin
            for cnt_2=1:1:amount_bin
                if (block_array_2(cnt_1,cnt_2,1)~=0)&&(block_array_1(cnt_1,cnt_2,1)~=0)
                    dsm_I=dsm_I-0.5*block_array_1(cnt_1,cnt_2,2)*log2(block_array_2(cnt_1,cnt_2,2)/block_array_1(cnt_1,cnt_2,2))-0.5*block_array_2(cnt_1,cnt_2,2)*log2(block_array_1(cnt_1,cnt_2,2)/block_array_2(cnt_1,cnt_2,2));
                end
            end
        end
        dsm=dsm_1+dsm_2+dsm_I;
        
        %Calculate statistic information
        termination_1(cnt_time,1)=dsm;
        termination_1(cnt_time,2)=mean(termination_1(1:cnt_time,1));
        termination_1(cnt_time,3)=std(termination_1(1:cnt_time,1));
        
        %Check whether to terminate the iteration
        if cnt_time<amount_gen
            %If the number of the iterations are fewer than the required
            %comparison generation, then do not terminate the iteration
            indic_termination=0;
        else
            %If enough iterations are available
            
            %Check the mean value
            mean_tmp=round(termination_1(cnt_time-amount_gen+1:cnt_time,2),amount_decimal);  %round the mean to prespecified digits
            indic_mean=0;
            % indic_mean:
            %             '0': the data are the same so far
            %             '1': the data contains different values in the
            %                  inspection generations.
            for cnt_1=1:1:amount_gen-1
                if mean_tmp(amount_gen-cnt_1+1)~=mean_tmp(amount_gen-cnt_1)
                    indic_mean=1;
                    break;
                end
            end
            
            %Check the std value
            std_tmp=round(termination_1(cnt_time-amount_gen+1:cnt_time,3),amount_decimal);  %round the mean to prespecified digits
            indic_std=0;
            % indic_std:
            %             '0': the data are the same so far
            %             '1': the data contains different values in the
            %                  inspection generations.
            for cnt_1=1:1:amount_gen-1
                if std_tmp(amount_gen-cnt_1+1)~=std_tmp(amount_gen-cnt_1)
                    indic_std=1;
                    break;
                end
            end
            %Check the final result
            if (indic_mean==0)&&(indic_std==0)
                indic_termination=1;
            else
                indic_termination=0;
            end
        end
end
end

