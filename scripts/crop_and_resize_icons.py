import os
from PIL import Image

# Source paths of the generated images
SOURCE_ICONS = {
    "Red": r"C:\Users\ilya\.gemini\antigravity\brain\00b6c845-7bf2-476a-9f16-1865a3837e16\sosuzagram_red_icon_1780821958626.png",
    "Green": r"C:\Users\ilya\.gemini\antigravity\brain\00b6c845-7bf2-476a-9f16-1865a3837e16\sosuzagram_green_icon_1780821971125.png",
    "Orange": r"C:\Users\ilya\.gemini\antigravity\brain\00b6c845-7bf2-476a-9f16-1865a3837e16\sosuzagram_orange_icon_1780821983755.png",
    "Purple": r"C:\Users\ilya\.gemini\antigravity\brain\00b6c845-7bf2-476a-9f16-1865a3837e16\sosuzagram_purple_icon_1780821996363.png"
}

# Target directory in the overlay repository
ROOT_DIR = r"c:\Users\ilya\Desktop\sosuzargamios"
TARGET_BASE_DIR = os.path.join(ROOT_DIR, "overlay", "Sosuzagram", "Telegram-iOS")

# Sizes map: {filename_suffix: size_in_pixels}
SIZES = {
    "Icon@2x.png": (120, 120),
    "Icon@3x.png": (180, 180),
    "IconIpad.png": (76, 76),
    "IconIpad@2x.png": (152, 152),
    "IconLargeIpad@2x.png": (167, 167),
    "NotificationIcon.png": (20, 20),
    "NotificationIcon@2x.png": (40, 40),
    "NotificationIcon@3x.png": (60, 60),
}

def resize_icon(source_path, target_dir, color):
    if not os.path.exists(source_path):
        print(f"Error: Source file {source_path} does not exist!")
        return False
        
    os.makedirs(target_dir, exist_ok=True)
    img = Image.open(source_path)
    
    # Ensure it's square and RGB/RGBA
    if img.size[0] != img.size[1]:
        # Crop to square
        min_dim = min(img.size)
        left = (img.size[0] - min_dim) / 2
        top = (img.size[1] - min_dim) / 2
        right = (img.size[0] + min_dim) / 2
        bottom = (img.size[1] + min_dim) / 2
        img = img.crop((left, top, right, bottom))
        
    for suffix, size in SIZES.items():
        filename = f"{color}{suffix}"
        target_path = os.path.join(target_dir, filename)
        resized_img = img.resize(size, Image.Resampling.LANCZOS)
        resized_img.save(target_path, "PNG")
        print(f"Generated: {target_path} ({size[0]}x{size[1]})")
    return True

def main():
    for color, src_path in SOURCE_ICONS.items():
        print(f"Processing {color} icon...")
        alticon_dir = os.path.join(TARGET_BASE_DIR, f"{color}Icon.alticon")
        success = resize_icon(src_path, alticon_dir, color)
        if success:
            print(f"Successfully generated alticon set for {color}")
        else:
            print(f"Failed to generate alticon set for {color}")

if __name__ == "__main__":
    main()
