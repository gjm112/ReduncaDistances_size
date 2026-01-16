
function Xn = ReSampleCurve(X,N)

    T = length(X);
    del(1)=0;
    for r = 2:T
        del(r) = norm(X(:,r) - X(:,r-1));
    end
    cumdel = cumsum(del)/sum(del);
    
    newdel = [0:N-1]/(N-1);
    
    Xn(1,:) = spline(cumdel,X(1,1:T),newdel);
    Xn(2,:) = spline(cumdel,X(2,1:T),newdel);