function roi = selectROIFromVideo(videoFile)
% פונקציה לבחירת ROI מתוך וידאו בעזרת נגן אינטראקטיבי
% שימוש:
%   roi = selectROIFromVideo('/Users/yoavgan/Desktop/matlab/QT part A- 10 bits.mp4');

    v = VideoReader(videoFile);
    numFrames = floor(v.FrameRate * v.Duration);

    frameIdx = 1;
    playing = true;
    roi = [];
    keyPressed = '';

    fig = figure('Name', 'Video ROI Selector', ...
                 'NumberTitle', 'off', ...
                 'KeyPressFcn', @keyHandler);

    % לולאת נגן
    while ishandle(fig)
        % לוודא שאנחנו בטווח תקין
        frameIdx = max(1, min(numFrames, frameIdx));

        % קריאת הפריים הנוכחי
        frame = read(v, frameIdx);

        % הצגת הפריים
        imshow(frame, 'InitialMagnification', 'fit');
        hold on;
        if ~isempty(roi)
            rectangle('Position', roi, 'EdgeColor', 'g', 'LineWidth', 2);
        end
        hold off;

        title(sprintf(['Frame %d / %d | SPACE = Play/Pause | ←/→ = Back/Forward ', ...
                       '| r = Select ROI | q = Quit'],
                      frameIdx, numFrames));

        drawnow;

        % זמן המתנה – בערך לפי fps
        pause(1 / v.FrameRate);

        % טיפול במקשים שנלחצו
        switch keyPressed
            case 'space'    % Play / Pause
                playing = ~playing;

            case 'rightarrow'   % פריים קדימה
                playing = false;
                frameIdx = min(frameIdx + 1, numFrames);

            case 'leftarrow'    % פריים אחורה
                playing = false;
                frameIdx = max(frameIdx - 1, 1);

            case 'r'        % בחירת ROI בעזרת העכבר
                playing = false;
                disp('בחר ROI עם העכבר (סיום עם Enter / דאבל־קליק)');
                h = imrect;
                pos = wait(h);   % pos = [x y width height]
                roi = round(pos);
                fprintf('\nROI נבחר: [x y width height] = [%d %d %d %d]\n', roi);

                x1 = roi(1);
                y1 = roi(2);
                x2 = roi(1) + roi(3);
                y2 = roi(2) + roi(4);

                fprintf('\n=== קואורדינטות לשימוש בקוד האנליזה ===\n');
                fprintf('שורות (y): %d:%d\n', y1, y2);
                fprintf('עמודות (x): %d:%d\n', x1, x2);
                fprintf('\nדוגמה לחיתוך:\n');
                fprintf('frame(%d:%d, %d:%d, 1)\n', y1, y2, x1, x2);
                fprintf('D2(i) = sum(sum(frame(%d:%d, %d:%d, 1)));\n\n', y1, y2, x1, x2);

            case 'q'        % יציאה
                break;
        end

        % איפוס המקש כדי שלא ירוץ שוב
        keyPressed = '';

        % אם במצב Play – להתקדם אוטומטית בפריימים
        if playing
            frameIdx = frameIdx + 1;
            if frameIdx > numFrames
                frameIdx = numFrames;
                playing = false;
            end
        end
    end

    if ishandle(fig)
        close(fig);
    end

    % החזרת ROI (אם נבחר)
    if ~isempty(roi)
        fprintf('ROI סופי שהוחזר מהפונקציה: [x y width height] = [%d %d %d %d]\n', roi);
    else
        fprintf('לא נבחר ROI.\n');
    end

    % פונקציית callback למקשי המקלדת
    function keyHandler(~, event)
        keyPressed = event.Key;
    end
end
