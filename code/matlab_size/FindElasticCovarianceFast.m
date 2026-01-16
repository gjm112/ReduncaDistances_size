function U = FindElasticCovarianceFast(mu,q)

close all;

reparamFlag = 1;

%a: is the number of coords for each point we have on the curve (2 here)
%b: the number of points we have sampled on each curve
%n: the number of curves in our sample 
[a,b,n]=size(q);

%takes either the mean or the med and gets it in the curve format
%then plots it, this is Figure 1 
muc=q_to_curve(mu);
%figure(1), clf;
%plot(muc(1,:),muc(2,:),'LineWidth',3)
%axis equal off; view([1 90]);

%for each curve in the sample, get the shooting vector from mu to the curve
%register each of these curves to mu
for i=1:n
    i
    tmp = ElasticShootingVectorFast(mu,q(:,:,i),reparamFlag);
    %in row i, cols 1 to b, place the x cords of v
    %in row i, cols b+1 to 2*b, place the y cords of v 
    VV(i,1:b) = tmp(1,:);
    VV(i,b+1:2*b) = tmp(2,:);
end

%covariance of VV
K = cov(VV);
%singluar value decomp of VV 
%V is U^T
%S is Sigma, has n-1 non-zero diagonal elements
[U,S,V] = svd(K);

%isn't T just b?
T = length(VV(1,:))/2;
%get sds 
s = sqrt(diag(S));

%plot main mode of variation from -1.5 to +1.5 SDs
i=1;
figure('Name', 'PC1'); clf; hold on;
for t=-3:1:3
    u = t*s(i)*U(:,i)'/2;
    UU(1,1:T) = u(1:T);
    UU(2,1:T) = u(T+1:2*T);
    UUn=UU;
    
    q = ElasticShooting(mu,UUn);
   
    
    p = q_to_curve(q);
    
    
    if (t==0)
        plot(t*0.32+p(1,:),p(2,:),'r','LineWidth',3);
    else
        plot(t*0.32+p(1,:),p(2,:),'LineWidth',3);
    end
    axis equal off; view([1 90])
    set(gcf, 'Position',  [100, 100, 500, 200])
end

%plot 2nd main mode of variation from -1.5 to +1.5 SDs
i = 2;
figure('Name', 'PC2'); clf; hold on;
for t=-3:1:3
    u = t*s(i)*U(:,i)'/2;
    UU(1,1:T) = u(1:T);
    UU(2,1:T) = u(T+1:2*T);
    UUn=UU;
    
    q = ElasticShooting(mu,UUn);   
    p = q_to_curve(q);
    

    if (t==0)
        plot(t*0.31+p(1,:),p(2,:),'r','LineWidth',3);
    else
        plot(t*0.31+p(1,:),p(2,:),'LineWidth',3);
    end
    axis equal off; view([1 90])
    set(gcf, 'Position',  [100, 100, 500, 200])
end

%plot 3rd main mode of variation from -1.5 to +1.5 SDs
i = 3;
figure('Name', 'PC3'); clf; hold on;
for t=-3:1:3
    u = t*s(i)*U(:,i)'/2;
    UU(1,1:T) = u(1:T);
    UU(2,1:T) = u(T+1:2*T);
    UUn=UU;
    
    q = ElasticShooting(mu,UUn);   
    p = q_to_curve(q);
    
    if (t==0)
        plot(t*0.31+p(1,:),p(2,:),'r','LineWidth',3);
    else
        plot(t*0.31+p(1,:),p(2,:),'LineWidth',3);
    end
    axis equal off; view([1 90])
    set(gcf, 'Position',  [100, 100, 500, 200])
end

%plot some random samples from the Gaussian distribution 
mun=mean(VV);
idx=1;
figure('Name', 'Random Sample from Gaussian'); clf; hold on;
while(idx<7)
        v = mun + zeros(1,2*T);
        for i=1:b
            % Gaussian
            c(i) = randn*s(i);
            v = v + c(i)*U(:,i)';
        end
        
        vn(1,1:T) = v(1:T);
        vn(2,1:T) = v(T+1:2*T);
        qsamp = ElasticShooting(mu,vn);
        psamp = q_to_curve(qsamp);

        z = plot(psamp(1,:)+.31*idx,psamp(2,:),'LineWidth',3);
        axis equal off; view([1 90]);
        set(gcf, 'Position',  [100, 100, 500, 200])
        idx=idx+1;
end