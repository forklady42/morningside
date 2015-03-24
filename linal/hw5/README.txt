This program computes the smallest eigenvalue of the specified matrix using the inverse iteration method. To do this, I implemented Gauss-Jordan elimination to find the inverse of the matrix. Then, using the inverse, I applied the power method and took the inverse of the eigenvalue that it converged to. As the seed vector, vO, I used python's random number generator to create a vector and then normalized it. Since the vector is chosen randomly, there is a very low probability that it is orthogonal to the first eigenvector.

The sequence converges quickly, so I capped the iterations at 5. I also tested with 15 and found that it always converged to the same number to 10 significant figures.


To run the program from the directory, simply type in the command line:
python homework5.py
and it will output the smallest eigenvalue.

------------
Betsy Cannon
2013-12-05