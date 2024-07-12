function morse_tab(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',         mfilename,  ...
                   'gui_Singleton',    gui_Singleton, ...
                   'gui_OpeningFcn',   @morse_GUI_OpeningFcn, ...
                   'gui_OutputFcn',    @morse_GUI_OutputFcn, ...
                   'gui_LayoutFcn',    [] , ...
                   'gui_Callback',     []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function morse_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hOject, handles);

function varargout = morse_GUI_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

set(handles.play_morse,'visible','off');
set(handles.save_morse,'visible','off');

global morse_code;
function in_msg_Callback(hObject, eventdata, handles)

function in_msg_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hOject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor','White');
end

function out_msg_Callback(hObject, eventdata, handles)

function out_msg_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hOject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor','White');
end

function encode_Callback(hObject, eventdata, handles)

global morse_code;
set(handles.play_morse,'visible','on');
set(handles.save_morse,'visible','on','Enable','off');
texto=get(handles.in_msg,'String');
load data.mat
text=lower(texto);

len=length(text);
mor=[];
for i=1:len
    if text(i)==' '
        mor=[mor '/'];
    elseif isvarname(text(i))    
        mor=[mor getfield(morse,text(i))];
        mor=[mor ' '];
    elseif ~isempty(str2num(text(i)))    
        mor=[mor getfield(morse,['n' text(i)])];
        mor=[mor ' '];
    elseif findstr(text(i),morse.sc)    
        mor=[mor char(morse.scv(findstr(text(i),morse.sc)))];
        mor=[mor ' '];
    end
end
set(handles.out_msg,'String',mor);
morse_code = mor;

function decode_Callback(hObject, eventdata, handles)

global morse_code;
set(handles.play_morse,'visible','on');
set(handles.save_morse,'visible','on','Enable','off');
load data.mat
code=get(handles.in_msg,'String');
morse_code=code;
deco=[];
code=[code ' '];
lcode=[];
for j=1:length(code)

    if strcmp(code(j),' ')||strcmp(code(j),'/')
        for i=double('a'):double('z')
            letter=getfield(morse,char(i));
            if strcmp(lcode,letter)
                deco = [deco char(i)];
            end
        end
        for i=0:9
            numb = getfield(morse,['n',num2str(i)]);
            if strcmp(lcode,numb)
                deco = [deco ,num2str(i)];
            end
        end
        for i=1:4
            scv = char(morse.scv(i));
            if strcmp(lcode,scv)
                deco = [deco, morse.sc(i)];
            end
        end
        lcode = [];
    else
        lcode=[lcode code(j)];
    end
    if strcmp(code(j),'/')
        deco = [deco ' '];
    end

end
set(handles.out_msg,'String',deco);

function play_morse_Callback(hObject, eventdata, handles)

global morse_code;
global msou;
set(handles.save_morse,'Enable','on');
t=0:5000;
Dot = sin(t(1:700));
Dash = sin(t(1:2000));
ssp = sin(t(1:2000));
lsp = sin(t(1:4000));
msou=[];
clear sound;
text=morse_code;
for i=1:length(text)
    if strcmp(text(i),'.')
        msou= [msou Dot ssp];
        elseif strcmp(text(i),'-')
        msou = [msou Dash ssp];
    elseif strcmp(text(i),' ')
        msou = [msou lsp];
    elseif strcmp(text(i),'/')
        msou = [msou lsp ssp];  
    end
end    

pp = audioplayer(msou,11000);
play(pp);
pause(length(morse_code))

function save_morse_Callback(hObject, eventdata, handles)

global morse_code msou;
dir= uigetdir();
if ~isempty(dir)
    filename = strcat(dir,'morse_sound.wav');
    audiowrite(filename,msou,11000);
end

function reset_fields_Callback(hObject, eventdata, handles)

set(handles.in_msg,'String','');
