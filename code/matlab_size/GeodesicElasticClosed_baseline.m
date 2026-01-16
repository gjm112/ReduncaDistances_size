function d = GeodesicElasticClosed_baseline(p1,p2)

% input p1 and p2 as 2xn matrices
% to turn off figures set figs=0

%if want figs, set to 1
figs=0;

stp = 6;

%This makes a plot with both closed curves. First is blue, second is red
if figs
figure(1); clf; hold on;
plot(p1(1,:),p1(2,:),'b','LineWidth',2);
plot(p2(1,:),p2(2,:),'r','LineWidth',2);
axis equal;
axis xy off;
end

% This samples 100 points on each curve
p1 = ReSampleCurve(p1,100);
p2 = ReSampleCurve(p2,100);

% takes the curve and puts in it the SRVFs form, q 
q1 = curve_to_q(p1);
q2 = curve_to_q(p2);

tic
% This function returns a locally optimal rotation and seed point for shape
%I think q2n is the repatameterization and R is the rotation?
[q2n,R] = Find_Rotation_and_Seed_unique(q1,q2,0); 
% this scales it appropriately 
q2n = q2n/sqrt(InnerProd_Q(q2n,q2n));
% note sure what this does, maybe project to tangent space?
q2n = ProjectC(q2n);
% this takes the SRVFs form back to a closed curve (?)
p2 = q_to_curve(q2);
%I think this rotates p2 appropriately? 
p2n = R*p2;
%this reads the time elapsed
%toc

% geodesic distance between the curves
d = acos(InnerProd_Q(q1,q2n));

%figure 2 is the first curve, with sampled points
%figure 3 is the second curve, with sampled points 
%colored dots occur at 1st (red), 25th (green), 50th(black), and 75th (blue) points 
% figure 10 is the geodesic path between the two closed curves 
if figs
alpha = geodesic_sphere_Full(q1,q2n,stp);
Path_Plot(alpha,p2n,10,'b',[73,6]);
axis xy; view([1 90]);
X1=q_to_curve(q1);
X2=q_to_curve(q2n);
figure(2),clf,hold on;
plot([X1(1,:) X1(1,1)],[X1(2,:) X1(2,1)],'-','LineWidth',2);
plot([X1(1,:) X1(1,1)],[X1(2,:) X1(2,1)],'*','LineWidth',2);
plot(X1(1,1),X1(2,1),'*r','LineWidth',10);
plot(X1(1,25),X1(2,25),'*g','LineWidth',10);
plot(X1(1,50),X1(2,50),'*k','LineWidth',10);
plot(X1(1,75),X1(2,75),'*c','LineWidth',10);
axis equal off; view([1 90])
figure(3),clf,hold on;
plot([X2(1,:) X2(1,1)],[X2(2,:) X2(2,1)],'-','LineWidth',2);
plot([X2(1,:) X2(1,1)],[X2(2,:) X2(2,1)],'*','LineWidth',2);
plot(X2(1,1),X2(2,1),'*r','LineWidth',10);
plot(X2(1,25),X2(2,25),'*g','LineWidth',10);
plot(X2(1,50),X2(2,50),'*k','LineWidth',10);
plot(X2(1,75),X2(2,75),'*c','LineWidth',10);
axis equal off; view([1 90])
end