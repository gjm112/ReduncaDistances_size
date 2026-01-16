%this function finds the elastic mean and lets you choose the initial guess
%this is based on the fast version of FindElasticMeanFast
function mu = FindElasticMeanFast_intialized(Data, initial_mu)

%Data is the data you want to find the mean of
%initial_mu is mean curve we would like to start out in (make sure it's NOT
%in SRVF form already)

%this closes all of the figures currently open
close all;

%sets the number of iterations
Niter=50;

%how small E needs to be to stop
eps = 0.05;

%this gives the number of 2x100 matrices we have in our dataset
n=size(Data,3);

%this puts each of the curves into SRVF form 
%figure(1); clf; 
for i=1:n
    X = ReSampleCurve(Data(:,:,i),100);
    q(:,:,i) = curve_to_q(X);
end

del = 0.5;

%set initial value for mean 
mu=initial_mu;

%this is a loop that runs Niter (30 here) times 
%this process is using the shooting method to find a geodesic
for iter =1:Niter
    
    vm = 0;    
    for i=1:n
        %this tells us what iteration and curve we are on
        [iter i]
        %set the vecs in the tangent space (of mu?)
        %the exponetial map for each of our curves
        v = ElasticShootingVectorFast(mu,q(:,:,i),1);
        %at the end, this will give sum of vectors in tangent space
        vm = vm + v;
    end
       %average of the vectors in the tangent space
       vm = vm/n;
       %this is the Forbenious norm of the sum of the v's 
       %this is the discrepency between the point we want to reach and the
       %point we want to shoot to
       E(iter) = norm(vm,'fro');
       
       %this uses the elastic shoot method to find a mean shape 
       %for this iteration 
       mu = ElasticShooting(mu,del*vm);
       
       %break out of loop if E is small
       if E(iter) < eps
           break
       end
          
       %add one to the iteration 
       iter=iter+1;
       %print out the discrepancy function 
       %we want this to reduce to 0, or as close to 0 as we can get
          
end
