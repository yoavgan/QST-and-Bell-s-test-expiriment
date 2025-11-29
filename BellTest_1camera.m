for k = 1:16
    
    % build filename
    filename = sprintf('/Users/yoavgan/Desktop/matlab/part b- %d.mp4', k);
    v = VideoReader(filename);

    % get total number of frames
    N = floor(v.FrameRate * v.Duration);

    % Preallocate
    D_alice = zeros(1, N);
    D_bob   = zeros(1, N);

    % ==== ROI for Alice ====
    y1A = 173;  y2A = 200;
    x1A = 530;  x2A = 567;

    % ==== ROI for Bob (תעדכן לפי המיקום שלו) ====
    y1B = 559;  y2B = 595;   % ← דוגמה, תחליף לקואורדינטות האמיתיות
    x1B = 526;  x2B = 562;   % ← דוגמה, תחליף לקואורדינטות האמיתיות

    % ==== Thresholds ====
    thrAlice = 75000;   % כמו שהיה לך קודם
    thrBob   = 25000;   % תבחר ערך מתאים ל-Bob

    for i = 1:N-10
        frame = read(v, i);

        % Alice
        roiA = frame(y1A:y2A, x1A:x2A, 1);
        D_alice(i) = sum(roiA(:));

        % Bob
        roiB = frame(y1B:y2B, x1B:x2B, 1);
        D_bob(i) = sum(roiB(:));
    end

    % ==== Plot ====
    figure;
    plot(D_alice, 'LineWidth', 1.5);      % Alice
    hold on;
    plot(D_bob, 'LineWidth', 1.5);        % Bob (יקבל צבע שונה אוטומטית)

    % Threshold lines
    yline(thrAlice, '--', 'Alice thr', 'LineWidth', 1.2);
    yline(thrBob,   '--', 'Bob thr',   'LineWidth', 1.2);

    xlabel('Frame number');
    ylabel('ROI intensity[AU]');  % או Intensity (a.u.) אם בא לך להיות פנסי
    title(sprintf('Alice & Bob %d', k));
    legend('Alice', 'Bob', 'Alice thr', 'Bob thr');
    grid on;

end
