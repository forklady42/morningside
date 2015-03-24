""" Homework 3 Betsy Cannon """
import sys
from matrix import *

def main(input_file, output_file):
	f_in = open(input_file, 'r')
	m = int(f_in.readline())
	n = int(f_in.readline())
	Ab = Matrix(m, n, f_in)		# Augmented matrix A
	f_out = open(output_file, 'w')

	error = Ab.matrix_elimination()
	if not error:
		Ab.back_elimination()
		f_out.write(' '.join(map(str, Ab.particular_solution())) + '\n')
		for spec_soln in Ab.null_space():
			f_out.write(' '.join(map(str, spec_soln)) + '\n')
	else:
		f_out.write(error)

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])