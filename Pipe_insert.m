function [pipe_eda]=Pipe_insert(pipe_eda,cnt_gain)
%Project: EDA_MOEAD
%Author: Wang Zhao
%Date: 20170103
%Status:
%       Check #1
%       Check #2
%       Check #3
%Description: This function add a new part to the FIFO structure pipe_eda

[~,~,length_history]=size(pipe_eda);
for cnt_1=1:1:length_history-1
    pipe_eda(:,:,length_history-cnt_1+1)=pipe_eda(:,:,length_history-cnt_1);
end
pipe_eda(:,:,1)=cnt_gain;
end