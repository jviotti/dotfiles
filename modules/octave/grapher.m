#!/usr/bin/env octave -qf
arguments = argv();

if (length(arguments) == 0)
  fprintf(2, 'Usage: grapher.m <csv>\n')
  exit(1)
endif

argument_file = arguments{1, 1};

if (length(arguments) >= 2)
  argument_title = arguments{2, 1};
else
  argument_title = "Example";
endif

file_descriptor = fopen(argument_file, 'r');
header = strsplit(fscanf(file_descriptor, '%s,%s'), ',');
fskipl(file_descriptor, 1);
data = csvread(file_descriptor);
fclose(file_descriptor); 

axis_x = data(:, 1);
axis_y = data(:, 2);

plot(axis_x, axis_y)
title(argument_title)
xlabel(header{1, 1})
ylabel(header{1, 2})
grid on
print -dsvg output.svg
