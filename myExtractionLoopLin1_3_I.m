function [VR_estim,myEr,NQArr]= myExtractionLoop(VR_init,MaxR,MaxQ,RStepSize,X,b,Beta,QArr,C)

QStepSize= RStepSize;
myEr= [];
NQArr= QArr;
VR_estim= VR_init;
epsi= .001;
N= 1;
 while N>epsi
   
        for Ri= 2:round((MaxR/RStepSize))
%             if VR_estim(Ri)<0
%                 U=0;
%             end
            MaxProf= 0;
            MaxProfQ= 0;
            for Q= QStepSize:QStepSize:min(MaxQ,(RStepSize*(Ri-1)))
                Pi= Q*(X-b*Q)-C*Q;
                Rindex= Ri-round(Q/RStepSize);
                Res= Pi+Beta*VR_estim(Rindex);
                if Res>MaxProf
                    MaxProf= Res;
                    MaxProfQ= Q;
                end
            end
            VR_New(Ri)= (MaxProfQ*(X-b*MaxProfQ)-C*MaxProfQ)+ Beta*VR_estim(Ri-round(MaxProfQ/RStepSize));
            NQArr(Ri)= MaxProfQ;

        end
        VR_New(1)= RStepSize;
        NQArr(1)= RStepSize;

        F= (VR_estim-VR_New);
        N= norm(F)
        VR_estim= VR_New;
        myEr= [myEr norm(F)];
 end
end