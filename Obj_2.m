function [obj_2]=Obj_2(indiv_1,amount_airship,prec_obj_2,area_x,area_y,dist_cov)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%        Check #1
%        Check #2
%Description: This function calculate the objective value of the input
%individual

%Phase 1
block_array=zeros(prec_obj_2,prec_obj_2,2);  %the two dimensions use the same precision level
indic_block_1=zeros(prec_obj_2,prec_obj_2);
block_x=area_x/prec_obj_2;
block_y=area_y/prec_obj_2;
for cnt_1=1:1:prec_obj_2 %The block row of the whole area, start from the left of the area
    for cnt_2=1:1:prec_obj_2 %The block column of the whole area, start from the bottom of the area
        block_array(cnt_1,cnt_2,1)=(cnt_1-0.5)*block_x;
        block_array(cnt_1,cnt_2,2)=(cnt_2-0.5)*block_y;
    end
end
for cnt_3=1:1:amount_airship
    for cnt_1=1:1:prec_obj_2 %The block row of the whole area, start from the left of the area
        for cnt_2=1:1:prec_obj_2 %The block column of the whole area, start from the bottom of the area
            if indic_block_1(cnt_1,cnt_2)==0  % only those blocks that are not covered by the near space system will be tested
                if ((abs(block_array(cnt_1,cnt_2,1)-indiv_1.pst_x_1(cnt_3))+abs(block_array(cnt_1,cnt_2,2)-indiv_1.pst_y_1(cnt_3)))<=dist_cov)
                    indic_block_1(cnt_1,cnt_2)=1;
                elseif (abs(block_array(cnt_1,cnt_2,1)-indiv_1.pst_x_1(cnt_3))+abs(block_array(cnt_1,cnt_2,2)-indiv_1.pst_y_1(cnt_3))<=sqrt(2)*dist_cov)
                    tmp_1=sqrt((block_array(cnt_1,cnt_2,1)-indiv_1.pst_x_1(cnt_3)).^2+(block_array(cnt_1,cnt_2,2)-indiv_1.pst_y_1(cnt_3)).^2);
                    if tmp_1<=dist_cov
                        indic_block_1(cnt_1,cnt_2)=1;
                    end
                end
            end
        end
    end
end

%Phase 2
indic_block_2=zeros(prec_obj_2,prec_obj_2);
for cnt_3=1:1:amount_airship
    for cnt_1=1:1:prec_obj_2 %The block row of the whole area, start from the left of the area
        for cnt_2=1:1:prec_obj_2 %The block column of the whole area, start from the bottom of the area
            if indic_block_2(cnt_1,cnt_2)==0  % only those blocks that are not covered by the near space system will be tested
                if (abs(block_array(cnt_1,cnt_2,1)-indiv_1.pst_x_2(cnt_3))+abs(block_array(cnt_1,cnt_2,2)-indiv_1.pst_y_2(cnt_3))<=dist_cov)
                    indic_block_2(cnt_1,cnt_2)=1;
                elseif (abs(block_array(cnt_1,cnt_2,1)-indiv_1.pst_x_2(cnt_3))+abs(block_array(cnt_1,cnt_2,2)-indiv_1.pst_y_2(cnt_3))<=sqrt(2)*dist_cov)
                    tmp_1=sqrt((block_array(cnt_1,cnt_2,1)-indiv_1.pst_x_2(cnt_3)).^2+(block_array(cnt_1,cnt_2,2)-indiv_1.pst_y_2(cnt_3)).^2);
                    if tmp_1<=dist_cov
                        indic_block_2(cnt_1,cnt_2)=1;
                    end
                end
            end
        end
    end
end

%Calculate the number of the covered blocks
tmp_1=sum(sum(indic_block_1))+sum(sum(indic_block_2));

obj_2=tmp_1*block_x*block_y;

end