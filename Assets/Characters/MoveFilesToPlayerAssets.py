import os
import shutil

_temp_path = "E:\Dev\Godot\AwesomeRPG\Assets\Texture\Icons"
_icon_path = "E:\Dev\Godot\AwesomeRPG\Assets\Texture\Icons"

input_folder = r"E:\Other\素材\Temp\Temp"

def classify_files():
    for root, dirs, files in os.walk(input_folder):
        for file in files:
            file_name, file_extension = os.path.splitext(file)
            
            if 'Body' in file_name:
                destination_folder = os.path.join(_temp_path, '胸甲')
            elif 'Head' in file_name:
                destination_folder = os.path.join(_temp_path, '头盔')
            else:
                continue


            #if 'Body' in file_name:
            #    destination_folder = os.path.join(_temp_path, '胸甲')
            # elif 'Face' in file_name:
            #    destination_folder = os.path.join(_temp_path, 'Faces')
            #elif 'Head' in file_name:
            #    destination_folder = os.path.join(_temp_path, '头盔')
            #elif 'Left Arm' in file_name:
            #    destination_folder = os.path.join(_temp_path, 'LeftArms')
            #elif 'Left Hand' in file_name.strip():
            #    destination_folder = os.path.join(_temp_path, 'LeftHands')
            #elif 'Left Leg' in file_name:
            #    destination_folder = os.path.join(_temp_path, 'LeftLegs')
            #elif 'Right Arm' in file_name:
            #    destination_folder = os.path.join(_temp_path, 'RightArms')
            #elif 'Right Hand' in file_name:
            #    destination_folder = os.path.join(_temp_path, 'RightHands')
            #elif 'Right Leg' in file_name:
            #    destination_folder = os.path.join(_temp_path, 'RightLegs')
            #elif 'Weapon' in file_name:
            #    destination_folder = os.path.join(_temp_path, 'Weapons')
            #else:
            #    continue
            
            source_file_path = os.path.join(root, file)
            print(source_file_path)
            destination_file_path = os.path.join(destination_folder, file_name + file_extension)

            counter = 1
            while os.path.exists(destination_file_path):
                destination_file_path = os.path.join(destination_folder, file_name + str(counter) + file_extension)
                counter += 1

            shutil.move(source_file_path, destination_file_path)

            print(f"Moved '{source_file_path}' to '{destination_file_path}' folder.")

classify_files()