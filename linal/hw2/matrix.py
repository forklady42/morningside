class Matrix:
	"""General matrix class for Betsy Cannon"""

	def __init__(self, file = None):
		self.matrix = []
		if file:
			for row in file:
				self.matrix.append(map(float, row.split()))

	def __str__(self):
		return str(self.matrix)

	def write_to_file(self, file):
		for row in self.matrix:
			file.write(' '.join(map(str, row)) + '\n')

	def band_matrix_elimination(self, n, m):
		# Elimination with no row exchanges
		# m is size of band

		# iterate through each row, except the last one
		for k in range(n-1):
			# Check if pivot is zero
			if self.matrix[k][k] == 0:
				print "Pivot may not be zero."
				return False

			# Only need to update (m-1)/2 rows below, unless of course it's at the end of the matrix. 
			# After that it's zero.	
			if (k + (m-1)/2 + 1 < n):
				max = k + (m-1)/2 + 1
			else:
				max = n
			for i in range(k+1, max):

				# only need to update m values per row max
				if (k + m - 1 < n):
					j_max = k + m - 1
				else:
					j_max = n
				for j in range(k+1, j_max):
					self.matrix[i][j] = self.matrix[i][j] - (self.matrix[i][k]/self.matrix[k][k]) * self.matrix[k][j]
				#also update b
				self.matrix[i][n] = self.matrix[i][n] - (self.matrix[i][k]/self.matrix[k][k]) * self.matrix[k][n]

		return True

	def back_substitution(self, n, m):
		# To be applied after elimination of a band matrix
		# m is size of band

		soln = n*[0]
		for k in range(n-1, -1, -1):
			soln[k] = self.matrix[k][n]

			# Only need to consider (m-1)/2 values after the pivot, unless of course it's at the end of the row. 
			# After that it's zero.
			if (k + (m-1)/2 + 1 < n):
				max = k + (m-1)/2 + 1
			else:
				max = n
			for i in range(k+1, max):
				soln[k] = soln[k] - self.matrix[k][i] * soln[i]
			soln[k] = soln[k]/self.matrix[k][k]

		return soln




