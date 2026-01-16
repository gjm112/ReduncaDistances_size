function [q2new,Rbest] = Find_Rotation_and_Seed_unique_fast(q1,q2,reparamFlag)
% This function returns a locally optimal rotation and seed point for shape
% q2 w.r.t. q1

[n,T] = size(q1);

scl = 1;
minE = 1000;
for ctr = 0:floor(T/scl)
    q2n = ShiftF(q2,scl*ctr);
    [q2n,R] = Find_Best_Rotation(q1,q2n);
    %Ec = acos(InnerProd_Q(q1,q2n));    
    Ec = sqrt(InnerProd_Q(q1-q2n,q1-q2n));
    if Ec < minE
        q2best  = q2n;
        Rbest = R;
        minE = Ec;
    end
end
    
    if(reparamFlag)        
            gamI = DynamicProgrammingQ(q2best,q1,0,0);
            gamI = (gamI-gamI(1))/(gamI(end)-gamI(1));
            p2n = q_to_curve(q2best);
            p2new = Group_Action_by_Gamma_Coord(p2n,gamI);
            q2new = curve_to_q(p2new);
            q2new = ProjectC(q2new);
    else
        q2new = q2best;
    end


return;