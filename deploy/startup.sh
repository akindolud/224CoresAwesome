#!/bin/sh

# Update the packages on the vm
echo "Updating packages "
sudo apt-get update

# Install required software on the vm
# Install python3
sudo apt-get install python3

# Install python3 pip, numpy and pandas
sudo apt-get install python3-pip
pip3 install numpy -y
pip3 install pandas -y

# Install and setup OpenFOAM and Paraview
sudo sh -c "wget -O - https://dl.openfoam.org/gpg.key | apt-key add -"
sudo add-apt-repository http://dl.openfoam.org/ubuntu
sudo apt-get update
sudo apt-get -y install openfoam7

cat >> ~/.basrc <<EOF
source /opt/openfoam7/etc/bashrc
EOF

source $HOME/.bashrc

mkdir -p $FOAM_RUN

# Install and setup Gmsh
sudo apt update
sudo apt install gmsh

# Install Salome
wget "https://www.salome-platform.org/downloads/current-version/DownloadDistr?platform=SP.UB18.04&version=9.4.0"
tar xfz SALOME-9.4.0-CO7-SRC.tgz

cat >> ~/.basrc <<EOF
export ~/SALOME-9.4.0-CO7-SRC
EOF
source $HOME/.bashrc

sudo chmod +x ~/SALOME-9.4.0-CO7-SRC/salome

cat >> ~/.basrc <<EOF
export PATH="~/SALOME-9.4.0-CO7-SRC/:$PATH"
EOF
source $HOME/.bashrc
