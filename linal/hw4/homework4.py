""" Homework 4 Betsy Cannon """
import sys
from math import ceil
import random
from matrix import *

def main(input_file, output_file):
	f_in = open(input_file, 'r')
	m = int(f_in.readline())
	C = float(f_in.readline())
	D = float(f_in.readline())
	E = float(f_in.readline())

	(t, b) = create_randomized_data(m, C, D, E)
	(ATA, ATb, augmented) = fit_parabola(m, t, b)

	([E, D, C], null) = augmented.solve()
	print "C:", C
	print "D:", D
	print "E:", E

	f_out = open(output_file, 'w')
	f_out.write('\n'.join(map(str, [C, D, E])))


def create_randomized_data(m, C, D, E):
	# Take in number of data points, m, and C, D, E the parameters of parabola y = C + Dt + Et*t

	ts = []
	bs = []

	# Split t's evenly along the y-axis and increment by half steps 
	# (python's range function doesn't do half steps so divide by 2 in the loop)
	for t in range(-m/2 + 1, m/2 + 1, 1):
		t = t/2.0
		y = C + D*t + E*t*t
		y += (-1)**random.randint(1,2) * random.random()
		ts.append(t)
		bs.append(y)

	return ts, bs

def fit_parabola(m, t, b):
	# t should be a listed of equally spaced time values and 
	# b should be the corresponding list (same order) of perturbed y values

	# for a parabola, so A_trans * A will be 3 by 3
	t_4 = sum(map(lambda x: x**4, t))
	t_3 = sum(map(lambda x: x**3, t))
	t_2 = sum(map(lambda x: x**2, t))
	t_1 = sum(t)

	ATA = [[t_4, t_3, t_2], [t_3, t_2, t_1], [t_2, t_1, m]]

	t_2b = sum(map(lambda x,y: x**2 * y, t, b))
	t_1b = sum(map(lambda x,y: x * y, t, b))
	t_0b = sum(map(lambda y: y, b))

	ATb = [t_2b, t_1b, t_0b]

	augmented = Matrix([[t_4, t_3, t_2, t_2b], [t_3, t_2, t_1, t_1b], [t_2, t_1, m, t_0b]], 3, 3)

	# could have just skipped straight to the augmented version and only returned that
	# but I wanted to show what ATA and ATb's forms
	return ATA, ATb, augmented


if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])