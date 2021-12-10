#!/bin/bash

###############################################################
# Check correct usage
if [ "$0" = "$BASH_SOURCE" ]; then # checks if the script is being executed not sourced
    echo "Usage: source Zn_docking.sh <protein_cleaned.pdb>"
    exit 1
fi

# Check if the protein argument is passed
if [ $# != 1 ] 
   then
   echo "Usage: source Zn_docking.sh <protein_cleaned.pdb>"
   return 
fi

###############################################################
# Protein preparation
conda activate vina
echo Starting Zn docking
sleep 2
echo Preparing receptor 
sleep 2
# Piping
# -d >> delimiter
# -f >> fields selection
protein_clean=`echo $1 | cut -d '.' -f 1`

python2 prepare_receptor4.py -r $1 -o protein.pdbqt
python2 zinc_pseudo.py -r protein.pdbqt -o protein_tz.pdbqt

# Box dimensions
# -p prompt: Print the string prompt, without a newline, before beginning to read
echo
echo Enter box dimensions
read -p "x_dimension: " x_dimension
read -p "y_dimension: " y_dimension
read -p "z_dimension: " z_dimension
read -p "x_center: " x_center
read -p "y_center: " y_center
read -p "z_center: " z_center

###############################################################
# Prepare ligand
for ligand in $(ls *.sdf); do
    # Piping
    # -d >> delimiter
    # -f fields selection
    ligand_clean=`echo $ligand | cut -d '.' -f 1`

# -d $FILE >> $FILE exists and is a directory
if [ -d $ligand_clean ]; then
rm -r $ligand_clean;
fi

mkdir $ligand_clean
cd $ligand_clean

# -f FILE >> $FILE exists and is a regular file
if [ -f '$ligand_clean.pdbqt' ]; then
rm $ligand_clean.pdbqt;
fi
echo
echo Preparing ligand: $ligand_clean

mk_prepare_ligand.py -i ../$ligand -o $ligand_clean.pdbqt
# -e $FILE >> $FILE exists
if [ -e `pwd`/$ligand_clean.pdbqt ]
then 
echo Ligand $ligand_clean is prepared
else
echo Ligand $ligand_clean is not prepared
fi

cp ../protein_tz.pdbqt .
cp ../AD4Zn.dat .
echo
echo Generating affinity maps
sleep 3

python2 ../prepare_gpf4zn.py -l $ligand_clean.pdbqt -r protein_tz.pdbqt -o protein_tz.gpf -p npts=$x_dimension,$y_dimension,$z_dimension -p gridcenter=$x_center,$y_center,$z_center –p parameter_file=AD4Zn.dat

cp ../autogrid4 .
./autogrid4 -p protein_tz.gpf

echo
echo Starting docking of $ligand_clean with $protein_clean
sleep 4
cp ../vina_1.2.3_linux_x86_64 .
./vina_1.2.3_linux_x86_64 --ligand $ligand_clean.pdbqt --maps protein_tz --scoring ad4 --out $protein_clean\_$ligand_clean\_docked.pdbqt 
# 5edu_clean_TSN1_docked.pdbqt
echo Docking of $ligand_clean finished
sleep 2
cd ..
done
echo \#########
echo  FINISHED!
echo \#########
###############################################################
# Docking



#yes | sudo apt install openbabel
# (sleep 10; echo y; sleep 2; echo n;...) | /opt/MNG/MNGVIEWHP/fe/uninstall
# printf '%s\n' y n n y y n...

