from PIL import Image

# Open the image file (Ensure the path is correct)
img = Image.open("right.png")  # Change to your actual image path

# Convert the image to RGB mode if it's not already
img = img.convert("RGB")

# Resize the image to 32x32 pixels
img = img.resize((32, 32))

# Define a function to quantize the RGB values to 2-bit per channel
def rgb_to_6bit(r, g, b):
    r_2bit = (r // 64) & 0b11  # 2-bit red
    g_2bit = (g // 64) & 0b11  # 2-bit green
    b_2bit = (b // 64) & 0b11  # 2-bit blue
    return (r_2bit << 4) | (g_2bit << 2) | b_2bit  # Combine into 6-bit value

# Convert the image to 6-bit RGB format
bram_array = []

# Process each pixel from the 32x32 image
for y in range(32):
    for x in range(32):
        r, g, b = img.getpixel((x, y))  # Get RGB value for each pixel
        pixel_6bit = rgb_to_6bit(r, g, b)
        bram_array.append(pixel_6bit)

# Print the BRAM initialization values for all pixels, starting from index 2048 to 3072
start_index = 3072
for i in range(1024):
    val = bram_array[i] if i < len(bram_array) else 0  # Default to 0 if no pixel data
    print(f"frog_bram[{start_index + i}] = 6'b{val:06b};")

# Debugging: check how many pixels were processed
print(f"Total pixels processed: {len(bram_array)}")
