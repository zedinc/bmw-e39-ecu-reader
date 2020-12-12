# bmw-e39-ecu-reader

Some hand-crafted utilities to help make sense of BMW E39 M5 DME binaries.


# Background

This is a collection of scripts and utilities I put together to help me explore and understand the nuances of the E39 M5's engine management system. This is by no means polished code, but it is useful for introspecting Motorola M68000 ECU's.

# What's what

- ECUReader.pm - convenience methods to make light work of processing the binary file
- Gnuplot.pm - rudimentary convenience utilities for preparing Gnuplot scripts from data
- Utils.pm - general-purpose convenience methods related to file processing and output

- plot_curve.pl - 
- tune_parser.pl - Parses ECU binary and prints out choice decoded information about the ECU tune
- servotronic_plot.pl - Reads ECU binary and outputs servotronic plots

- \*.gnu - GNU template files
- \*.t - test scripts

# Sample Output

![VANOS Intake Plot](https://1drv.ms/u/s!AklZePO7NxmWhM4YNYITbNILbRlY1A?e=BKXUHQ)
