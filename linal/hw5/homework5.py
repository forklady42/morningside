""" Homework 5 Betsy Cannon """
from math import ceil, sqrt
import random
from matrix import *

def main():

	# Hardcoded because might as well save the slight work of importing it each time
	A = Matrix([[2.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[-1.0, 2.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, -1.0, 2.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, -1.0, 2.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, -1.0, 2.0, -1.0, 0.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, -1.0, 2.0, -1.0, 0.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 2.0, -1.0, 0.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 2.0, -1.0, 0.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 2.0, -1.0],
				[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 2.0]], 10, 10)

	eprox = A.inverse().power_method(random_v(10), 0.1, 5)
	return 1/eprox

def random_v(m):
		# build v0 from random numbers, then normalize

		rows = []
		norm_sum = 0
		for i in range(m):
			rand = random.random()
			rows.append([rand])
			norm_sum += rand*rand

		norm_sum = sqrt(norm_sum)
		for i in range(m):
			rows[i][0] = rows[i][0]/norm_sum

		return Matrix(rows, m, 1)

if __name__ == '__main__':
	print main()