function indic_add=EP_add_core2(obj_array)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170311
%Status:
%       Check #5
%Description: This is a general function. For general functions, we label
%             them with the '_core' suffix. This function refines the input
%             objective vectors according to the domination relation and
%             return the result that indicates which objective vectors are
%             to be remained and which are to be deleted. This function
%             only deals with two objectives.
%Format:
%       The input parameters should be in this form:
%                           _    _
%                           _    _
%Return result:
%        The output is in this form:
%                               _
%                               _
%        The result contains two possible output:
%        '1': the corresponding vectors should be kept
%        '0': the corresponding vectors should be deleted

%Calculate the number of the population
[amount_pop,~]=size(obj_array);

%Initialize the return variables
indic_add=zeros(amount_pop,1);

for cnt_1=1:1:amount_pop
    if cnt_1==1
        indic_add(cnt_1)=1;
    else
        indic_all=1;
        %indic_all: this variable records the final result of the current
        %           new objective vector.
        %           '0' stands for this vector should be deleted
        %           '1' stands for this vector should be added
        %           default: the default value is that the variable should
        %                    be added
        
        %Check the relation between the current objective vector and the
        %previous added vectors
        for cnt_2=1:1:cnt_1-1
            indic_single=Domi_core(obj_array(cnt_1,1),obj_array(cnt_1,2),obj_array(cnt_2,1),obj_array(cnt_2,2));
            switch indic_single
                case -1
                    %the new vector should be deleted
                    indic_all=0;
                    break; %the comparison should be terminated immediately
                case 0
                    indic_all=1; %the compassed conclusion should be reset to default immediately
                case 1
                    indic_all=1;
                    indic_add(cnt_2)=0; %the dominated vectors will be removed from the EP immediately
            end
        end
        switch indic_all
            case 0
                %the final conclusion is not adding the current vector
                %to the EP
                indic_add(cnt_1)=0;
            case 1
                %the final conclusion is adding the current vector to
                %the EP
                indic_add(cnt_1)=1;
        end
    end
end

end


