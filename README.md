# BMW E39 5-Series ECU Reader

Some hand-crafted utilities to help make sense of BMW E39 M5 DME binaries.


# Background

This is a collection of scripts and utilities I put together to help me explore and understand the nuances of the E39 M5's engine management system. This is by no means polished code, but it is useful for introspecting Motorola M68000 ECU's.

# Sample Output

![VANOS Intake Plot](https://i.stack.imgur.com/mVM2L.png)

![MAF Plot](http://i.stack.imgur.com/ie4yK.png)

---

# What's what

## Utilities

- *ECUReader.pm*
  
  Convenience methods to make light work of processing the binary file

- *Gnuplot.pm*
  
  Rudimentary convenience utilities for preparing Gnuplot scripts from data

- *Utils.pm*
  
  General-purpose convenience methods related to file processing and output

## Scripts

- *address_scanner.pl*

  Script that "walks" over the ECU binary to identify potential addresses that start 1D, 2D data

- *heatmap.pl*
  
  Plots VANOS heat map

- *plot_curve.pl*
  
  Script to plot MAF curve

- *print_key_values.pl*
  
  Prints x,y,z triplets

- *tune_parser.pl*
  
  Parses ECU binary and prints out choice decoded information about the ECU tune

- *servotronic_plot.pl*
  
  Reads ECU binary and outputs servotronic plots

## Gnuplot Templates

- *\*.gnu*
  
  GNU template files

## Tests

- *\*.t*
  
  Test scripts
