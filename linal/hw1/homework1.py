# Solves A^2^k in O(k n^3) time (linear in k)
import sys
from matrix import *

def main(input_file, output_file):
	f_in = open(input_file, 'r')
	n = int(f_in.readline())
	k = int(f_in.readline())
	A = Matrix(f_in)
	exp_A = exponential(A, k)

	f_out = open(output_file, 'w')
	exp_A.write_to_file(f_out)

# Assumes the form A^2^k
def exponential(matrix, k):
	"""Since matrix multiplication is associative, this function simply squares 
		the squares until you reach the desired k"""
	if k == 1:
		return matrix.square()
	return exponential(matrix.square(), k - 1);


if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])