function [state,options] = psoplotbestf(options,state,flag)
% Plots the best, mean, and worst scores of particle swarm.

notinf = isfinite(state.Score) ;
NewFlag = getappdata(gcf,'flag');
if strcmp(NewFlag,'done');
    flag = 'done';
end

if strcmp(flag,'init')
    set(gca,'NextPlot','add',...
        'XLabel',xlabel('Generation'),...
        'YLabel',ylabel('Score'))
    %     line(state.Generation,max(state.Score),...
    %         'Color','red',...
    %         'Tag','Worst Scores',...
    %         'Marker','.',...
    %         'LineStyle','none')
    line(state.Generation,mean(state.Score(notinf)),...
        'Color','blue',...
        'Tag','Mean Scores',...
        'Marker','.',...
        'LineStyle','none')
    line(state.Generation,min(state.Score),...
        'Color','black',...
        'Tag','Best Scores',...
        'Marker','.',...
        'LineStyle','none')
    set(gcf,'ToolBar','none')
    uicontrol(gcf,'Style', 'pushbutton',...
           'String', 'Stop',...
           'Position', [20 340 100 50],...
           'Callback', @stopOptimize);  
%     ht = uitoolbar(gcf);
%     icon = fullfile(matlabroot,'/toolbox/matlab/icons/greencircleicon.gif');
%     [cdata,map] = imread(icon);
%     map(find(map(:,1)+map(:,2)+map(:,3)==3)) = NaN;
%     map(4,1:3) = [.8,0,0];
%     keyboard
%     cdataStop = ind2rgb(cdata,map);
%     hStop = uipushtool(ht,'cdata',cdataStop,'tooltip','Stop Optimization After This Generation','ClickedCallback','stopOptimization()');
%     
elseif strcmp(flag,'done')
    legend({'Mean Score','Best Score'})
    set(gcf,'ToolBar','figure');
%     hToolbar = findall(gcf,'tag','FigureToolBar');
%     %hToolbar = get(hUndo,'Parent');  % an alternative
%     hButtons = findall(hToolbar);
%     set(hToolbar,'children',hButtons(1:end));

else
    
    %     hworst = findobj(gca,'Tag','Worst Scores','Type','line') ;
    hmean = findobj(gca,'Tag','Mean Scores','Type','line') ;
    hbest = findobj(gca,'Tag','Best Scores','Type','line') ;
    x = [get(hmean,'XData'), state.Generation] ;
    %     yworst = [get(hworst,'YData'), max(state.Score)] ;
    ymean = [get(hmean,'YData'), mean(state.Score(notinf))] ;
    ybest = [get(hbest,'YData'), min(state.Score)] ;
    %     set(hworst,...
    %         'XData',x,...
    %         'YData',yworst)
    set(hmean,...
        'XData',x,...
        'YData',ymean)
    set(hbest,...
        'XData',x,...
        'YData',ybest)
    titletxt = sprintf('Best: %g Mean: %g',ybest(end),ymean(end)) ;
    title(titletxt)
    
end