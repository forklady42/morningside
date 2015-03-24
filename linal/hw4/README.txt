This program takes the parameters of a parabola y = C + Dt + Et*t and a desired number of data points, m, and creates a perturbed data set following the parabola, similar to what you would measure in an experiment.

To create the perturbed data set, I used m half steps centered around the t=0. To each y corresponding to a given t, I randomly added or subtracted (determined by integer powers of -1) random numbers from 0 to 1. These became the b values.

After creating the data, the program computes A_trans*A and A_trans*b. Since the forms of the matrices are already known (i.e. A_trans*A = [[t^4 t^3 t^2],[t^3, t^2, t],[t^2, t, m]] and A_trans*b = [t^2*y, t*y, y]), the values are simply plugged into the matrix and vector. In order to solve A_trans*Ax = A_trans*b, we create an augmented matrix [A_trans*Ax|A_trans*b]. Then, elimination is applied and the particular solution read off as the computed C, D, and E. (Note: all of these matrices should be non-singular so the null space will only be the zero vector. Thus, there is only one solution for C, D, and E.)

To run the program from the directory with the files, simply type in the command line:
python homework4.py input_file output_file

The input_file should have the m, the number of data points, on the first line, C on the second, D on the third, and E on the fourth where C, D, E are the parameters of the parabola y = C + Dt + Et*t.

The resulting solution will be both printed to the terminal and written to the specified output_file. The output file will have the computed C on the first line, D on the second line, and E on the third line.

------------
Betsy Cannon
2013-11-14