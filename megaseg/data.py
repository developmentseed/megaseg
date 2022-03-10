
import numpy as np
import torch
import torchvision
from torchvision.transforms import ToTensor, Normalize, Compose
from torchvision.datasets import MNIST
import skimage.transform as transform

class MegapixelMNIST(MNIST):
    """Load a Megapixel MNIST dataset. See make_mnist.py."""

    CLASSES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    def __init__(self, mega_size, resize, *args, **kwargs):
        
        super().__init__(*args, **kwargs)
        self.big_size = mega_size
        self.big_shape = (mega_size, mega_size)
        self.resize = resize
        if self.resize*28 > self.big_size-28:
            raise ValueError("""The resize parameter cannot be so large 
            that the 28x28 image is made larger than the big image shape - 28.""")
        
    def __getitem__(self, i):
        
        small_img, small_target = MNIST.__getitem__(self, i)
        small_img = transform.resize(small_img.squeeze(), 
                                     (small_img.squeeze().shape[0] * self.resize, 
                                      small_img.squeeze().shape[1] * self.resize),
                                     anti_aliasing=True)
        # Placeholders
        big_img = np.zeros(self.big_shape, dtype=np.float32)-1
        # Fill the sparse representations
        small_indices = np.argwhere(small_img)
        xoffset = np.random.randint(0, self.big_size-28*self.resize)
        yoffset = np.random.randint(0, self.big_size-28*self.resize)
        big_img[yoffset:yoffset+small_img.shape[0], xoffset:xoffset+small_img.shape[1]] = small_img
        big_img = torch.from_numpy(big_img)
        # big_img = self.image_transform(big_img)
        label = np.where(big_img>-1, 1, 0)
        return big_img, label
