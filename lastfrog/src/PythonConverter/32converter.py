from PIL import Image

# Open the image file (Ensure the path is correct)
img = Image.open("carbluer.png")  # Change to your actual image path
img = img.resize((32, 32))  # Resize from original size to 20x20 pixels

# Define a function to quantize the RGB values to 2-bit per channel
def rgb_to_6bit(r, g, b):
    r_2bit = (r // 64) & 0b11  # 2-bit red
    g_2bit = (g // 64) & 0b11  # 2-bit green
    b_2bit = (b // 64) & 0b11  # 2-bit blue
    return (r_2bit << 4) | (g_2bit << 2) | b_2bit  # Combine into 6-bit value

# Convert the image to 6-bit RGB format
bram_array = []

# Ensure each pixel from 0 to 399 is processed (20x20 = 400 pixels)
for y in range(32):
    for x in range(32):
        r, g, b = img.getpixel((x, y))[:3]  # Get RGB value for each pixel
        pixel_6bit = rgb_to_6bit(r, g, b)
        bram_array.append(pixel_6bit)

# Print the BRAM initialization values for all pixels (0 to 399)
for i in range(1024):
    if i < len(bram_array):
        val = bram_array[i]
        print(f"blue_car_right_bram[{i}] = 6'b{val:06b};")
    else:
        print(f"blue_car_right_bram[{i}] = 6'b000000;")  # Fallback for any missing pixels

# Debugging: check how many pixels were processed
print(f"Total pixels processed: {len(bram_array)}")
