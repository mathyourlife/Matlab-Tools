disp('Showing what orthogonal set results looks like')
z_in = (rand(3,1) - rand(3,1)) * 6;
[x, y, z] = orthogonal_set(z_in);
plot3([0 x(1)]',[0 x(2)]',[0 x(3)]','b','LineWidth',3)
hold on
plot3([0 y(1)]',[0 y(2)]',[0 y(3)]','b','LineWidth',3)
L=plot3([0 z(1)]',[0 z(2)]',[0 z(3)]','g','LineWidth',4);
p=get(L,'parent');
grid on
set(p,'XLim',[-1 1],'YLim',[-1 1],'ZLim',[-1 1],'DataAspectRatio',[1 1 1])
text(x(1)*1.1,x(2)*1.1,x(3)*1.1,'x','FontWeight','bold','FontSize',14)
text(y(1)*1.1,y(2)*1.1,y(3)*1.1,'y','FontWeight','bold','FontSize',14)
text(z(1)*1.1,z(2)*1.1,z(3)*1.1,'z','FontWeight','bold','FontSize',14)
title(sprintf('Orthogonal Set Made From [%0.2f %0.2f %0.2f]',z_in(1),z_in(2),z_in(3)),'FontWeight','bold','FontSize',14)
