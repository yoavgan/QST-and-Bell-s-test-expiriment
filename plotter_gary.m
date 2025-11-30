v= VideoReader('/Users/yoavgan/Desktop/matlab/QT part A- 10 bits.mp4');
for i=1:1:781
frame = read(v,i);
%pcolor(frame(761:800,165:200,1))
%D2(i)=sum(sum(frame( 386:421,173:202,1)));
D2(i)=sum(sum(frame(:,1)));
shading flat
fprintf('Min red: %d\n', min(frame(:,:,1), [], 'all'));
fprintf('Max red: %d\n', max(frame(:,:,1), [], 'all'));
fprintf('Number of frames > 200: %d\n', sum(D2 > 50));


%plot(frame(200,:,1))
%[M,I] = max(frame(200,:,ס1));
%x(i)=I;
%shading flat
%pause(0.05)
%colorbar
i
end
1

plot(D2) 


%pcolor(frame(:,:,1))
%shading flat