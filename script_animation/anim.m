% ref: 
% (1) https://jp.mathworks.com/matlabcentral/answers/615613-videowriter-mpeg-4
% (2) https://jp.mathworks.com/help/symbolic/writeanimation.html
figure('units','pixels','position',[100 500 800 600])

% vobj = VideoWriter('ball_pushing.mp4','MPEG-4');
% vobj = VideoWriter('movie/ball_pushing.avi');
[filepath,name,ext] = fileparts(datafile);
movie = append('movie/','anim_',regexprep(name,"\w*_data_",""),".avi");
vobj = VideoWriter(movie);

vobj.Quality = 100;
vobj.FrameRate = 10;
open(vobj)

d_rf = 0.078;
w_d = 0.075;
r_b = 0.043;

ax = gca;
ax.XAxisLocation = 'origin';  ax.YAxisLocation = 'origin';
view_len = 0.3;
% axis equal, xlim([-1 2]), ylim([-1.5 1.5])
% xlabel('$X$ (m)'), ylabel('$Y$ (m)')
% grid on, hold off, hold on
drawnow limitrate
frame = getframe(gcf);
f = imresize(frame.cdata,4);
for k = 1:5:numel(tout)
    plot([-4.5 1.5],[-2.0 -2.0],'r-')
    % robot animation %
    plot(q_r(k,1),q_r(k,2),'ro'), hold on, grid on
    sslrobot(q_r(k,1), q_r(k,2), q_r(k,3));
    plot([q_r(k,1) q_r(k,1)+d_rf*cos(q_r(k,3))],...
         [q_r(k,2) q_r(k,2)+d_rf*sin(q_r(k,3))],'r-')
    plot([q_r(k,1)+d_rf*cos(q_r(k,3))+0.5*w_d*cos(q_r(k,3)+pi/2) ...
          q_r(k,1)+d_rf*cos(q_r(k,3))+0.5*w_d*cos(q_r(k,3)-pi/2)],...
         [q_r(k,2)+d_rf*sin(q_r(k,3))+0.5*w_d*sin(q_r(k,3)+pi/2) ...
          q_r(k,2)+d_rf*sin(q_r(k,3))+0.5*w_d*sin(q_r(k,3)-pi/2)],'r-')
    % ball animation %
    % obj_b = circle2(q_b(k,1), q_b(k,2), r_b);
    obj_b = plot(q_b(k,1),q_b(k,2),'Marker','o','MarkerFaceColor','#FF8F00','MarkerEdgeColor','#000000');
    obj_b.MarkerSize = 4.0;
    % obj_b.EdgeColor = 'black';
    % obj_b.FaceColor = [1 0.65 0];
    % plot(q_b(k,1),q_b(k,2),'b.')
    % plot([q_b(k,1) q_b(k,1)+r_b*cos(q_b(k,3))],...
    %      [q_b(k,2) q_b(k,2)+r_b*sin(q_b(k,3))], 'c-')
    % ax.XAxisLocation = 'origin';  ax.YAxisLocation = 'origin';
    axis equal
    % for a moving frame
    xlim([q_r(k,1)-0.5*view_len q_r(k,1)+0.5*view_len])
    ylim([q_r(k,2)-0.5*view_len q_r(k,2)+0.5*view_len])
    % for a fixed frame
    %xlim([-.25 1.75]), ylim([-.15 1.85])   % for viewing positive side of y-axis
    xlim([-1.5 1.75]), ylim([-1.5 1.75])   % for viewing negative side of y-axis
    % xlim([-5.0 5.0]), ylim([-3.0 3.0])   % for viewing negative side of y-axis
    xlim([min(q_r(:,1))-0.2 max(q_r(:,1))+0.2])
    ylim([min(q_r(:,2))-0.2 max(q_r(:,2))+0.2])   
    %xlim([-.5 1.5]), ylim([-1 1])   % for viewing both sides of y-axis

    % ball trajectory
    % plot(p_wb_d(1:k,1),p_wb_d(1:k,2),'r--')
    plot(q_r(1:k,1),q_r(1:k,2),'-','LineWidth',2,'Color','#007FFF');
    plot(q_b(1:k,1),q_b(1:k,2),'-','LineWidth',2,'Color','#FF8F00');

    % str4time = sprintf('$t = %5.1f$ s', tout(k)/60);
    str4time = sprintf('frame = %5.1f', tout(k));
    title(str4time), xlabel('X (m)'), ylabel('Y (m)')
    set(findobj('type','axes'),'fontsize',16); 
    hold off
    
    drawnow limitrate
    frame = getframe(gcf);
    f = imresize(frame.cdata,4);
    % size(f)
    writeVideo(vobj, f);
    pause(.05)
end

close(vobj)
close all;