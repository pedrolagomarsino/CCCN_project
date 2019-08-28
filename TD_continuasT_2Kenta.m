%TD_continuasT
%Inspired from Rao etal. 2010
clear all

%Initialize
LR=0.05;
R_1=30;
R_2=30;
R_neg=-1;
R_Pan=-300;

nTrial=5000;

Qtab=zeros(2,3); %table to be updated

    numT = 100; % for Stim period
    UncertTable= [.55 .6 .7 .8 .9]; %bad naming...actually Certainty!

for kk=1:nTrial
    Bel=[0.5 0.5]; % Initial Belief 1:L/2:R
    Bel_All=zeros(2,numT+1);
    Bel_All(:,1)=Bel;
    
    %VStim_set
    temp=randperm(5);
    Uncert=UncertTable(temp(1));
    
    temp=randperm(2)-1;  
    CorAns=temp(1); % CorrectAnswer:0=L/1=R
    Obs=zeros(numT,1); temp=rand(numT,1);
    Obs(temp<=Uncert)=CorAns;
    Obs(temp>Uncert)=1-CorAns;

%Stim Presentation
for ii=1:numT
    
    Bel0=Bel; %to be used later
    
    if Obs(ii)==0        
        temp2=Bel(1)*Uncert/(Bel(1)*Uncert+Bel(2)*(1-Uncert));
        Bel = [temp2 (1-temp2)];        
    else 
        temp2=Bel(2)*Uncert/(Bel(2)*Uncert+Bel(1)*(1-Uncert));
        Bel = [(1-temp2) temp2];        
    end
    
    QL=Bel*Qtab(:,1);
    QR=Bel*Qtab(:,2);
    QW=Bel*Qtab(:,3);
    
    Bel_All(:,ii+1)=Bel;
    
    QL_All(ii)=QL;
    QR_All(ii)=QR;
    QW_All(ii)=QW;
    
    %action
    if rem(kk,20)== 0
    temp=randperm(2); % random choice in 5% trial 
    action=temp(1);
    else        
    
    if QW>=max([QL QR])
        action=3; %waiting
    else
        if QR>QL
            action=2;  %action R
        elseif QR<QL
            action=1; %action L
        else
            temp=randperm(2);
            action=temp(1);
        end
    end
    end
    
    %reward
    switch action
        case 1
            if CorAns==0
                Rew=R_1;
            else
                Rew=R_Pan;
            end                                
        case 2
            if CorAns==1
                Rew=R_2;
            else
                Rew=R_Pan;
            end               
        case 3
            Rew=R_neg;
    end    
    
    % Q update
    switch action
        case 1 %L
            D_fb=Rew - Bel*Qtab(:,action);  %Bel0:old posterior        
            Qtab(:,1)=Qtab(:,1)'+LR*D_fb'*Bel;
        case 2 %R
            D_fb=Rew - Bel*Qtab(:,action);        
            Qtab(:,2)=Qtab(:,2)'+LR*D_fb'*Bel;
        case 3 %wait
    % TD 
    MaxTemp=max([Bel*Qtab(:,1) Bel*Qtab(:,2) Bel*Qtab(:,3)]);
    D_fb=Rew + MaxTemp - Bel0*Qtab(:,action);  %Bel0:old posterior
    Qtab(:,3)=Qtab(:,3)'+LR*D_fb'*Bel;
    end
    
    action_All(ii)=action;
    Rew_All(ii)=Rew;
    Qtab_All(:,:,ii)=Qtab;
    D_fb_All(ii)=D_fb;
    
    if action <= 2
        break
    end

end

actionAALL{kk}=action_All; 
BelAALL{kk}=Bel_All; 
RewAALL{kk}=Rew_All; 
actionAALL{kk}=action_All; 
QtabAAll{kk}=Qtab_All;
UncertAll(kk)=Uncert;
CorAnsAll(kk)=CorAns;
D_fbAAll{kk}=D_fb_All;

QLAALL{kk}=QL_All;
QRAALL{kk}=QR_All;
QWAALL{kk}=QW_All;

clear action_All Bel_All Rew_All action_All Qtab_All D_fb_All

end

%% Analysis
%hogehoge
for kk=1:nTrial
    actionCellTemp=actionAALL{kk};
    LastAction(kk)=actionCellTemp(end);
    WaitTime(kk)=length(find(actionCellTemp==3)); 
    clear actionCellTemp
end

trial_1=find(UncertAll==.9);
trial_2=find(UncertAll==.8);
trial_3=find(UncertAll==.7);
trial_4=find(UncertAll==.6);
trial_5=find(UncertAll==.55);

trial_L=find(CorAnsAll==0); %L Correct Answer
trial_R=find(CorAnsAll==1); %R

trial_1L=intersect(trial_1,trial_L);
trial_2L=intersect(trial_2,trial_L);
trial_3L=intersect(trial_3,trial_L);
trial_4L=intersect(trial_4,trial_L);
trial_5L=intersect(trial_5,trial_L);

trial_1R=intersect(trial_1,trial_R);
trial_2R=intersect(trial_2,trial_R);
trial_3R=intersect(trial_3,trial_R);
trial_4R=intersect(trial_4,trial_R);
trial_5R=intersect(trial_5,trial_R);

trial_actionL=find(LastAction==1); %action based
trial_actionR=find(LastAction==2);

%Psycometric Func
point1=length(intersect(trial_1R,trial_actionR))/length(trial_1R);
point2=length(intersect(trial_2R,trial_actionR))/length(trial_2R);
point3=length(intersect(trial_3R,trial_actionR))/length(trial_3R);
point4=length(intersect(trial_4R,trial_actionR))/length(trial_4R);
point5=length(intersect(trial_5R,trial_actionR))/length(trial_5R);
point6=length(intersect(trial_5L,trial_actionR))/length(trial_5L);
point7=length(intersect(trial_4L,trial_actionR))/length(trial_4L);
point8=length(intersect(trial_3L,trial_actionR))/length(trial_3L);
point9=length(intersect(trial_2L,trial_actionR))/length(trial_2L);
point10=length(intersect(trial_1L,trial_actionR))/length(trial_1L);

figure,
plot([10:-1:1],[point1 point2 point3 point4 point5 point6 point7 point8 point9 point10])
