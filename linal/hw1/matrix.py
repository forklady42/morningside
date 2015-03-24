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

	def square(self):
		n = len(self.matrix)
		square = Matrix()
		for i in range(n):
			row = []
			for j in range(n):
				a = 0
				for k in range(n):
					a += self.matrix[i][k] * self.matrix[k][j]
				row.append(a)
			square.matrix.append(row)
		return square
