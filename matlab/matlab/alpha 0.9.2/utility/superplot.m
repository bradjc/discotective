function [] = superplot(handle,pos)
% Resizes a figure to either top half of screen, bottom half, or full
% screen
%
% handle = figure handle
% pos = 'top','bottom',or 'full'

v = get(0,'MonitorPositions');
v = v(1,:);
w = v(3);
h = v(4);
bar = 40;
h = h - bar;
if(strcmp(pos,'top'))
    rect = [0 (bar+round(h/2)) w round(h/2)];
elseif(strcmp(pos,'bottom'))
    rect = [0 bar w round(h/2)];
else
    rect = [0 bar w h];
end
set(handle, 'OuterPosition', rect);

end