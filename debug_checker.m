clear variables;
close all;

load('workspace_pts_checker');

imshow(img);
hold on;
% plot(points(:,1),points(:,2),'ob');
% plot(points(1,1),points(1,2),'or');
% plot(points(2,1),points(2,2),'og');
% plot(points(3,1),points(3,2),'ob');

for i=1:length(points)
   p = plot(points(i,1),points(i,2),'or'); 
   pause;
   delete(p);
end