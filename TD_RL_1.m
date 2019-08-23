% TD-RL
clear all
close all
%pram set
trialN=10000;
LR=0.05;
R_Big=1;
R_Small=1;
R_Neg=0;

Coh = [-50 -40 -30 -20 -10 10 20 30 40 50]; %StimSet L->R
Ns=length(Coh);

Sigma=130; %change this and check the Psycometric Function
Q=zeros(Ns,2); %table to be updated

%% Learning
for ii=1:trialN
Sample = round(rand(1)*9);
switch Sample
    case 0
        Sm=-50;
    case 1
        Sm=-40;
    case 2
        Sm=-30;
    case 3
        Sm=-20;
    case 4
        Sm=-10;
    case 5  
        Sm=10;
    case 6
        Sm=20;
    case 7
        Sm=30;
    case 8
        Sm=40;
    case 9
        Sm=50;
end

Bel = normpdf(Sm,Coh,Sigma);
Bel = Bel./sum(Bel);

QL=Bel*Q(:,1);
QR=Bel*Q(:,2);

if rem(ii,10)== 0
    action=round(rand(1))+1; % random choice in 10% trial 
else
    
if QL>QR
    action=1; %choice L
else
    action=2; %choice R
end

end
Vfc=(QL+QR)/2;
D_M=Bel*Q(:,action)-Vfc;

if Sm < 0 %when corect=Left
    if action == 1 %L
        Rew=R_Big;
    else %R
        Rew=R_Neg; 
    end
    
else %correct=R
    if action == 1 %L
        Rew=R_Neg;
    else %R
        Rew=R_Small; 
    end
end

D_fb=Rew-Bel*Q(:,action);

% Q update
if action == 1 %L
    Q(:,1)=Q(:,1)'+LR*D_fb'*Bel;
else %R
    Q(:,2)=Q(:,2)'+LR*D_fb'*Bel;
end

% Saving
Qall(:,:,ii)=Q;
D_Mall(:,:,ii)=D_M;
D_fball(:,:,ii)=D_fb;
Vfcall(ii)=Vfc;

Sampleall(ii)=Sample;
Sm_all(ii)=Sm;
action_all(ii)=action;
Bel_all(:,:,ii)=Bel;
Rewall(ii)=Rew;
QLall(ii)=QL;
QRall(ii)=QR;
ii;
end
%% checking
figure,
subplot(1,2,1),plot(squeeze(D_Mall)),title('Delta Stim')
subplot(1,2,2),plot(squeeze(D_fball)),title('Delta Feedback')

% Tracking Q table
figure,
subplot(6,2,1),plot(squeeze(Qall(1,1,:))),%ylim([0 1]),title('L')
subplot(6,2,3),plot(squeeze(Qall(2,1,:))),%ylim([0 1])
subplot(6,2,5),plot(squeeze(Qall(3,1,:))),%ylim([0 1])
subplot(6,2,7),plot(squeeze(Qall(4,1,:))),%ylim([0 1])
subplot(6,2,9),plot(squeeze(Qall(5,1,:))),%ylim([0 1])
subplot(6,2,11),plot(squeeze(Qall(6,1,:))),%ylim([0 1])

subplot(6,2,2),plot(squeeze(Qall(1,2,:))),%ylim([0 1]),title('R')
subplot(6,2,4),plot(squeeze(Qall(2,2,:))),%ylim([0 1])
subplot(6,2,6),plot(squeeze(Qall(3,2,:))),%lim([0 1])
subplot(6,2,8),plot(squeeze(Qall(4,2,:))),%ylim([0 1])
subplot(6,2,10),plot(squeeze(Qall(5,2,:))),%ylim([0 1])
subplot(6,2,12),plot(squeeze(Qall(6,2,:))),%ylim([0 1])

%% Analysis (last 500trials)
period=trialN-500+1:trialN;
Sm_Al=Sm_all(period);
D_MAl=D_Mall(period);
D_fbAl=D_fball(period);
RewAl=Rewall(period);
actionAl=action_all(period);

%psycometric function
temp=actionAl(Sm_Al==-50);val1=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==-40);val2=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==-30);val3=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==-20);val4=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==-10);val5=length(find(temp==2))/length(temp);

