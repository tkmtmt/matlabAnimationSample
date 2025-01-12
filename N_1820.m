function pat = N_1820(scale)
[f,v] = stlread('N-1820.stl');

% TR = stlread('N-1820.stl'); % triangulation
% v = TR.Points;  % vertices
% f = TR.ConnectivityList;    % faces

vx = v(:,1);
lBody = max(vx)-min(vx);    % length of body

% normalize
v = 1/lBody*v;

% re-scale
v = scale*v;
col = 0.9*[1 1 1];
pat = patch('Faces',f,'Vertices',v...
    ,'EdgeColor','none'...
    ,'FaceColor',col...
    ...,'FaceAlpha',1 ...
    ...'FaceLighting','gouraud'...
    );
material metal;
end