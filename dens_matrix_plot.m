% ------------------------------------------------------------
% 3D Plot of a 4x4 Matrix (Density Matrix Style)
% ------------------------------------------------------------

% --- Insert your 4x4 matrix here ---
M = [0.5 0 0 0.5;
     0   0 0 0;
     0   0 0 0;
     0.5 0 0 0.5];   % Example (replace this)

% --- Basis labels ---
labels = {'HH','HV','VH','VV'};

% --- Create 3D bar plot ---
figure;
h = bar3(M);

% Apply color shading similar to your example
for k = 1:length(h)
    zdata = h(k).ZData;
    h(k).CData = zdata;    % Use height as color
    h(k).FaceColor = 'interp';
end

colormap(parula);   % or turbo, jet, etc.
colorbar;

% --- Axis settings ---
set(gca, 'XTickLabel', labels, 'XTick', 1:4, 'FontSize', 12);
set(gca, 'YTickLabel', labels, 'YTick', 1:4, 'FontSize', 12);

zlabel('Probability','FontSize',14);

title('HHVV 10 bits','FontSize',16);

view([-35 25]);  % nice 3D angle
grid on;
