import os

paths = os.walk('D:\Dev\Godot\AwesomeRPG\Assets\Texture\Icons')

for path, dir_lst, file_lst in paths:
    for file_name in file_lst:
        print(file_name)
        os.remove(os.path.join(path, file_name))