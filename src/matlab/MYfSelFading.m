function[channelOutput] = MYfSelFading(s,delay,channelResponse)
% 縦方向が遅延軸，チャネルレスポンスは,(チャネル数×1)のはず
sDelayed = zeros(length(s),length(delay));
for delayCount = 1:length(delay)
    sDelayed(:,delayCount) = s;
    sDelayed(delay(delayCount)+1:end,delayCount) = s(1:end-delay(delayCount));
    sDelayed(1:delay(delayCount),delayCount) = zeros(size( s((end-delay(delayCount)+1):end) ));
end
channelOutput = sDelayed * channelResponse;
return