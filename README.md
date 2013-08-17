Book crossing labels for Technologia Incognita bookshelf
========================================================

_Status: all steps until creation of pdf and ps files are finished_

_To do: print to label printer_

Required packages (Ubuntu): texlive-xetex texlive-latex-recommended texlive-latex-extra  
  
Usage for label:  
  
Usage: ./bookcrossing-labels.pl [options]  
  
Options:  
  -template template.tex (default: bookcrossing-template.tex, the string 'BCID-HERE' will be replaced by the bcid's given in the next file)  
  -bcid     bcids.txt    (required, list with BCID codes)  
  -print                 (set this flag if you want to print to the label printer)
  
Generate and print book crossing labels for Technologia Incognita, using a latex template file and a list with BCID codes. This can be send to a label printer.
  
Example: $0 -bcid example-bcid.txt -print

