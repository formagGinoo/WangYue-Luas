import os

def rename_txt_to_lua(directory):
    for root, _, files in os.walk(directory):
        for filename in files:
            if filename.endswith(".txt"):
                base_name = os.path.splitext(filename)[0]
                new_name = f"{base_name}.lua"
                old_path = os.path.join(root, filename)
                new_path = os.path.join(root, new_name)
                os.rename(old_path, new_path)
                print(f"Renamed {old_path} to {new_path}")

if __name__ == "__main__":
    current_directory = "./lua"
    rename_txt_to_lua(current_directory)
    print("Files renamed successfully!")
