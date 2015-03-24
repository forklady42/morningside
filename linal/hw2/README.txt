This program solves Ax=b for a given band matrix A and vector b. First elimination is performed by looping through each row and reducing the next k/2 rows (k is the band size) so that there is a zero below the pivot. Only the first loop is bounded by n. The loop to place zeros below the current pivot is bounded by k/2, and the loop to update the full row is bounded by k.

After elimination, back substitution is performed by beginning with the last row and iterating up to the top of the matrix. Again, we take advantage of k and only use k/2 values per row to compute the solution.

The program expects an input file format similar to the first homework. The first line should be n, the dimension of A. The second line should be k, the size of the band (eg k=3 for a tridiagonal matrix). Then, the augumented matrix [Ab] should list one row per line for the next n lines. If you have any questions, see test3-3.txt for an example file with n=3 and k=3.

To run the program from the directory with the files, simply type in the command line:
python homework2.py input_file output_file

The resulting solution x will be written on one line in the specified output_file.

------------
Betsy Cannon
2013-10-08