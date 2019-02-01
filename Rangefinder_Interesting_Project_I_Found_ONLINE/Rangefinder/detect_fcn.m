function [X, Y, distance]=detect_fcn(I,lim)
hsv = rgb2hsv(I);
v = hsv(:,:,3);
% 
max_v=0.95;

coord=[ ];
for f=lim(1):lim(2)
    for c=lim(3):lim(4)
        if v(f,c)>=max_v % v(f,c)==max_v
            coord=[coord;[f,c]];
        end
    end
end

if isempty(coord)
    X='';
    Y='';
    distance='';
    return
end
%
% save coord coord
%

Y=round((min(coord(:,1))+max(coord(:,1)))/2);
X=round((min(coord(:,2))+max(coord(:,2)))/2);
% image(I)
hold on
% 
plot(X,Y,'go','markerSize',10)
%Draw vertical line
line([X X],[288 1],'Color','r')
%Draw horizontal line
line([352 1],[Y Y],'Color','r')
% 
hold off

h_cm=5;
gain=0.0020;
offset=0.001;
pfc=Y-144;
distance=round(h_cm/tan(pfc*gain + offset));