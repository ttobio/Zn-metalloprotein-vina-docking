# Zn-metalloprotein-vina-docking
A bash script to automate vina docking of small molecules to zinc metalloproteins

![thumbnail](https://user-images.githubusercontent.com/19835485/175773535-2696374d-e478-405b-90f8-8b43e726c7ab.png)

This is a bash script for automating virtual screening for a library of compounds by AutoDock vina docking with zinc metalloproteins, following the tutorial found in this YouTube playlist: https://youtube.com/playlist?list=PLP_iHNbRbB3ehqDGL5dcyxwTRoC3QAdBE

The contents of the bash script is explained in detail in this video: https://www.youtube.com/watch?v=nNB5LQEA0-k&list=PLP_iHNbRbB3ehqDGL5dcyxwTRoC3QAdBE&index=4&t=8s
# MY adjustments-  Emadeldin - 12.10.2024
1. editing the preparing protein part so that it doesn't delete the zinc atom from the pdb file (it did that in my case)
2. adding the exhastiveness argument to the docking command
3. adding >logfile.log for each ligand because we want to extract the binding affinity after docking
4. adding a new script (extracting_bf.sh) which collect all the .log files from a certain directory and produce two csv files one for all the BF for all poses and one for the top pose for each ligand.
