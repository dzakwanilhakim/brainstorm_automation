import os
import glob
import shutil
from pathlib import Path
print("Program Input Dataset Brainstorm \n  ")

#1. Create 9 directory
parent_dir = input('New folders Directory: ') #path
for i in range (0, 9):
    directory = str(i)
    folder_dir = os.path.join(parent_dir, directory) 
    os.mkdir(folder_dir)
print("9 Folder telah dibuat pada", parent_dir)

#2. Iterasi dan Move Dataset
# input directory variable
directory = input("Directory dataset: ")
dst = parent_dir

def main(format):
    #i = 0 #parent directory index
    j = 0 #file .set index
    l = 0 #total folder 
    k = 0 #new folder index, jika hanya menggunakan 9 folder
    for folder in os.scandir(directory):
        path_folder = str(Path(folder)) #path to folder
        files_set = glob.glob(path_folder+ "\*"+format) #set of dataset files in folder with .set format
        for file in files_set:
            if file.endswith(str(j)+format) == True: 
                k = round(j/1.9) #jika hanya menggunakan 9 folder
                file_name = os.path.basename(file)
                target = dst+"\\"+str(k)+"\\"+file_name 
                shutil.copyfile(file, target)
                #print('Moved:', file_name) #track (optiona)
                j += 1
            else:
                print("files tidak lengkap \nterhenti di: ", file)
                break
        if j < 16: #k != 8
            print("tidak terdapat data ke", j)
            print("Lengkapi file!")
            break 
        else: 
            j = 0
            print("Moved: ", folder)
            l += 1
    print("Total folder "+format+ " yang telah dipindahkan: ", l)
    print("  ")

main(".set")
main(".fdt")

os.system('pause')



    
