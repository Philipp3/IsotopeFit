function out = bg_correction(file)

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
    'Position',gridpos(layoutlines,layoutrows,11,1,0.01,0.03));

e_startmass=uicontrol(Parent,'Style','edit',...
    'Tag','edit_startmass',...
    'Units','normalized',...,...
    'String','0',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,11,2,0.05,0.025));

uicontrol(Parent,'Style','Text',...
    'Tag','TextEndMass',...
    'String','End Mass',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,11,4,0.01,0.03));

e_endmass=uicontrol(Parent,'Style','edit',...
    'Tag','edit_endmass',...
    'Units','normalized',...,...
    'String','End',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,11,5,0.05,0.025));

axis1 = axes('Parent',Parent,...
             'ActivePositionProperty','OuterPosition',...
             'ButtonDownFcn','disp(''axis callback'')',...
             'Units','normalized',...
             'Position',gridpos(layoutlines,layoutrows,3:10,1:5,0.04,0.04)); 

         
e_ndiv=uicontrol(Parent,'Style','edit',...
    'Tag','edit_ndiv',...
    'String','10',...
    'Units','normalized',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,1,1,0.05,0.025),...
    'Callback',@edit1_callback);

uicontrol(Parent,'Style','Text',...
    'Tag','Text1',...
    'String','Number of divisions',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,2,1,0.01,0.03));

e_npoints=uicontrol(Parent,'Style','edit',...
    'Tag','edit_npoints',...
    'String','10',...
    'Units','normalized',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,1,2,0.05,0.025),...
    'Callback',@edit1_callback);

uicontrol(Parent,'Style','Text',...
    'Tag','Text2',...
    'String','Evaluation points (%)',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,2,2,0.01,0.03));

e_polydegree=uicontrol(Parent,'Style','edit',...
    'Tag','edit_polydegree',...
    'Units','normalized',...,...
    'String','2',...
    'Background','white',...
    'Position',gridpos(layoutlines,layoutrows,1,3,0.05,0.025),...
    'Callback',@edit1_callback);

uicontrol(Parent,'Style','Text',...
    'Tag','Text3',...
    'String','Polynom degree',...
    'Units','normalized',...
    'Position',gridpos(layoutlines,layoutrows,2,3,0.01,0.03));
         
uicontrol(Parent,'style','pushbutton',...
          'string','Show',...
          'Callback',@show,...
          'Units','normalized',...
          'Position',gridpos(layoutlines,layoutrows,1:2,4,0.05,0.05)); 

uicontrol(Parent,'style','pushbutton',...
          'string','OK',...
          'Callback','uiresume(gcbf)',...
          'Units','normalized',...
          'Position',gridpos(layoutlines,layoutrows,1:2,5,0.05,0.05)); 

 

%Update(Parent);


% ############################## END OF LAYOUT


A=load(file);
handles.massaxis = A(:,1)';
handles.signal = A(:,2)'; 
handles.bgdata = zeros(1,size(A,1));

% Abspeichern der Struktur 
guidata(Parent,handles); 


    function show(hObject,eventdata)
        handles=guidata(hObject);
        ndivisions=str2num(get(e_ndiv,'String'));
        npoints=str2num(get(e_npoints,'String'));
        polydeg=str2num(get(e_polydegree,'String'));
        
        temp=get(e_startmass,'String');
        if strcmp(temp,'start')
            startmass=-inf;
        else
            startmass=str2num(temp);
        end
        
        temp=get(e_endmass,'String');
        if strcmp(temp,'end')
            endmass=+inf;
        else
            endmass=str2num(temp);
        end
               
        
        [handles.massaxis, handles.signal, handles.bgdata]=find_bg(handles.massaxis,handles.signal,ndivisions,npoints,polydeg,startmass,endmass);
        plot(axis1,handles.massaxis,handles.signal,handles.massaxis,handles.bgdata);
        
        guidata(hObject,handles);
    end



uiwait(Parent)
%out = get(e,'String');
handles=guidata(Parent);
out=handles.bgdata;
close(Parent)

  
end
