function varargout = run_hdr_disp_sim(varargin)
% RUN_HDR_DISP_SIM MATLAB code for run_hdr_disp_sim.fig
%      RUN_HDR_DISP_SIM, by itself, creates a new RUN_HDR_DISP_SIM or raises the existing
%      singleton*.
%
%      H = RUN_HDR_DISP_SIM returns the handle to a new RUN_HDR_DISP_SIM or the handle to
%      the existing singleton*.
%
%      RUN_HDR_DISP_SIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN_HDR_DISP_SIM.M with the given input arguments.
%
%      RUN_HDR_DISP_SIM('Property','Value',...) creates a new RUN_HDR_DISP_SIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_hdr_disp_sim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_hdr_disp_sim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run_hdr_disp_sim

% Last Modified by GUIDE v2.5 19-Dec-2011 11:16:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_hdr_disp_sim_OpeningFcn, ...
                   'gui_OutputFcn',  @run_hdr_disp_sim_OutputFcn, ...
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


% --- Executes just before run_hdr_disp_sim is made visible.
function run_hdr_disp_sim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run_hdr_disp_sim (see VARARGIN)

% Choose default command line output for run_hdr_disp_sim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run_hdr_disp_sim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = run_hdr_disp_sim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function uisim_DispTwoImages(str,handles)
switch str
    case 'Normal' % User selects Peaks.
        imshow(imread('imsplit5.jpg'), 'Parent', handles.axes1);
    case 'HDR' % User selects Membrane.
        imshow(imread('imsplit6.jpg'), 'Parent', handles.axes1);
    case 'Split' % User selects Sinc.
        run_jpeg_split_disp('imsplit5.jpg', 'imsplit6.jpg', handles.axes1);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
uisim_DispTwoImages(str{val},handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
