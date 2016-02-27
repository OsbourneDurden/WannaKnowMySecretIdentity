function varargout = gui_camera(varargin)
% GUI_CAMERA MATLAB code for gui_camera.fig
%      GUI_CAMERA, by itself, creates a new GUI_CAMERA or raises the existing
%      singleton*.
%
%      H = GUI_CAMERA returns the handle to a new GUI_CAMERA or the handle to
%      the existing singleton*.
%
%      GUI_CAMERA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CAMERA.M with the given input arguments.
%
%      GUI_CAMERA('Property','Value',...) creates a new GUI_CAMERA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_camera_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_camera_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_camera

% Last Modified by GUIDE v2.5 31-Jan-2016 16:04:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_camera_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_camera_OutputFcn, ...
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


% --- Executes just before gui_camera is made visible.
function gui_camera_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_camera (see VARARGIN)

% Choose default command line output for gui_camera
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cam=webcam(1);
cam.Resolution=cam.AvailableResolutions{end};
str_res=cam.Resolution;
str_res(strfind(str_res,'x'))=' ';
dim_res=str2num(str_res);
clear cam;
axis ij;
axis([0 dim_res(1) 0 dim_res(2)]);
hold on;


% UIWAIT makes gui_camera wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_camera_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

if get(hObject,'Value')
    cam = webcam(1);
    cam.Resolution = cam.AvailableResolutions{end};
    time = 0;
    nb_frames = 0;
    while get(hObject,'Value')
        tic;
        img = snapshot(cam);
        filename = ['img_genere/img', num2str(nb_frames+1), '.jpg'];
        imwrite(img, filename, 'jpg');
        image(img);
        time = time + toc;
        nb_frames = nb_frames + 1;
    end
    clear cam;
end
