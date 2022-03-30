import os
import cv2
import time
import torch
import numpy as np
import matplotlib.pyplot as plt
import torchvision.transforms as T
from PIL import Image
from torchvision import models


# Use pretrained network (fcn in this file) to detect where the objects are in the image
def object_detection(net, image, show_original=False):
    if show_original:
        plt.imshow(image)
        plt.show()

    # Apply the transformations needed
    # These models expect a 3-channel image (RGB) which is normalized with the Imagenet mean and standard deviation
    #
    # Most transforms method take only PIL objects as input.
    # But we can add another transform parameter called transforms.ToPILImage() into transforms.Compose([]),
    # which takes an nd-array as input, to convert an nd-array to PIL object.
    transform = T.Compose([
                    T.transforms.ToPILImage(),
                    # T.Resize won't center crop your image
                    # The center will stay the same since you are only resizing the original image
                    T.Resize(224),
                    # Center Crops the image to have a resulting size of 224 x 224
                    T.CenterCrop(224),
                    T.ToTensor(), 
                    T.Normalize(mean = [0.485, 0.456, 0.406], 
                                std = [0.229, 0.224, 0.225])])
    input_image = transform(image).unsqueeze(0)

    # move the input and model to GPU for speed if available
    if torch.cuda.is_available():
        input_image = input_image.to('cuda')
        net.to('cuda')

    # Pass the input through the net
    # out.shape() => (1, 21, 224, 224)
    # The output shape is [1 x 21 x H x W], as discussed earlier, since the model was trained on 21 classes.
    with torch.no_grad():
        out = net(input_image)['out']

    # We first squeeze the first dimension
    # squeeze() => Returns a tensor with all the dimensions of input of size 1 removed
    # Then we take a max index for each pixel position (dim=0), which represents the predicted class
    # => So every pixel in the output_image now is the index of the highest predicted class
    output_image = torch.argmax(out.squeeze(), dim=0).detach().cpu().numpy()
    #print(f"Segmenatation Image Shape: {output_image.shape}\n")

    return output_image


# We will use the following function to convert this 2D image to an RGB image
# => Each label is mapped to its corresponding color
def color_labeled_image(image):
    # np.zeros_like(image) => Return an array of zeros with the same shape and type as a given array
    r = np.zeros_like(image).astype(np.uint8)
    g = np.zeros_like(image).astype(np.uint8)
    b = np.zeros_like(image).astype(np.uint8)

    # Object 'human' is the 15th label in the fcn prediction
    idx = image == 15

    r[idx] = 192
    g[idx] = 128
    b[idx] = 128

    rgb = np.stack([r, g, b], axis=2)
    return rgb


# This function will change the background to which we desired
def image_matting(object_image, front_image, background_image,
                object_image_shape=(224, 224, 3)) -> np.ndarray:
    # cv2.resize() => cv2.resize(src_size, desire_size, fx_scale, fy_scale, interpolation)
    #
    # If input_image.shape = (224, 224, 3), then after cv2.resize(input_image, (500, 500)),
    # we will get output_image.shape = (500, 500, 3)

    # Resize image to match shape of R-band in RGB output map
    foreground = cv2.resize(front_image, (object_image_shape[0], object_image_shape[1]))
    background = cv2.resize(background_image, (object_image_shape[0], object_image_shape[1]))

    # In high-quality portrait photography, it is common to use a lens with a large aperture to
    # create a shallow depth of field such that the subject is in focus, and the background is out of focus.
    blurred_background = cv2.GaussianBlur(background, (3, 3), 0)

    # Convert uint8 to float
    foreground = foreground.astype(float)
    blurred_background = blurred_background.astype(float)

    # Create a binary mask of the RGB output map using the threshold value 0
    #t
    # cv2.threshold(
    #     InputArray 	  src,
    #     double       	thresh,
    #     double       	maxval,
    #     int          	type
    # )
    #
    # If the pixel value is smaller than the threshold, it is set to 0, otherwise it is set to a maximum value
    _, threshold_mask = cv2.threshold(np.array(object_image), 127, 255, cv2.THRESH_BINARY)

    # Because the mask is binary, the boundary is hard. If we apply this mask to the original image,
    # the output will have unpleasant jagged edges.
    #
    # Apply a slight blur to the mask to soften edges
    threshold_mask = cv2.GaussianBlur(threshold_mask, (7, 7), 0)

    # Normalize the threshold mask to keep intensity between 0 and 1
    threshold_mask = threshold_mask.astype(float) / 255

    # Multiply the foreground with the threshold matte
    foreground = cv2.multiply(threshold_mask, foreground)

    # Multiply the background with (1 - threshold)
    blurred_background = cv2.multiply(1.0 - threshold_mask, blurred_background)

    # Add the masked foreground and background
    outImage = cv2.add(foreground, blurred_background)

    # Return a normalized output image for display
    return outImage / 255


# Add FPS on image
def countingFPS(image, new_frame_time, prev_frame_time):
    # Font which we will be using to display FPS
    font = cv2.FONT_HERSHEY_SIMPLEX

    # Calculating the fps
    fps = 1 / (new_frame_time - prev_frame_time)

    # Converting the fps into integer (Since fps is floating type before converting)
    fps = int(fps)

    # Putting the FPS count on the frame (must be string format)
    cv2.putText(image, str(fps), (7, 70), font, 3, (100, 255, 0), 3, cv2.LINE_AA)

    return image


if __name__ == '__main__':
    # Used to record the time when we processed last frame
    prev_frame_time = 0
    # Used to record the time at which we processed current frame
    new_frame_time = 0

    # We have a pretrained model of FCN (which stands for Fully Convolutional Neural Networks) with a Resnet101 backbone
    fcn = models.segmentation.fcn_resnet101(pretrained=True).eval()

    # Read the background image
    list_background = os.listdir("./Background")
    background_images = list()

    for background_path in list_background:
        if background_path.endswith(('.jpeg', '.jpg', '.png', '.bmp')):
            background_image = cv2.imread(f"./Background/{background_path}")
            background_images.append(background_image)

    # Change the color of background image to RGB
    background_idx = 0
    background_len = len(background_images)

    # Define the captured images from the webcam
    cap = cv2.VideoCapture(0)
    # Set width
    cap.set(3, 1024)
    # Set height
    cap.set(4, 1024)

    while True:
        _, front_image = cap.read()
        # Load the current background image as RGB format
        background_image = cv2.cvtColor(background_images[background_idx], cv2.COLOR_BGR2RGB)

        # Calculating the fps

        labeled_image = object_detection(fcn, front_image, show_original=False)
        object_image = color_labeled_image(labeled_image)
        # Enlarge the object detected image
        object_image = cv2.resize(object_image, (512, 512))
        object_image_shape = object_image.shape
        output_image = image_matting(object_image, front_image, background_image, object_image_shape)

        # Time when we finish processing for this frame
        new_frame_time = time.time()
        output_image = countingFPS(output_image, new_frame_time, prev_frame_time)
        prev_frame_time = new_frame_time
        
        cv2.imshow('Virtual Background', output_image)

        # cv2.waitKey(50) => Raise the milliseconds of the wait latency to enable user press 'q' to quit
        # Press 'q' to quit
        key = cv2.waitKey(50) & 0xFF
        if key == ord('a'):
            if background_idx == 0:
                background_idx += background_len
            background_idx -= 1
        elif key == ord('d'):
            if background_idx == background_len-1:
                background_idx -= background_len
            background_idx += 1
        elif key == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()