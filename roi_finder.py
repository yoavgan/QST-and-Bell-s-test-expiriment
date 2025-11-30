import cv2

video_path = r"/Users/yoavgan/Desktop/matlab/part b- 1.mp4"
cap = cv2.VideoCapture(video_path)

if not cap.isOpened():
    raise RuntimeError("Could not open video file")

playing = True
current_frame = 0
roi = None

def go_to_frame(idx):
    cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
    ret, frame = cap.read()
    return ret, frame

# קריאה ראשונית
ret, frame = go_to_frame(0)

print("Controls:")
print("SPACE = Play/Pause")
print("Right Arrow = Next frame")
print("Left Arrow = Previous frame")
print("r = Select ROI on current frame")
print("q = Quit\n")

while True:
    if playing:
        ret, frame = go_to_frame(current_frame)
        if not ret:
            break
        current_frame += 1

    # הצגת ריבוע ROI אם הוא קיים
    if roi is not None:
        x, y, w, h = roi
        cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)

    cv2.imshow("Video Player", frame)
    key = cv2.waitKey(30) & 0xFF

    # מקשי שליטה
    if key == ord('q'):
        break

    elif key == ord(' '):  # Play/Pause
        playing = not playing

    elif key == 81:  # Left arrow ←
        playing = False
        current_frame = max(0, current_frame - 1)
        ret, frame = go_to_frame(current_frame)

    elif key == 83:  # Right arrow →
        playing = False
        current_frame += 1
        ret, frame = go_to_frame(current_frame)

    elif key == ord('r'):  # Select ROI
        playing = False
        # OpenCV selectROI requires BGR, so use frame as-is
        roi = cv2.selectROI("Select ROI", frame, showCrosshair=True, fromCenter=False)
        cv2.destroyWindow("Select ROI")
        print("ROI selected:", roi)

cap.release()
cv2.destroyAllWindows()

print("Final ROI chosen:", roi)


