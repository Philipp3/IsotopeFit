function [bgcorrectionout, startind, endind] = bg_correction(peakdata,bgcorrectiondata)

% ############################## LAYOUT
%read out screen size
scrsz = get(0,'ScreenSize'); 

layoutlines=11;
layoutrows=5;

Parent = figure( ...
    'MenuBar', 'none', ...
    'ToolBar','figure',...
    'NumberTitle', 'off', ...
    'Name', 'Background correction',...
    'Position',[0.4*scrsz(3),0.4*scrsz(4),0.4*scrsz(3),0.4*scrsz(4)]); 

uicontrol(Parent,'Style','Text',...
    'Tag','TextStartMass',...
    'String','Start mass',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,11,11,1,1,0.01,0.03));

e_startmass=uicontrol(Parent,'Style','edit',...
    'Tag','edit_startmass',...
    'Units','normalized',...,...
    'String','0',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,11,11,2,2,0.05,0.025));

uicontrol(Parent,'Style','Text',...
    'Tag','TextEndMass',...
    'String','End Mass',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,11,11,4,4,0.01,0.03));

e_endmass=uicontrol(Parent,'Style','edit',...
    'Tag','edit_endmass',...
    'Units','normalized',...,...
    'String','End',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,11,11,5,5,0.05,0.025));

axis1 = axes('Parent',Parent,...
             'ActivePositionProperty','OuterPosition',...
             'Units','normalized',...
             'Position',gridpos(layoutlines,layoutrows,3,10,1,5,0.04,0.04)); 

         
e_ndiv=uicontrol(Parent,'Style','edit',...
    'Tag','edit_ndiv',...
    'String','10',...
    'Units','normalized',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,1,1,1,1,0.05,0.025));

uicontrol(Parent,'Style','Text',...
    'Tag','Text1',...
    'String','Number of divisions',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,2,2,1,1,0.01,0.03));

e_percent=uicontrol(Parent,'Style','edit',...
    'Tag','edit_npoints',...
    'String','10',...
    'Units','normalized',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,1,1,2,2,0.05,0.025));

uicontrol(Parent,'Style','Text',...
    'Tag','Text2',...
    'String','Evaluation points (%)',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,2,2,2,2,0.01,0.03));

% e_polydegree=uicontrol(Parent,'Style','edit',...
%     'Tag','edit_polydegree',...
%     'Units','normalized',...,...
%     'String','2',...
%     'Background','white',...
%     'Position',gridpos(layoutlines,layoutrows,1,1,3,3,0.05,0.025),...
%     'Callback',@edit1_callback);
% 
% uicontrol(Parent,'Style','Text',...
%     'Tag','Text3',...
%     'String','Polynom degree',...
%     'Units','normalized',...
%     'Position',gridpos(layoutlines,layoutrows,2,2,3,3,0.01,0.03));
         
uicontrol(Parent,'style','pushbutton',...
          'string','Show',...
          'Callback',@show,...
          'Units','normalized',...
          'Position',gridpos(layoutlines,layoutrows,1,2,4,4,0.05,0.05)); 

uicontrol(Parent,'style','pushbutton',...
          'string','OK',...
          'Callback','uiresume(gcbf)',...
          'Units','normalized',...
          'Position',gridpos(layoutlines,layoutrows,1,2,5,5,0.05,0.05)); 

%Update(Parent);


% ############################## END OF LAYOUT


%A=load(file);
handles=guidata(Parent);

handles.massaxis = peakdata(:,1)';
handles.signal = peakdata(:,2)'; 
handles.bgdata = zeros(1,size(peakdata,1));

handles.bgcorrectiondata=bgcorrectiondata;

handles.startup = 1;

set(e_startmass,'String',num2str(bgcorrectiondata.startmass));
set(e_endmass,'String',num2str(bgcorrectiondata.endmass));
set(e_ndiv,'String',num2str(bgcorrectiondata.ndiv));
%set(e_polydegree,'String',num2str(bgcorrectiondata.polydegree));
set(e_percent,'String',num2str(bgcorrectiondata.percent));


% Abspeichern der Struktur 
guidata(Parent,handles); 

show(Parent,0);

    function show(hObject,eventdata)
        handles=guidata(hObject);
        handles.bgcorrectiondata.ndiv=str2num(get(e_ndiv,'String'));
        handles.bgcorrectiondata.percent=str2num(get(e_percent,'String'));
        %handles.bgcorrectiondata.polydegree=str2num(get(e_polydegree,'String'));
        
        % retrieve current view settings from axes:
        if (handles.startup == 0) % only if we're not starting up any more...
            xlim = get(axis1, 'XLim');
            ylim = get(axis1, 'YLim');
        end
        
        temp=get(e_startmass,'String');
        if strcmp(temp,'start')
            handles.bgcorrectiondata.startmass=-inf;
        else
            handles.bgcorrectiondata.startmass=str2double(temp);
        end
        
        temp=get(e_endmass,'String');
        if strcmp(temp,'end')
            handles.bgcorrectiondata.endmass=+inf;
        else
            handles.bgcorrectiondata.endmass=str2double(temp);
        end
               
        [handles.bgcorrectiondata.bgm,handles.bgcorrectiondata.bgy, handles.startind, handles.endind]=...
            find_bg(handles.massaxis,handles.signal,...
                handles.bgcorrectiondata.ndiv,...
                handles.bgcorrectiondata.percent,...
                handles.bgcorrectiondata.startmass,...
                handles.bgcorrectiondata.endmass);
        
        handles.massaxiscrop=handles.massaxis(handles.startind:handles.endind);
        handles.signalcrop=handles.signal(handles.startind:handles.endind);
        
        
        plot(axis1,handles.massaxiscrop,handles.signalcrop,handles.massaxiscrop,interp1(handles.bgcorrectiondata.bgm,handles.bgcorrectiondata.bgy,handles.massaxiscrop,'pchip','extrap'));
        
        % reset zoom state to what it was before:
        if (handles.startup == 0)
            set(axis1, 'XLim', xlim)
            set(axis1, 'YLim', ylim)
        end
        
        % now we plotted something and it's definitely not startup conditions
        % any more
        handles.startup = 0;
        
        guidata(hObject,handles);
        
    end

uiwait(Parent)

%update:
show(Parent,0);

handles=guidata(Parent);

bgcorrectionout=handles.bgcorrectiondata;
startind=handles.startind;
endind=handles.endind;

close(Parent);
drawnow;

  
end
