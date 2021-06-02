function [VR,myEr,NQArr]= myExtractionIV(VR_init,MaxR,MaxQ,RStepSize,X,b,Beta,QArr)

QStepSize= RStepSize;
myEr= [];
NQArr= QArr;
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

%         VR_New= VR_estim;    
        for Ri= 2:round((MaxR/RStepSize))
            if VR_estim(Ri)<0
                U=0;
            end
            MaxProf= 0;
            MaxProfQ= 0;
            for Q= QStepSize:QStepSize:min(MaxQ,(RStepSize*(Ri-1)))
                Pi= Q*(X-b*Q);
                Rindex= Ri-round(Q/RStepSize);
                Res= Pi+Beta*VR_estim(Rindex);
                if Res>MaxProf
                    MaxProf= Res;
                    MaxProfQ= Q;
                end
            end
            VR_New(Ri)= MaxProfQ*(X-b*MaxProfQ)+ Beta*VR_estim(Ri-round(MaxProfQ/RStepSize));
            NQArr(Ri)= MaxProfQ;

        end
        VR_New(1)= RStepSize;
        NQArr(1)= RStepSize;
%         Weigh= 1000;
%         WeighArr= 1+Weigh*(1-sign(sign(VR_New)+1));
%         F= WeighArr.*(VR_estim-VR_New);
        F= (VR_estim-VR_New);
        norm(F)
        myEr= [myEr norm(F)];
    end
end