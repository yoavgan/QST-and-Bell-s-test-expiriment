v = VideoReader('/Users/yoavgan/Desktop/matlab/part b- 1.mp4');
% get total number of frames
N = floor(v.FrameRate * v.Duration);
D = zeros(1,N);
y1 = 567;  y2 = 690;
x1 = 533;  x2 = 555;



for i = 1:N-10
    frame = read(v,i);
    D(i) = sum(sum(frame(y1:y2, x1:x2, 1)));
end
plot(D, 'LineWidth', 1.5);
hold on;

yline(20000, '--r', 'Threshold 20000', 'LineWidth', 1.5);

plot(D)
xlabel('Frame number')
ylabel('ROI intensity')
title('Bob 1')
%ylabel('Intensity');
grid on

%writematrix(D, 'part b (alice) - data 16 .xlsx');
