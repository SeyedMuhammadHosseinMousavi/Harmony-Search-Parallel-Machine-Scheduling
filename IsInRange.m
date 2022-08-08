function b = IsInRange(x, VarMin, VarMax)
b = all(x >= VarMin) && all(x <= VarMax);
end