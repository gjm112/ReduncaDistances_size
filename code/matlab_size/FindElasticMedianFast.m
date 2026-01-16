function [mu,q,E] = FindElasticMedianFast(Data)

close all;

%number of iterations
Niter= 50;
%nummer of closed curves (as matrices) in our dataset 
n=size(Data,3);

%this puts each of the curves into SRVF form 
for i=1:n
    X = ReSampleCurve(Data(:,:,i),100);
    q(:,:,i) = curve_to_q(X);
end

iter=1;
del = 0.5;
%this is the mean of the SRVFs 
mu = sum(q,3)/n;
%this normalizes the mean to deal with scale
%this is our intitial value 
mu=mu/sqrt(InnerProd_Q(mu,mu));
%I think this projects onto the tangent space? 
mu=ProjectC(mu);

for iter =1:Niter
    %this gives a vector of 0s the same size as mu 
    %this initializes the expo map
    vm = zeros(size(mu));   
    %this initializes the distance between current median and the curve 
    dm=0;
    for i=1:n
        %prints the iterations and curve we are on so we can keep track 
        [iter i]
        %v is the vectoor in the tangent space 
        %d is the distance between mu and the registered q(:,:,i) 
        [v,d] = ElasticShootingVectorFast(mu,q(:,:,i),1);
        %if the distance is too large, change vm and dm 
        %vm and dm have the forms they do to get the proper updataed
        %direction
        if (d>0.000001)
            vm = vm + v/d;
            dm = dm + 1/d;
        end
    end
       %get updated direction 
       vm = vm/dm;
       %this is the Forbenious norm of vm
       %we want this to be close to 0
       E(iter) = norm(vm,'fro');
       %get the SRVF of an updated median (if E(iter) is large enough)
       mu = ElasticShooting(mu,del*vm);
       %add one to the iteration        
       iter=iter+1;
       %print out the discrepancy function 
       %E
    
end

%this plots the forbenious norm of the sum of the v's on each iteration 
%figure(11); 
%plot(E);

%plots the median curve 
figure('Name','Median'); clf; 
median_p = q_to_curve(mu);
plot(median_p(1,:),median_p(2,:),'LineWidth',3);
axis equal;