clc

load data.mat

in_text = 'Shayu';
fprintf('Input : %s\n',in_text);
text= lower(in_text);
len = length(text);
mor = [];
for i=1:len
    if text(i) == ' '
        mor = [mor '/'];
    elseif isvarname(text (i))
        mor = [mor getfield(morse,text(i))];
        mor = [mor ' '];
    elseif ~isempty(str2num(text))
        mor = [mor getfield(morse,['n',text(i)])];
        mor = [mor ' '];
    elseif findstr(text(i),morse.sc)
        mor = [mor char(morse.scv(findstr(text(i),morse.sc)))];
        mor = [mor ' '];
    end 
end   



fprintf('Output : %s\n',mor);



%%decode

code = mor;
deco = [];
code = [code ' '];
lcode = [];

for j=1:length(code)
    if(strcmp(code(j),' ')|strcmp(code(j),'/'))
        for i=double('a'):double('z')
            letter = getfield(morse,char(i));
            if strcmp(lcode,letter)
                deco = [deco char(i)];
             end
        end
        for i=0:9
            numb = getfield(morse,['n',num2str(i)]);
            if strcmp(lcode,numb)
                deco = [deco,num2str(i)];
            end
        end
        for i=1:4
            scv=char(morse.scv(i));
            if strcmp(lcode,scv)
                deco = [deco, morse.sc(i)];
            end
        end    
        lcode = [];
    else
        lcode = [lcode code(j)];
    end
    if strcmp(code(j),'/')
        deco = [deco ' '];
    end    
end   

fprintf('Decoded: %s \n',deco);

%%sound

t=0:5000;
Dot = sin(t(1:700));
Dash = sin(t(1:2000));
ssp = sin(t(1:2000));
lsp = sin(t(1:4000));

msou = [];
text = mor;

for i=1:length(text)
    if strcmp(text(i),'.')
        msou = [msou Dot ssp];
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