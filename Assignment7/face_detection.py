import cv2
import time
import numpy as np


# Used to record the time when we processed last frame
prev_frame_time = 0
# Used to record the time at which we processed current frame
new_frame_time = 0

if __name__ == '__main__':
    # Load the pre-trained models on Haar features and Cascade classifiers
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

    cap = cv2.VideoCapture(0)
    # Set width
    cap.set(3, 1920)
    # Set height
    cap.set(4, 1080)

    while True:
        ret, image = cap.read()
        # cv2 accepts BGR instead of RGB
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

        # Parameters of detectMultiScale:
        #
        # scaleFactor => Parameter specifying how much the image size is reduced at each image scale
        # minNeighbors => Parameter specifying how many neighbors each candidate rectangle should
        #                 have to retain it
        # minSize => Minimum possible object size. Objects smaller than that are ignored
        # maxSize => Maximum possible object size. Objects bigger than this are ignored
        faces = face_cascade.detectMultiScale(
                    gray,
                    scaleFactor=1.2,
                    minNeighbors=5,
                    minSize=(260, 260)
                )

        # Font which we will be using to display FPS
        font = cv2.FONT_HERSHEY_SIMPLEX
        # Time when we finish processing for this frame
        new_frame_time = time.time()
        
        # Calculating the fps
        fps = 1 / (new_frame_time-prev_frame_time)
        prev_frame_time = new_frame_time
    
        # Converting the fps into integer (Since fps is floating type before converting)
        fps = int(fps)
    
        # Putting the FPS count on the frame (must be string format)
        cv2.putText(image, str(fps), (7, 70), font, 3, (100, 255, 0), 3, cv2.LINE_AA)

        for (x,y,w,h) in faces:
            cv2.rectangle(image, (x, y), (x+w, y+h), (255, 0, 0), 6)
            roi_gray = gray[y:y+h, x:x+w]
            roi_color = image[y:y+h, x:x+w]

        cv2.imshow('video', image)

        # Press 'q' to quit
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()