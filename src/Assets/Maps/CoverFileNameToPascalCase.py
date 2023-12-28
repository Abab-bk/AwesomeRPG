import os

def snake_to_pascal_case(text):
    words = text.split('_')
    capitalized_words = [word.capitalize() for word in words]
    return ''.join(capitalized_words)

def convert_file_names(path):
    for root, dirs, files in os.walk(path):
        for file_name in files:
            snake_case_name, ext = os.path.splitext(file_name)
            if snake_case_name[0].islower() and not file_name.endswith('.import'):
                pascal_case_name = snake_to_pascal_case(snake_case_name)
                new_file_name = pascal_case_name + ext
                old_file_path = os.path.join(root, file_name)
                new_file_path = os.path.join(root, new_file_name)
                os.rename(old_file_path, new_file_path)

# 指定当前文件夹作为路径
current_directory = os.getcwd()
convert_file_names(current_directory)