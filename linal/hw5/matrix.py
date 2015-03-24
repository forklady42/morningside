from math import sqrt

class Matrix:
	"""General matrix class for Betsy Cannon"""

	def __init__(self, rows, m, n):
		# n and m are diminsions of unaugmented matrix

		self.matrix = rows
		self.m = m
		self.n = n
		self.pivots = []	# index by row
		self.free = set()

	def __str__(self):
		return str(self.matrix)

	def __sub__(self, other):

		rows = []
		for i in range(self.m):
			row = []
			for j in range(self.n):
				row.append(self.matrix[i][j] - other.matrix[i][j])
			rows.append(row)

		return Matrix(rows, self.m, self.n)

	def write_to_file(self, file):
		for row in self.matrix:
			file.write(' '.join(map(str, row)) + '\n')

	def matrix_elimination(self, direction=1):
		# Elimination with row exchanges
		# Allows for zero rows and/or free columns.

		# iterate through each row, except the last one
		col = 0;
		for k in range(self.m):

			# Check if pivot is zero. Swap rows if necessary.
			while col < self.n and self.matrix[k][col] == 0:
				row = k;
				while row < self.m and self.matrix[row][col] == 0:
					row+=1

				if row < self.m:
					temp_row = self.matrix[k]
					self.matrix[k] = self.matrix[row]
					self.matrix[row] = temp_row
				else:
					# If we're at the end of the row, must be a zero row. Otherwise, keep going.
					if col < self.n:
						self.free.add(col)
						col+=1

			if col < self.n:
				self.pivots.append(col)

				# update rows below
				for i in range(k+1, self.m):

					# update columns to the right, including b
					for j in range(col+1, self.n+1):
						self.matrix[i][j] -= (self.matrix[i][col]/self.matrix[k][col]) * self.matrix[k][j]

					#And the columns to the left
					for j in range(col+1):
						self.matrix[i][j] = 0.0
			else:
				if self.matrix[k][self.n] != 0:
					return "No solution"
				self.pivots.append(None)
			
			col+=1

		# if we ran out of rows before we ran out of columns, the rest of the columns must be free
		for f in range(col, self.n):
			self.free.add(col)
			col+=1

		return


	def back_elimination(self):
		# Backwards elimination and normalization to get RREF.

		for row in range(self.m-1, -1, -1):
			pivot = self.pivots[row]
			
			if pivot == None:
				continue

			#update rows above
			for i in range(row-1, -1, -1):

				#update columns to right, including b
				for j in range(self.n, pivot-1, -1):
					self.matrix[i][j] -= (self.matrix[i][pivot]/self.matrix[row][pivot]) * self.matrix[row][j]

			#normalize
			for j in range(pivot+1, self.n+1):
				self.matrix[row][j] /= self.matrix[row][pivot]
			self.matrix[row][pivot] = 1.0

	def null_space(self):
		# takes RREF and outputs the basis of the null space aka the special solutions.

		spec_solns = []
		for col in self.free:
			soln = [0.0] * self.n
			soln[col] = 1.0

			for var in range(self.m):
				if self.pivots[var] is not None:

					# python has a weird quirk where -1*0.0 = -0.0; I'm avoiding that.
					if self.matrix[var][col] != 0.0:
						soln[var] = -1 * self.matrix[var][col]
			spec_solns.append(soln)

		return spec_solns

	def particular_solution(self):
		# takes RREF and finds a particular solution

		soln = [0.0] * self.n
		#for col in self.pivots:
		for i in range(self.m):
			if self.pivots[i] is not None:
				soln[self.pivots[i]] = self.matrix[i][self.n]

		return soln

	def solve(self):
		# matrix should already be augmented with b

		error = self.matrix_elimination()
		if not error:
			self.back_elimination()
			particular = self.particular_solution()
			null = self.null_space()
			return particular, null

	def transpose(self):

		transpose = []
		for j in range(self.n):
			row = []
			for i in range(self.m):
				row.append(self.matrix[i][j])
			transpose.append(row)
		return Matrix(transpose, self.n, self.m)

	def multiply(self, B):
		# multiplies two matrices with B on the right

		C = []
		for i in range(self.m):
			row = []
			for j in range(B.n):
				msum = 0
				for k in range(self.n):
					msum += self.matrix[i][k]*B.matrix[k][j]
				row.append(msum)
			C.append(row)

		return Matrix(C, self.m, B.n)

	def scalar_mult(self, scalar):

		C = []
		for i in range(self.m):
			row = []
			for j in range(self.n):
				row.append(self.matrix[i][j]*scalar)
			C.append(row)

		return Matrix(C, self.m, self.n)

	def norm(self):
		# finds the norm of a matrix
		return sqrt(self.transpose().multiply(self).matrix[0][0])

	def inverse(self):
		# Gauss-Jordan implementation

		rows = []
		for i in range(self.m):
			I_row = [0]*self.n
			I_row[i] = 1
			rows.append(self.matrix[i]+I_row)

		augmented = Matrix(rows, self.m, self.n*2-1) #matrix_elimination expects auguments matrix with one extra col than n, so subtracting that here
		augmented.matrix_elimination()
		augmented.back_elimination()

		for i in range(self.m):
			rows[i] = rows[i][self.n:]

		return Matrix(rows, self.m, self.n)

	def power_method(self, v0, epsilon, i_max):
		v = v0
		i = 0
		while i == 0 or ((self.multiply(v) - v.scalar_mult(mu)).norm() and i < i_max):
			y = self.multiply(v)
			y_norm = y.norm()
			for a in range(y.m):
				v.matrix[a][0] = y.matrix[a][0]/y_norm
			mu = v.transpose().multiply(self.multiply(v)).matrix[0][0]
			i+=1

		return mu






