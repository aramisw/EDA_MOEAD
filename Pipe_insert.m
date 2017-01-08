%% Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status: Programming

%%
function [pipe_eda]=Pipe_insert(pipe_eda,indic_gain)
%Description: This function add a new part to the FIFO structure pipe_eda

[~,~,length_history]=size(pipe_eda);
for cnt_1=1:1:length_history-1
    pipe_eda(:,:,length_history-cnt_1+1)=pipe_eda(:,:,length_history-cnt_1);
end
pipe_eda(:,:,1)=indic_gain;
end