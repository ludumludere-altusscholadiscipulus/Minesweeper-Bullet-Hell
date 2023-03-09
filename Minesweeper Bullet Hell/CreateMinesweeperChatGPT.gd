extends Node
# Define the size of the game board
var ROWS = 10
var COLS = 10

# Define the number of mines to be placed on the board
var NUM_MINES = 10

# Create the game board
var board = []

func _ready():
	init_board()
	print_board()

# Create a function to initialize the game board
func init_board():
	# Create an empty board
	for row in range(ROWS):
		board.append([])
		for col in range(COLS):
			board[row].append(0)
	
	# Place mines randomly on the board
	var num_mines_placed = 0
	while num_mines_placed < NUM_MINES:
		var row = randi() % ROWS
		var col = randi() % COLS
		
		# If there is already a mine at this location, continue to the next location
		if board[row][col] == -1:
			continue
		
		# Otherwise, place a mine at this location
		board[row][col] = -1
		num_mines_placed += 1
		
		# Increment the count of adjacent squares
		for r in range(max(0, row - 1), min(ROWS, row + 2)):
			for c in range(max(0, col - 1), min(COLS, col + 2)):
				if board[r][c] != -1:
					board[r][c] += 1

# Create a function to display the board
func print_board():
	for row in board:
		var row_string = ""
		for col in row:
			if col == -1:
				row_string += "* "
			else:
				row_string += str(col) + " "
		print(row_string)
