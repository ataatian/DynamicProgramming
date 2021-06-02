function [VR,myEr]= myExtraction(VR_init,MaxR,MaxQ,RStepSize,X,b,Beta)

QStepSize= RStepSize;
myEr= [];

% numberofvariables=length(VR_init);
% 
% options = optimset('LargeScale','off',...
%     'TolFun',1e-6,...
%     'TolX',1e-6,...
%     'MaxFunEvals',25*numberofvariables,...
%     'MaxIter', 800,...
%     'LevenbergMarquardt','on',...
%     'Display', 'off');

% [VR, resnorm, residual, exitflag] = lsqnonlin(@obj_fun, VR_init,[],[],options);
 [VR, resnorm, residual, exitflag] = lsqnonlin(@obj_fun, VR_init);
% VR = fminsearch(@obj_fun, VR_init);

    function F = obj_fun(VR_estim)

        VR_New= VR_estim;    
        for Ri= 1:floor((MaxR/RStepSize))
            MaxProf= 0;
            MaxProfQ= 0;
            flag= 0;
            for Q= 0:QStepSize:MaxQ
                Pi= Q*(X-b*Q);
                if ((RStepSize*Ri)-Q)>=1
                    Rindex= Ri-floor(Q/RStepSize);
                    Res= Pi+Beta*VR_estim(Rindex);
                    flag =1;
                    if Res>MaxProf
                        MaxProf= Res;
                        MaxProfQ= Q;
                    end
                end                
            end
            if flag==1
                VR_New(Ri)= MaxProfQ*(X-b*MaxProfQ)+ Beta*VR_estim(Ri-floor(MaxProfQ/RStepSize));
            end
        end

        F= VR_estim-VR_New;
        norm(F);
        myEr= [myEr norm(F)];
    end
end