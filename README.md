# chem-type

This is an app for iOS that allows the user to hand draw a chemical molecule and uses OCR techniques to recognize it and allow the user to save the typeset image (from ChemDraw) of the molecule. 

Descriptions of the scripts:

image_reader.py: the pre-processing script for the training data. Reads in the images from disk, converts to grayscale, denoises, compresses, and saves the compressed images and a .csv file for Azure ML. An example training data image is provided. Instructions for use are in the script.

