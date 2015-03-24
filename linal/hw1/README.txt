This program computes A^2^k for a given matrix A and int k using k matrix multiplications.

As matrix multiplication is associative and we are guaranteed a power of 2 exponent, it is possible to square A k times to find the desired result (e.g. A^2^3 = (A^2)^2)^2), so square A, then square that result, and then square that result to find A^2^3).

To run the program from the directory with the files, simply type in the command line:
python homework1.py input_file output_file

The resulting matrix will be stored in the specified output_file.

------------
Betsy Cannon
2013-09-24