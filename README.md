# chem-type

This is an app for iOS that allows the user to hand draw a chemical molecule and uses OCR techniques to recognize it and allow the user to save the typeset image (from ChemDraw) of the molecule. 

Descriptions of the scripts:

image_reader.py: the pre-processing script for the training data. Reads in the images from disk, converts to grayscale, denoises, compresses, and saves the compressed images and a .csv file for Azure ML. An example training data image is provided. Instructions for use are in the script.

We use the almofire and toucan framework within our application. Almofire makes Json parsing easier, and it removes extraneous work that might need to be done. Toucan is a framework that helps us pre-process the use drawn image before sending it to our machine learning algorithm. 

drawViewController.swift: holds all of the code for pre-processing and reading/writing Json. This takes care of color correction, scaling, and parsing.

drawView.swift: contains all of the code for the user drawing. It can also be usd to change the thickness of the brush.

processedViewController.swift: takes the image selected my the machine learning algorithm and compares it to values in a dictionary. That image is displayed and can be saved.