temp=actionAl(Sm_Al==10);val6=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==20);val7=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==30);val8=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==40);val9=length(find(temp==2))/length(temp);
temp=actionAl(Sm_Al==50);val10=length(find(temp==2))/length(temp);
figure,
subplot(1,3,1),plot([-50 -40 -30 -20 -10 10 20 30 40 50],[val1 val2 val3 val4 val5 val6 val7 val8 val9 val10]),
title('Psycometric Function')
%
Trials10=union(find(Sm_Al==-10),find(Sm_Al==10));
Trials20=union(find(Sm_Al==-20),find(Sm_Al==20));
Trials30=union(find(Sm_Al==-30),find(Sm_Al==30));
Trials40=union(find(Sm_Al==-40),find(Sm_Al==40));
Trials50=union(find(Sm_Al==-50),find(Sm_Al==50));

Trials10_Corr=intersect(find(RewAl>0),Trials10);
Trials10_Erro=intersect(find(RewAl<=0),Trials10);
Trials20_Corr=intersect(find(RewAl>0),Trials20);
Trials20_Erro=intersect(find(RewAl<=0),Trials20);
Trials30_Corr=intersect(find(RewAl>0),Trials30);
Trials30_Erro=intersect(find(RewAl<=0),Trials30);
Trials40_Corr=intersect(find(RewAl>0),Trials40);
Trials40_Erro=intersect(find(RewAl<=0),Trials40);
Trials50_Corr=intersect(find(RewAl>0),Trials50);
Trials50_Erro=intersect(find(RewAl<=0),Trials50);

subplot(1,3,2),
plot([10 20 30 40 50],[mean(D_MAl(Trials10_Corr)) mean(D_MAl(Trials20_Corr)) mean(D_MAl(Trials30_Corr)) mean(D_MAl(Trials40_Corr)) mean(D_MAl(Trials50_Corr))],'g'),hold on
plot([10 20 30 40 50],[mean(D_MAl(Trials10_Erro)) mean(D_MAl(Trials20_Erro)) mean(D_MAl(Trials30_Erro)) mean(D_MAl(Trials40_Erro)) mean(D_MAl(Trials50_Erro))],'r'),hold on
title('Stim-DPE')
subplot(1,3,3),
plot([10 20 30 40 50],[mean(D_fbAl(Trials10_Corr)) mean(D_fbAl(Trials20_Corr)) mean(D_fbAl(Trials30_Corr)) mean(D_fbAl(Trials40_Corr)) mean(D_fbAl(Trials50_Corr))],'g'),hold on
plot([10 20 30 40 50],[mean(D_fbAl(Trials10_Erro)) mean(D_fbAl(Trials20_Erro)) mean(D_fbAl(Trials30_Erro)) mean(D_fbAl(Trials40_Erro)) mean(D_fbAl(Trials50_Erro))],'r'),hold on
title('Feedback-DPE')

%%
[AA,BB]=sort(D_MAl);
Bottom25=BB(1:125);
Top25=BB(end-125:end);

temp1=length(intersect(Trials10_Corr,Top25))/length(intersect(Trials10,Top25));
temp2=length(intersect(Trials20_Corr,Top25))/length(intersect(Trials20,Top25));
temp3=length(intersect(Trials30_Corr,Top25))/length(intersect(Trials30,Top25));
temp4=length(intersect(Trials40_Corr,Top25))/length(intersect(Trials40,Top25));
temp5=length(intersect(Trials50_Corr,Top25))/length(intersect(Trials50,Top25));

temp6=length(intersect(Trials10_Corr,Bottom25))/length(intersect(Trials10,Bottom25));
temp7=length(intersect(Trials20_Corr,Bottom25))/length(intersect(Trials20,Bottom25));
temp8=length(intersect(Trials30_Corr,Bottom25))/length(intersect(Trials30,Bottom25));
temp9=length(intersect(Trials40_Corr,Bottom25))/length(intersect(Trials40,Bottom25));
temp10=length(intersect(Trials50_Corr,Bottom25))/length(intersect(Trials50,Bottom25));

%%
%psycometric function add

%figure,
%plot([10 20 30 40 50],[temp1 temp2 temp3 temp4 temp5],'b'),hold on
%lot([10 20 30 40 50],[temp10 temp9 temp8 temp7 temp6],'r'),hold on
%title('Accuracy')








