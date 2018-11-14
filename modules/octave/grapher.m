#!/usr/bin/env octave -qf
arguments = argv();

if (length(arguments) == 0)
  fprintf(2, 'Usage: grapher.m <csv>\n\n')
  fprintf(2, 'Options:\n')
  fprintf(2, '  -o <output>         Output location\n')
  fprintf(2, '  -t <title>          Graph title\n')
  fprintf(2, '\nThe csv file should look like this:\n\n')
  fprintf(2, '  TIME,CPU\n')
  fprintf(2, '  1000,25\n')
  fprintf(2, '  2000,28\n')
  fprintf(2, '  3000,30\n')
  exit(1)
endif

argument_file = arguments{1, 1};
option_output = "output.svg";
option_title = "Example";

for index = 2:length(arguments)
  argument = arguments{index, 1};
  if (strcmp(argument, "-o") == 1 && index + 1 <= length(arguments))
    option_output = arguments{index + 1, 1};
  endif
  if (strcmp(argument, "-t") == 1 && index + 1 <= length(arguments))
    option_title = arguments{index + 1, 1};
  endif
endfor

printf("File = %s\n", argument_file)
printf("Output = %s\n", option_output)
printf("Title = %s\n", option_title)

file_descriptor = fopen(argument_file, 'r');
header = strsplit(fscanf(file_descriptor, '%s,%s'), ',');
fskipl(file_descriptor, 1);
data = csvread(file_descriptor);
fclose(file_descriptor);

axis_x = data(:, 1);
axis_y = data(:, 2);

plot(axis_x, axis_y)
title(option_title)
xlabel(header{1, 1})
ylabel(header{1, 2})
grid on
print(option_output, '-dsvg')
