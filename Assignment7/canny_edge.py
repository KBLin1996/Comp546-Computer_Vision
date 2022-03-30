import cv2


if __name__ == '__main__':
    image = cv2.imread("Minions.jpeg")  # Read image
      
    # Setting parameter values
    t_lower = 120  # Lower Threshold
    t_upper = 400  # Upper threshold
      
    # Applying the Canny Edge filter
    edge = cv2.Canny(image, t_lower, t_upper)
      
    cv2.imshow('Original', image)
    cv2.imshow('Edge', edge)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
