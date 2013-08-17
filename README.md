Book crossing labels for Technologia Incognita bookshelf
========================================================

Required packages (Ubuntu): texlive-xetex texlive-latex-recommended texlive-latex-extra  
  
Usage for label
----------------
./bookcrossing-labels.pl [options]  
  
Options
-------
  -template template.tex  (default: bookcrossing-template.tex, the string 'BCID-HERE' will be replaced by the bcid's given in the next file)  
  -bcid     bcids.txt     (required, list with BCID codes)  
  -lprname  techinc-label (name you gave to the printer, default: techinc-label)
  -print                  (set this flag if you want to print to the label printer)

Description
-----------
Generate and print book crossing labels for Technologia Incognita, using a latex template file and a list with BCID codes. This can be send to a label printer.
  
Example: $0 -bcid example-bcid.txt -lprname myprinter -print

Small labels
------------
small-labels.ps is a label with small TechInc icons. These can be used to stick on the cover of labelled books.

print: lpr -P myprinter small-labels.ps

