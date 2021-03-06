class Matrix:
	"""General matrix class for Betsy Cannon"""

	def __init__(self, m, n, file = None):
		self.matrix = []
		self.m = m
		self.n = n
		if file:
			for i in range(self.m):
				self.matrix.append(map(float, file.readline().split()))
			for i in range(self.m):
				self.matrix[i].append(float(file.readline()))
		self.pivots = []	# index by row
		self.free = set()

	def __str__(self):
		return str(self.matrix)

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





