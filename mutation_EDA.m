function [pst_x_1,pst_y_1,pst_x_2,pst_y_2]=mutation_EDA(...
    pst_x_1,...
    pst_y_1,...
    pst_x_2,...
    pst_y_2,...
    type_mutation,...
    pr_mutation,...
    yita_poly,...
    area_x,...
    area_y,...
    gen_max,...
    cnt_time,...
    beta_NU)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%       Check #3
%Description: This function mutate the input individuals
% 1: polynominal mutation
% 2: uniform mutation
% 3: non-uniform mutation (NU)

%Calculate common information
[~,amount_airship]=size(pst_x_1);

switch type_mutation
    
    case 1
        %Polynominal mutation
        
        %Phase 1 x
        for cnt_1=1:1:amount_airship
            indic_mutated=0;
            %ATTENTION: The 'indic_mutated' is used to indicate whether the
            %           mutation operation has been performed.
            %           '0' for not performed
            %           '1' for performed
            tmp_1=rand();
            if tmp_1<=pr_mutation
                while (pst_x_1(cnt_1)<=0)||(pst_x_1(cnt_1)>=area_x)||(indic_mutated==0)
                    %Perform mutation
                    tmp_2=rand();
                    if tmp_2<0.5
                        tmp_3=(2*tmp_2)^(1/(yita_poly+1))-1;
                    else
                        tmp_3=1-(2-2*tmp_2)^(1/(yita_poly+1));
                    end
                    pst_x_1(cnt_1)=pst_x_1(cnt_1)+tmp_3*area_x;
                    indic_mutated=1;
                end
            end
        end
        %Phase 1 y
        for cnt_1=1:1:amount_airship
            indic_mutated=0;
            %ATTENTION: The 'indic_mutated' is used to indicate whether the
            %           mutation operation has been performed.
            %           '0' for not performed
            %           '1' for performed
            tmp_1=rand();
            if tmp_1<=pr_mutation
                while (pst_y_1(cnt_1)<=0)||(pst_y_1(cnt_1)>=area_y)||(indic_mutated==0)
                    %Perform mutation
                    tmp_2=rand();
                    if tmp_2<0.5
                        tmp_3=(2*tmp_2)^(1/(yita_poly+1))-1;
                    else
                        tmp_3=1-(2-2*tmp_2)^(1/(yita_poly+1));
                    end
                    pst_y_1(cnt_1)=pst_y_1(cnt_1)+tmp_3*area_y;
                    indic_mutated=1;
                end
            end
        end
        
        %Phase 2 x
        for cnt_1=1:1:amount_airship
            indic_mutated=0;
            %ATTENTION: The 'indic_mutated' is used to indicate whether the
            %           mutation operation has been performed.
            %           '0' for not performed
            %           '1' for performed
            tmp_1=rand();
            if tmp_1<=pr_mutation
                while (pst_x_2(cnt_1)<=0)||(pst_x_2(cnt_1)>=area_x)||(indic_mutated==0)
                    %Perform mutation
                    tmp_2=rand();
                    if tmp_2<0.5
                        tmp_3=(2*tmp_2)^(1/(yita_poly+1))-1;
                    else
                        tmp_3=1-(2-2*tmp_2)^(1/(yita_poly+1));
                    end
                    pst_x_2(cnt_1)=pst_x_2(cnt_1)+tmp_3*area_x;
                    indic_mutated=1;
                end
            end
        end
        %Phase 2 y
        for cnt_1=1:1:amount_airship
            indic_mutated=0;
            %ATTENTION: The 'indic_mutated' is used to indicate whether the
            %           mutation operation has been performed.
            %           '0' for not performed
            %           '1' for performed
            tmp_1=rand();
            if tmp_1<=pr_mutation
                while (pst_y_2(cnt_1)<=0)||(pst_y_2(cnt_1)>=area_y)||(indic_mutated==0)
                    %Perform mutation
                    tmp_2=rand();
                    if tmp_2<0.5
                        tmp_3=(2*tmp_2)^(1/(yita_poly+1))-1;
                    else
                        tmp_3=1-(2-2*tmp_2)^(1/(yita_poly+1));
                    end
                    pst_y_2(cnt_1)=pst_y_2(cnt_1)+tmp_3*area_y;
                    indic_mutated=1;
                end
            end
        end
    case 2
        %Uniform mutation
        
        %Phase 1 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_x_1(cnt_1)=pst_x_1(cnt_1)+tmp_3*(area_x-pst_x_1(cnt_1));
                else
                    pst_x_1(cnt_1)=pst_x_1(cnt_1)-tmp_3*pst_x_1(cnt_1);
                end
            end
        end
        %Phase 1 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_y_1(cnt_1)=pst_y_1(cnt_1)+tmp_3*(area_y-pst_y_1(cnt_1));
                else
                    pst_y_1(cnt_1)=pst_y_1(cnt_1)-tmp_3*pst_y_1(cnt_1);
                end
            end
        end
        
        %Phase 2 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_x_2(cnt_1)=pst_x_2(cnt_1)+tmp_3*(area_x-pst_x_2(cnt_1));
                else
                    pst_x_2(cnt_1)=pst_x_2(cnt_1)-tmp_3*pst_x_2(cnt_1);
                end
            end
        end
        %Phase 2 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_y_2(cnt_1)=pst_y_2(cnt_1)+tmp_3*(area_y-pst_y_2(cnt_1));
                else
                    pst_y_2(cnt_1)=pst_y_2(cnt_1)-tmp_3*pst_y_2(cnt_1);
                end
            end
        end
    case 3
        %Non-uniform mutation
        
        %Phase 1 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_x_1(cnt_1)=pst_x_1(cnt_1)+tmp_3*(area_x-pst_x_1(cnt_1))*(1-cnt_time/(gen_max+1))^beta_NU;
                else
                    pst_x_1(cnt_1)=pst_x_1(cnt_1)-tmp_3*pst_x_1(cnt_1)*(1-cnt_time/(gen_max+1))^beta_NU;
                end
            end
        end
        %Phase 1 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_y_1(cnt_1)=pst_y_1(cnt_1)+tmp_3*(area_y-pst_y_1(cnt_1))*(1-cnt_time/(gen_max+1))^beta_NU;
                else
                    pst_y_1(cnt_1)=pst_y_1(cnt_1)-tmp_3*pst_y_1(cnt_1)*(1-cnt_time/(gen_max+1))^beta_NU;
                end
            end
        end
        
        %Phase 2 x
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_x_2(cnt_1)=pst_x_2(cnt_1)+tmp_3*(area_x-pst_x_2(cnt_1))*(1-cnt_time/(gen_max+1))^beta_NU;
                else
                    pst_x_2(cnt_1)=pst_x_2(cnt_1)-tmp_3*pst_x_2(cnt_1)*(1-cnt_time/(gen_max+1))^beta_NU;
                end
            end
        end
        %Phase 2 y
        for cnt_1=1:1:amount_airship
            tmp_1=rand();
            if tmp_1<=pr_mutation
                tmp_2=rand();
                tmp_3=rand()*0.99999;
                if tmp_2>0.5
                    pst_y_2(cnt_1)=pst_y_2(cnt_1)+tmp_3*(area_y-pst_y_2(cnt_1))*(1-cnt_time/(gen_max+1))^beta_NU;
                else
                    pst_y_2(cnt_1)=pst_y_2(cnt_1)-tmp_3*pst_y_2(cnt_1)*(1-cnt_time/(gen_max+1))^beta_NU;
                end
            end
        end
end

end