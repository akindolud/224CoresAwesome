#!/bin/sh

# Update the packages on the vm
echo "---------------------------------------------------------------------"
echo "Updating packages "
echo "---------------------------------------------------------------------"
sudo apt-get update

# Install required software on the vm
# Install python3
echo "---------------------------------------------------------------------"
echo "Installing python3"
echo "---------------------------------------------------------------------"
sudo apt-get install -y python3

# Install python3 pip, numpy and pandas
echo "---------------------------------------------------------------------"
echo "Installing pip3, numpy and pandas"
echo "---------------------------------------------------------------------"
sudo apt-get install -y python3-pip
sudo pip3 install numpy
sudo pip3 install pandas

# Install and setup OpenFOAM and Paraview
echo "---------------------------------------------------------------------"
echo "Installing OpenFOAM 7"
echo "---------------------------------------------------------------------"
sudo sh -c "wget -O - https://dl.openfoam.org/gpg.key | apt-key add -"
sudo add-apt-repository http://dl.openfoam.org/ubuntu
sudo apt-get update
sudo apt-get install -y openfoam7

echo "---------------------------------------------------------------------"
echo "Adding OpenFOAM bashrc to system bashrc"
echo "---------------------------------------------------------------------"
cat >> ~/.bashrc <<EOF
source /opt/openfoam7/etc/bashrc
EOF
source ~/.bashrc

# run simpleFoam -help command to confirm OpenFOAM is set up properly
echo "---------------------------------------------------------------------"
echo "Now running a simple OpenFOAM command to verify installation"
echo "---------------------------------------------------------------------"
simpleFoam -help

# Setup directory for OpenFOAM tutorials
echo "---------------------------------------------------------------------"
echo "Now setting up user directories for OpenFOAM tutorials"
echo "---------------------------------------------------------------------"
mkdir -p $FOAM_RUN
cd $FOAM_RUN
cp -r $FOAM_TUTORIALS/incompressible/simpleFoam/pitzDaily .
cd pitzDaily
blockMesh
simpleFoam

# Install and setup Gmsh
echo "---------------------------------------------------------------------"
echo "Installing gmsh"
echo "---------------------------------------------------------------------"
sudo apt-get update
sudo apt-get install -y gmsh
