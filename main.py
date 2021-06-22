import cv2
import sys

OUTPUT_DIR = sys.argv[1]
INPUT_FILE = sys.argv[2]
INPUT_FILE_NAME = sys.argv[3]

cap = cv2.VideoCapture(INPUT_FILE)
fps = int(cap.get(cv2.CAP_PROP_FPS))
# height = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
# width = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

i = 0
write = True
verbose = True
while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break
    
    #frame = frame[100:, :250]
    image_gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Edges
    edges = cv2.Canny(image_gray, 75, 150)
    # edges = cv2.dilate(edges, None)
    # edges = cv2.erode(edges, None)

    if write:
        frames_n = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        cv2.imwrite("{}/{}{}.jpg".format(OUTPUT_DIR, INPUT_FILE_NAME, str(i)), edges)
        if i % 500 == 0 and verbose:
            print("Creating frames {} from {}".format(i, frames_n))
    else:
        cv2.imshow('frame', edges)
    if cv2.waitKey(fps) == ord('q'):
        break
    i += 1
cap.release()
cv2.destroyAllWindows()


