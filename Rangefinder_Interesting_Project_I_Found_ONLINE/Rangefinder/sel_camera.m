function varargout = sel_camera(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sel_camera_OpeningFcn, ...
                   'gui_OutputFcn',  @sel_camera_OutputFcn, ...
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

% --- Executes just before sel_camera is made visible.
function sel_camera_OpeningFcn(hObject, eventdata, handles, varargin)
imaqreset;
set(handles.ok_b,'Enable','off')
hw=imaqhwinfo('winvideo');
handles.cam=hw;
set(handles.lista_camaras,'String',{hw.DeviceInfo.DeviceName})
% Choose default command line output for sel_camera
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = sel_camera_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in lista_camaras.
function lista_camaras_Callback(hObject, eventdata, handles)
pos=get(handles.lista_camaras,'Value');
hw=handles.cam;
id=hw.DeviceIDs{pos};
set(handles.id_camara,'String',id)
formatos=hw.DeviceInfo(pos).SupportedFormats;
set(handles.formatos,'String',formatos)
list_f = [formatos{1:end}];
si=findstr(list_f,'RGB24_320x240');
if isempty(si)
    % msgbox('NO existe')
    es_web_ext=0;
    % Laptop webcam: YUY2
else
    % msgbox('Ok')
    es_web_ext=1;
    % External webcam: RGB
end
handles.es_web_ext=es_web_ext;
handles.id=id;
guidata(hObject, handles)
set(handles.ok_b,'Enable','on')
% --- --- ---  ---  ---  ---.
function ok_b_Callback(hObject, eventdata, handles)
global id es_web_ext
es_web_ext = handles.es_web_ext;
id = handles.id;
close (handles.camara)

