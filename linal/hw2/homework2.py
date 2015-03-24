""" Homework 2 Betsy Cannon """
import sys
from matrix import *

def main(input_file, output_file):
	f_in = open(input_file, 'r')
	n = int(f_in.readline())
	k = int(f_in.readline())	# k-diagonal 
	A = Matrix(f_in)
	if (A.band_matrix_elimination(n, k)):
		soln = A.back_substitution(n, k)
		f_out = open(output_file, 'w')
		f_out.write(' '.join(map(str, soln)) + '\n')

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])