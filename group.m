function ind = group(X)

[s1]=length(X);

I(1)=X(1);
for i=2:s1
    if X(i)>X(i-1)+1
        I=[I X(i-1) X(i)];
    end
end
I=[I X(end)];
ind=I;