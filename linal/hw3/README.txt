This program solves for the complete solution to Ax=b for a given matrix A and vector b. First elimination is performed by looping through each row and reducing the remaining rows so that there is a zero below the pivot in every row. While performing elimination, the pivots and the free columns are marked for future use. If in elimination we find that a zero row of A is paired with a non-zero value in b, the program returns "No solution".

In the case that a solution exists, backwards elimination applied next by beginning with the last row and iterating up to the top of the matrix. By then normalizing each row with respect to its pivot, we find the reduced row echelon form (RREF).

From the RREF, we find the particular solution by setting all of the variables associated with free columns to zero and then reading off the values of b for the remaining elements.

To find the special solutions, the program iterates through the free columns, setting each one in turn to be 1.0 while holding the others zero, and computes the remaining variables by taking the negative of the corresponding element in the current free column.

The program expects an input file format is as specified in the assignment. The first line should be m, the number of rows in A. The second line should be n, the number of columns of A. Then, the next m rows should list one row of A per line. The final m rows should be the elements of b, with one element per line.

To run the program from the directory with the files, simply type in the command line:
python homework3.py input_file output_file

The resulting solution will be written to the specified output_file. In the case of no solution, the file will read "No solution". In all other cases, the output file will have the particular solution on the first rows and all other rows will be the special solutions spanning the null space. Of course, in the case that there is exactly one solution, the null space is only the zero vector and there are no special solutions. Then, only the particular solution will be included in the output file.

Examples and their output:
no_soln.txt			no_result.txt
one_soln.txt		one_result.txt
infinite_solns.txt	infinite_results.txt

------------
Betsy Cannon
2013-10-31