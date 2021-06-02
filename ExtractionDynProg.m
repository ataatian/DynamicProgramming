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
MaxR= 100;


%initialization
Q_i= X/(2*b);
Pi_i= Q_i*(X-b*Q_i);
for R= 1:floor((MaxR/RStepSize))
    t_i= RStepSize*(R)/Q_i;
    VR_init(R)= Pi_i/Beta*(1-exp(-Beta*t_i));
%     M(floor(R/RStepSize)+1)=1;
end

MM= [];
for R= 1:floor((MaxR/RStepSize))
    MM= [MM X*X/(4*b*Beta)*(1-exp(-2*b/X*Beta*R*RStepSize))];
end
figure(1)
%Plot Value function versus R0
% plot(X*X/(4*b*Beta)*(1-exp(-2*b/X*(1:floor(MaxR/RStepSize))))), hold on
plot(VR_init), hold on
[VR,myEr]= myExtraction(VR_init,MaxR,MaxQ,RStepSize,X,b);
% figure(1)
%Plot Value function versus R0
plot(VR)
title('V(R) vs R - Initial guess & final answer')

R0= MaxR;
ExtraArr= [];
ProfitArr= [];
PriceArr= [];
while R0>0 
    Diff= .1;
    for Q= 0:QStepSize:MaxQ
        Pi= Q*(X-b*Q);
        RR= floor(R0/RStepSize);
        RQ= floor((R0-Q)/RStepSize);
        if (RR>0)&&(RQ>0)
            if (VR(RR)-Beta*VR(RQ)-Pi)<Diff
                Diff= (VR(RR)-Beta*VR(RQ)-Pi);
                Qi= Q;
            end
        else
            break
        end
        
    end
    Diff;
    ExtraArr = [ExtraArr Qi];
    PriceArr= [PriceArr X-b*Qi];
    ProfitArr= [ProfitArr Qi*(X-b*Qi)];
    R0= R0-Qi;

end

figure(2)
%plot Extraction over time
plot(ExtraArr), hold on
plot(PriceArr)
title('Extraction(Q),Price(P) vs time')

figure(3)
%plot Profit over time
plot(ProfitArr)
title('Profit(Pi) vs time')