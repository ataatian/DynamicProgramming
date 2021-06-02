% Resource Extraction Problem

clear
clc

close all
Beta= 0.05;
RStepSize= 0.1;
QStepSize= RStepSize;
X= 100;
b= 5;
MaxQ= X/b;
MaxR= 20;
myTime= 100;

%initialization
Q_i= X/(2*b);
Pi_i= Q_i*(X-b*Q_i);
for Ri= 1:round((MaxR/RStepSize))
    t_i= RStepSize*(Ri)/Q_i;
    VR_init(Ri)= Pi_i/Beta*(1-exp(-Beta*t_i));
end
QArr= Q_i*ones(round((MaxR/RStepSize)),1);

%QArr= ones(round((MaxR/RStepSize)),1);
VR_init= 10*ones(round((MaxR/RStepSize)),1);
figure(1)
%Plot initial Value function versus R0
plot(VR_init), hold on
[VR,myEr,NQArr]= myExtractionII(VR_init,MaxR,MaxQ,RStepSize,X,b,Beta,QArr);

%Plot optimized Value function versus R0
plot(VR)
title('V(R) vs R - Initial guess & final answer')
IterationN= size(myEr,2);
LastErr= myEr(IterationN);
%plot Extraction over time
% R0= MaxR;
% ExtraArr= [];
% ProfitArr= [];
% PriceArr= [];
% while R0>0 
%     Diff= .1;
%     for Q= 0:QStepSize:MaxQ
%         Pi= Q*(X-b*Q);
%         RR= round(R0/RStepSize);
%         RQ= round((R0-Q)/RStepSize);
%         if (RR>0)&&(RQ>0)
%             if (VR(RR)-Beta*VR(RQ)-Pi)<Diff
%                 Diff= (VR(RR)-Beta*VR(RQ)-Pi);
%                 Qi= Q;
%             end
%         else
%             break
%         end
%         
%     end
%     Diff;
%     ExtraArr = [ExtraArr Qi];
%     PriceArr= [PriceArr X-b*Qi];
%     ProfitArr= [ProfitArr Qi*(X-b*Qi)];
%     R0= R0-Qi;
% 
% end


%New method to find Extraction path for a specific R0
R0= MaxR;
NExtraArr= zeros(myTime,1);
j= 1;
while (R0>0)&&(NQArr(Ri)>0)
    Ri= round(R0/RStepSize);
    NExtraArr(j)= NQArr(Ri);
    R0= R0-NQArr(Ri);
    j= j+1;
end

[[.1:RStepSize:MaxR]' NQArr(:) VR(:)]

PriceArr= zeros(myTime,1);
for i=1:(j-1)
    PriceArr(i)=X-b*NExtraArr(i);
end
ProfitArr= PriceArr.*NExtraArr;
figure(2)
plot(NExtraArr), hold on
plot(PriceArr)
axis([0 200 0 300])
title('Extraction(Q),Price(P) vs time')

figure(3)
%plot Profit over time
plot(ProfitArr)
title('Profit(Pi) vs time')