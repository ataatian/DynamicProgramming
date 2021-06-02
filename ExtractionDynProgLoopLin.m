%%Resource Extraction Problem

clear
clc

close all
r= .05;
Beta= 1/(1+r);
RStepSize= 0.1;
QStepSize= RStepSize;
X= 100;
b= 5;
MaxQ= X/b;
MaxR= 20;
myTime= 100;

%%initialization
Q_i= X/(2*b);
Pi_i= Q_i*(X-b*Q_i);
for Ri= 1:round((MaxR/RStepSize))
    t_i= RStepSize*(Ri)/Q_i;
    VR_init(Ri)= Pi_i/r*(1-exp(-r*t_i));
end

QArr= Q_i*ones(round((MaxR/RStepSize)),1);

VR_init(1) =RStepSize*(X-b*RStepSize);

figure(1)
%%Plot initial Value function versus R0
plot([RStepSize:RStepSize:MaxR],VR_init), hold on

[VR,myEr,NQArr]= myExtractionLoopLin(VR_init,MaxR,MaxQ,RStepSize,X,b,Beta,QArr);

%%Plot optimized Value function versus R0
plot([RStepSize:RStepSize:MaxR],VR)
title('V(R) vs R - Initial guess:blue & final answer:red')
IterationN= size(myEr,2);
LastErr= myEr(IterationN);


%%find Extraction path for a specific R0
RR0= MaxR;
R0= RR0;
NExtraArr= [];
while (R0>0)&&(NQArr(Ri)>0)
    Ri= round(R0/RStepSize);
    NExtraArr= [NExtraArr NQArr(Ri)];
    R0= R0-NQArr(Ri);
end

TheRes= [[RStepSize:RStepSize:MaxR]' NQArr(:) VR(:)];

PriceArr=X-b*NExtraArr;
ProfitArr= PriceArr.*NExtraArr;
figure(2)
plot(NExtraArr), hold on
plot(PriceArr)
axis([0 myTime 0 150])
title(['Extraction(Q):blue,Price(P):red vs time  R0=',num2str(RR0)])

figure(3)
%%plot Profit over time
plot(ProfitArr)
axis([0 myTime 0 1000])
title('Profit(Pi) vs time')