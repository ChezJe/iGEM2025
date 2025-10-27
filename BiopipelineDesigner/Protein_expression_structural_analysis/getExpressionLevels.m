function explevel = getExpressionLevels(ID)

arguments
    ID (1,:) string
end

explevel = 2.^(-1 + 2*rand(log2(2), numel(ID),1))';
end