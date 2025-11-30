% Counters for all 16 videos
N_alice = zeros(1,16);
N_bob   = zeros(1,16);
N_coinc = zeros(1,16);   % coincident pulses

for k = 1:16
    
    % build filename
    filename = sprintf('/Users/yoavgan/Desktop/matlab/part b- %d.mp4', k);
    v = VideoReader(filename);

    % total number of frames
    N = floor(v.FrameRate * v.Duration);

    % Preallocate
    D_alice = zeros(1, N);
    D_bob   = zeros(1, N);

    % ==== ROI for Alice ====
    y1A = 173;  y2A = 200;
    x1A = 530;  x2A = 567;

    % ==== ROI for Bob (תעדכן לפי האמיתיות) ====
    y1B = 559;  y2B = 595;   % ← דוגמה, תחליף לקואורדינטות האמיתיות
    x1B = 526;  x2B = 562;

    % ==== Thresholds ====
    thrAlice = 125000;
    thrBob   = 25000;

    % ==== Read frames & compute intensities ====
    for i = 1:N-10
        frame = read(v, i);

        % Alice
        roiA = frame(y1A:y2A, x1A:x2A, 1);
        D_alice(i) = sum(roiA(:));

        % Bob
        roiB = frame(y1B:y2B, x1B:x2B, 1);
        D_bob(i) = sum(roiB(:));
    end

    % אם אתה רוצה, אפשר גם לאפס את הזנב האחרון:
    % D_alice(N-9:N) = D_alice(N-10);
    % D_bob(N-9:N)   = D_bob(N-10);

    % ==== Pulse detection (rising edges) ====
alicePulse = false(1, N);
bobPulse   = false(1, N);

for i = 2:N
    alicePulse(i) = (D_alice(i-1) < thrAlice) && (D_alice(i) >= thrAlice);
    bobPulse(i)   = (D_bob(i-1)   < thrBob)   && (D_bob(i)   >= thrBob);
end

idxAlice = find(alicePulse);
idxBob   = find(bobPulse);

% ==== Coincidence with ±5 frames tolerance ====
tolerance = 5;
coincPulse = false(1, N);

for a = idxAlice
    % define window [a - 5, a + 5]
    low  = max(1, a - tolerance);
    high = min(N, a + tolerance);

    % check if ANY Bob pulse is in this window
    if any( bobPulse(low:high) )
        coincPulse(a) = true;
    end
end

N_alice(k) = numel(idxAlice);
N_bob(k)   = numel(idxBob);
N_coinc(k) = sum(coincPulse);


    % Counters
    N_alice(k) = sum(alicePulse);
    N_bob(k)   = sum(bobPulse);
    N_coinc(k) = sum(coincPulse);

    % Indices of pulses
    idxAlice = find(alicePulse);
    idxBob   = find(bobPulse);
    idxCoinc = find(coincPulse);

    % ==== Plot ====
    figure;
    plot(D_alice, 'LineWidth', 1.5); hold on;
    plot(D_bob,   'LineWidth', 1.5);

    % Threshold lines
    yline(thrAlice, '--', 'Alice thr', 'LineWidth', 1.2);
    yline(thrBob,   '--', 'Bob thr',   'LineWidth', 1.2);

    % Mark pulses
    % Alice pulses
    plot(idxAlice, D_alice(idxAlice), 'ro', 'MarkerSize', 6, 'LineWidth', 1.2);
    % Bob pulses
    plot(idxBob,   D_bob(idxBob),     'bs', 'MarkerSize', 6, 'LineWidth', 1.2);
    % Coincident pulses (מסומנים על Alice, אפשר גם על Bob אם תרצה)
    plot(idxCoinc, D_alice(idxCoinc), 'k*', 'MarkerSize', 10, 'LineWidth', 1.5);

    xlabel('Frame number');
    ylabel('Intensity [AU])');
    legend('Alice', 'Bob', 'Alice thr', 'Bob thr', ...
           'Alice pulses', 'Bob pulses', 'Coincident pulses', ...
           'Location', 'best');
    grid on;

    % Print results for this video
    fprintf('Video %d: Alice pulses = %d, Bob pulses = %d, COINC pulses = %d\n', ...
        k, N_alice(k), N_bob(k), N_coinc(k));

end
