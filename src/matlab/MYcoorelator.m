function[corOutput] = MYcoorelator(corInput,wCor)
% 最初と最後の(相関器の重みの長さ-1)分は過渡応答なので，その分だけ出力を短くしている
inputLength = length(corInput);
numWeight = length(wCor);
outputLength = inputLength - numWeight + 1;
corOutput = zeros(inputLength,1);
for ite = 1:outputLength
    corOutput(ite) = wCor' * corInput(ite:(ite+numWeight-1));
end
return