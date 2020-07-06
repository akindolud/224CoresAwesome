#!/bin/bash

# Source ~/.bashrc
echo "---------------------------------------------------------------------"
echo "Adding OpenFOAM bashrc to system bashrc"
echo "---------------------------------------------------------------------"
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
