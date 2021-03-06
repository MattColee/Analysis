function [ output_args ] = Browse_TvP()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load('ProcOut.mat','FT');
segFT = FT;
load TvP_analysis.mat;
load NormTraces.mat;
load CorrTrace.mat;
load ROIavg.mat;
close all;





for i = 1:length(NeuronImage)
    ROIgroup(i)
    figure(1);set(gcf,'Position',[66         279        1686         699])
    subplot(4,3,1);imagesc(ROIavg{ROIidx(i)});axis equal;axis tight;
    hold on;
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
    for j = 1:length(NeuronImage)
        plot(outT{j}{1}(:,2),outT{j}{1}(:,1),'-g');
    end
    Xcent = round(Tcent(i,1));
    Ycent = round(Tcent(i,2));
    title(['Tenaspis Neuron #',int2str(i),' frames = ',int2str(nAFT(i))],'FontSize',8);
    
    minc = 0
    maxc = max(MeanT{i}(NeuronPixels{i}))
    Tmax = maxc;
    
    set(gca,'XLim',[Xcent-40 Xcent+40]);
    set(gca,'YLim',[Ycent-40 Ycent+40]);
    idx = ClosestT(i);
    caxis([minc maxc]);colorbar;hold off;
    %keyboard;
    
    subplot(4,3,2);imagesc(MeanI{idx});axis equal;axis tight;
    hold on;
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
    title(['PCAICA Neuron #',int2str(idx),' frames = ',int2str(nAFI(idx))],'FontSize',8);
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]);
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);
    minc = 0;
    maxc = max(MeanI{idx}(NeuronPixels{i}));
    set(gca,'XLim',[Xcent-40 Xcent+40]);
    set(gca,'YLim',[Ycent-40 Ycent+40]);
    caxis([minc maxc]);hold off;
    
    
    %caxis([0 0.1]);
    subplot(4,3,3);imagesc(MeanDiff{i});hold on;axis equal;axis tight;
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]);
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);
    
    title('Ten. - PCAICA','FontSize',8);hold off;
    
    s(1) = subplot(4,3,4:6);
    
    temp = ICtrace(idx,:);
    temp = convtrim(temp,ones(1,10)./10);
    plot(t,zscore(temp),'-k','DisplayName','IC trace','LineWidth',1);axis tight;hold on;
    plot(t,zscore(trace(ROIidx(i),:)),'-r','LineWidth',1.5,'DisplayName','Raw T.trace');hold on;
    gscore = max(trace(ROIidx(i),:))./std(trace(ROIidx(i),:));
    %set(gca,'YLim',[-3 15]);
    title(num2str(gscore));hold off;grid on;
    
    s(2) = subplot(4,3,7:9);
    
    
    plot(t,FT(i,:),'-r','LineWidth',5,'DisplayName','T. activity');hold on;
    plot(t,segFT(ROIidx(i),:),'-b','LineWidth',5,'DisplayName','T. seg activity');
    plot(t,ICFT(idx,:),'-k','LineWidth',3,'DisplayName','ICA activity');axis tight;hold off;grid on;
    
    s(3) = subplot(4,3,10:12);
    plot(t,convtrim(CorrTrace(ROIidx(i),:),ones(1,10)./10),'-r','LineWidth',2,'DisplayName','corr');axis tight;hold off;
    linkaxes(s,'x');hold off;grid on;
    pause;
    instr = 'y';
    while (~strcmp(instr,'n'))
        
        display('pick a time to see the frame')
        figure(1);hold off;
        [mx,my] = ginput(1);
        f = loadframe('SLPDF.h5',ceil(mx*20));
        figure(2);set(gcf,'Position',[1130         337         773         600]);
        imagesc(f);caxis([0 Tmax*1.1]);hold on;
        for j = 1:length(NeuronImage)
            plot(outT{j}{1}(:,2),outT{j}{1}(:,1),'-g');
        end
        plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
        plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');hold off;
        pause;
        instr = input('see another frame?','s');
    end
    
end

keyboard;

end

