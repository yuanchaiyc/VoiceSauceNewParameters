# VoiceSauce with new parameters and modified formant correction formula
README

The codes are adapted from https://phonetics.ucla.edu/voicesauce/. VoiceSauce is developed by Shue, Y.-L., P. Keating , C. Vicenik, K. Yu (2011). Yuan Chai do not claim copyright on the codes written by Shue et al (2011). The parameters added by Yuan Chai are H3, H1K, H1K5, H3K, H4K; the formant correction values for all spectral parameters; the harmonic frequencies of H1K, H1K5, H2K, H3K, H4K, H5K; and the bandwidth of each formant.

Steps of using this VoiceSauce script:
1. Unzip the folder
2. Please download Praat from their official website and paste Praat.exe into the Praat folder;
3. Open the directory folder in Matlab
4. Open the “VoiceSauce.m”
5. Click "Run"
6. Right now, “Formants and Bandwidth” only support “Praat” option. If you select “Snack” option, it will throw an error when outputting the text file. The code for “Snack” option is underway.
