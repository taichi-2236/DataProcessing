%% plot_field.m
Division = 'B';
DisplayMode = 'normal';
Margin = 'ON';

% Divisionによって線の長さを変える
switch Division
    case 'A'
        FieldLength     = 12.0;
        FieldWidth      =  9.0;
        CircleRadius    =  0.5;
        DefenseAreaLine =  1.8;

    otherwise
        FieldLength     =  9.0;
        FieldWidth      =  6.0;
        CircleRadius    =  0.5;
        DefenseAreaLine =  1.0;
end

% 指定されたモードによってフィールドの見た目を変える
switch DisplayMode
    case 'mono'
        LineColor  = '#9F9F9F';
        FieldColor = '#FFFFFF';
        
    otherwise
        LineColor  = '#FFFFFF';
        FieldColor = '#007F00';
end

% 表示されるフィールドの周りのマージンを調整する
switch Margin
    case 'ON'
        FieldLengthMargin = 0.5;
        FieldWidthMargin  = 0.5;
        
    otherwise
        FieldLengthMargin = 0;
        FieldWidthMargin  = 0;
end

FieldLengthH = FieldLength/2.0;
FieldWidthH  = FieldWidth/2.0;

hold on
% background
xregion(-FieldLengthH-CircleRadius,FieldLengthH+CircleRadius,...
    "FaceColor",FieldColor,'HandleVisibility','off');
% line
plot([ FieldLengthH  FieldLengthH],[-FieldWidthH  FieldWidthH],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-FieldLengthH -FieldLengthH],[-FieldWidthH  FieldWidthH],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-FieldLengthH  FieldLengthH],[ FieldWidthH  FieldWidthH],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-FieldLengthH  FieldLengthH],[-FieldWidthH -FieldWidthH],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([ 0.0  0.0],[-FieldWidthH  FieldWidthH],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-FieldLengthH  FieldLengthH],[ 0.0  0.0],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-FieldLengthH -(FieldLengthH-DefenseAreaLine)],...
    [ DefenseAreaLine  DefenseAreaLine],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-FieldLengthH -(FieldLengthH-DefenseAreaLine)],...
    [-DefenseAreaLine -DefenseAreaLine],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-(FieldLengthH-DefenseAreaLine) -(FieldLengthH-DefenseAreaLine)],...
    [-DefenseAreaLine  DefenseAreaLine],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([-FieldLengthH -(FieldLengthH-DefenseAreaLine)],...
    [-DefenseAreaLine -DefenseAreaLine],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([ (FieldLengthH-DefenseAreaLine)  FieldLengthH],...
    [ DefenseAreaLine  DefenseAreaLine],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([ (FieldLengthH-DefenseAreaLine)  FieldLengthH],...
    [-DefenseAreaLine -DefenseAreaLine],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');
plot([ (FieldLengthH-DefenseAreaLine)  (FieldLengthH-DefenseAreaLine)],...
    [-DefenseAreaLine  DefenseAreaLine],...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');

% center ciecle
theta = linspace(0,2*pi);
plot(CircleRadius*cos(theta),CircleRadius*sin(theta),...
    '-','LineWidth',1,'Color',LineColor,'HandleVisibility','off');

axis equal
grid on
xlim([-(FieldLengthH+FieldLengthMargin) (FieldLengthH+FieldLengthMargin)]);
% xlim([-6.5 6.5]);
ylim([-(FieldWidthH+FieldWidthMargin) (FieldWidthH+FieldWidthMargin)]);
xticks([-FieldLengthH fix(-FieldLengthH+eps(10)):1.0:fix(FieldLengthH-eps(10)) FieldLengthH]);
yticks([-FieldWidthH fix(-FieldWidthH+eps(10)):1.0:fix(FieldWidthH-eps(10)) FieldWidthH]);
hold off    