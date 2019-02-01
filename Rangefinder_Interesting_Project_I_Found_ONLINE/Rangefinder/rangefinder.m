function varargout = rangefinder(varargin)
%-------------------------------------------------------------------------------------------------------------------
% Based on: https://sites.google.com/site/todddanko/home/webcam_laser_ranger
% Matlab version: Diego Barragán Guerrero
% www.matpic.com
%-------------------------------------------------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rangefinder_OpeningFcn, ...
                   'gui_OutputFcn',  @rangefinder_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- INITIAL CONDITIONS.
function rangefinder_OpeningFcn(hObject, eventdata, handles, varargin)
% Read background image
img_f=imread('Fondo.jpg');
image(img_f,'Parent',handles.axes2)
set(handles.axes2,'XTick',[],'YTick',[])
% Move GUI to the center of the screen
movegui(hObject,'center')
% Set the stop flag on 0
set(handles.parar_b,'UserData',0)
set(handles.axes1,'XTick',[],'YTick',[])
% Disconnect and delete image processing objects.
imaqreset
% END INITIAL CONDITIONS
% Choose default command line output for rangefinder
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = rangefinder_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- FUNCTION START PROGRAM.
function inicio_b_Callback(hObject, eventdata, handles)
% Disable the Start button
set(handles.inicio_b,'Enable','off')
% Put to 0 flag stop button
set(handles.parar_b,'UserData',0)
% Start video object
start(handles.vid);
% Image Size: 352 x 288
res=handles.vid.VideoResolution;
ancho=res(1);
alto    =res(2);
% Limits which seek the brightest pixel
lim_f1=ceil(alto/2);
lim_f2=ceil(alto-1);
lim_c1=ceil(ancho/2-25);
lim_c2=ceil(ancho/2+24);
limites=[lim_f1,lim_f2,lim_c1,lim_c2];
% Check format type
if strcmp(handles.vid.VideoFormat,'RGB24_320x240')
    convertir=0;
else
    convertir=1;
end
% Acquisition loop 
while true    
    % If the STOP button is pressed, WHILE loop stop.
    if get(handles.parar_b,'UserData')
        stop(handles.vid);
        break
    end
    imgn = getdata(handles.vid,1,'uint8');       
    if convertir==1, imgn=ycbcr2rgb(imgn); end
    axes(handles.axes1);
    image(imgn);
     axis off 
    [X, Y, distancia]=detect_fcn(imgn,limites);       
    set(handles.x_coord,'String',X)
    set(handles.y_coord,'String',Y)
    set(handles.distancia,'String',distancia)
end

guidata(hObject, handles);

% --- Executes on button press in parar_b.
function parar_b_Callback(hObject, eventdata, handles)
set(handles.parar_b,'UserData',1)
set(handles.inicio_b,'Enable','on')


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
try
    if(strcmp(handles.vid.running,'on'))
    set(handles.parar_b,'UserData',1)
else
    delete(hObject);
    end
catch
    delete(hObject);
end

% --- Executes on button press in camara_b.
function camara_b_Callback(hObject, eventdata, handles)
% Call  function: selection camera 
sel_camera
% Wait until the camera is selected
uiwait
% Activate the start button capture and processing
set(handles.inicio_b,'Enable','on')
set(handles.parar_b,'Enable','on')
% Global variable containing the ID of the camera
global id es_web_ext
% Routine for the start of video acquisition object
try
    if es_web_ext==1
        formato='RGB24_320x240';
    elseif es_web_ext==0
        formato='YUY2_320x240';
    else
        errordlg('The program does not support the camera','ERROR')
        return
    end
    handles.vid = videoinput('winvideo',id,formato);
    % For Laptop
    % handles.vid=videoinput('winvideo', id,'YUY2_352x288');
    % Infinite repetitions 
    set(handles.vid,'TriggerRepeat',Inf);
    % Frame capture interval of the video stream
    handles.vid.FrameGrabInterval = 3;    
catch
    % Message if there is no camera connected to the PC
    msgbox('No hay cámara conectada')
end
% Refresh "handles" structure of the GUI
guidata(hObject,handles)


