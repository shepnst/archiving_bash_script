The structure of lab work on bash scripts:
1) create_vd_script.sh - this script create a virtual disk with limited size that you can choose(Mb) and mount it 
./create_limited_folder SIZE

2) main_script.sh - this script is for arhivation files. It calculates the size of the folder that you entered and percent of fulnessness. Then it archivate n oldest files and put the archive into /backup folder. After archivating, the script is deleting these n files. 
Sample:
./main_script.sh FOLDER_PATH  %_of_fullness

3) test_script.sh - this script is for testing the main script - how archivation works. There are functions for creating virtual disk, cleaning directories /log and /backup, generating n files with .log extension, running main script and tests for it. 
Sample for running test_script.sh:
sudo ./test_script.sh 1000 50
