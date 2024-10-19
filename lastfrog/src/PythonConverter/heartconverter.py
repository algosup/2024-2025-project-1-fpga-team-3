from PIL import Image

# Open the image file (Ensure the path is correct)
img = Image.open("heart.png")  # Change to your actual image path
img = img.resize((16, 16))  # Resize to 16x16 pixels

# Define a function to quantize the RGB values to 2-bit per channel
def rgb_to_6bit(r, g, b):
    r_2bit = (r // 64) & 0b11  # 2-bit red
    g_2bit = (g // 64) & 0b11  # 2-bit green
    b_2bit = (b // 64) & 0b11  # 2-bit blue
    return (r_2bit << 4) | (g_2bit << 2) | b_2bit  # Combine into 6-bit value

# Convert the image to 6-bit RGB format
bram_array = []

# Process each pixel from 0 to 255 for a 16x16 image
for y in range(16):
    for x in range(16):
        r, g, b = img.getpixel((x, y))[:3]  # Get RGB value for each pixel
        pixel_6bit = rgb_to_6bit(r, g, b)
        bram_array.append(pixel_6bit)

# Print the BRAM initialization values for all 256 pixels (0 to 255)
for i in range(256):
    if i < len(bram_array):
        val = bram_array[i]
        print(f"red_car_bram[{i}] = 6'b{val:06b};")
    else:
        print(f"red_car_bram[{i}] = 6'b000000;")  # Fallback for any missing pixels

# Debugging: check how many pixels were processed
print(f"Total pixels processed: {len(bram_array)}")
