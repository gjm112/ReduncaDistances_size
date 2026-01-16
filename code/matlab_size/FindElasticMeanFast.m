function [mu,q,E] = FindElasticMeanFast(Data)

%this closes all of the figures currently open
close all;

%sets the number of iterations
Niter=50;

%this gives the number of 2x100 matrices we have in our dataset
n=size(Data,3);

%how small E needs to be to stop
eps = 0.05;

%this puts each of the curves into SRVF form 
%figure(1); clf; 
for i=1:n
    X = ReSampleCurve(Data(:,:,i),100);
    q(:,:,i) = curve_to_q(X);
end

del = 0.5;
%take the mean of the q's
mu = sum(q,3)/n;
%normalize the mean of the q's (to deal with scale)
%mu=mu/sqrt(InnerProd_Q(mu,mu));
%I think this centers?
%this is our initial guess
mu=ProjectC(mu);

%this is a loop that runs Niter (30 here) times 
%this process is using the shooting method to find a geodesic
for iter =1:Niter
    
    vm = 0;    
    for i=1:n
        %this tells us what iteration and curve we are on
        [iter i]
        %set the vecs in the tangent space (of mu?)
        %the exponetial map for each of our curves
        %v = ElasticShootingVectorFast(mu,q(:,:,i),1);
        v = Find_Rotation_and_Seed_unique(mu,q(:,:,i),1);
        %at the end, this will give sum of vectors in tangent space
        vm = vm + v;
    end
       %average of the vectors in the tangent space
       mu1 = vm/n;
       %this is the Forbenious norm of the sum of the v's 
       %this is the discrepency between the point we want to reach and the
       %point we want to shoot to
      E(iter) = (InnerProd_Q(mu-mu1,mu-mu1))
       %E(iter) = norm(vm,'fro');
       %this uses the elastic shoot method to find a mean shape 
       %for this iteration 
       %mu = ElasticShooting(mu,del*vm);
       mu = mu1;
       %add one to the iteration 
       iter=iter+1;
       %print out the discrepancy function 
       %we want this to reduce to 0, or as close to 0 as we can get
       %E
       
       %break out of loop if E is small
       if E(iter) < eps
           break
       end
       
       %add one to the iteration 
       iter=iter+1;
       %print out the discrepancy function 
       %we want this to reduce to 0, or as close to 0 as we can get
       %E
    
end

%this plots the forbenious norm of the sum of the v's on each iteration 
%we want this to close to 0 
%figure(101); 
%plot(E);

%this plots the mean curve 
figure('Name', 'Mean'); clf; 
mean_p = q_to_curve(mu);
plot(mean_p(1,:),mean_p(2,:),'LineWidth',2);
axis equal;