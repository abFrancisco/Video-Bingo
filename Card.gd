extends GridContainer

enum Orientation{HORIZONTAL,VERTICAL}
var number_cell_scene=preload("res://NumberCell.tscn")


var size:Vector2=Vector2(5,3)
var orientation:int=Orientation.HORIZONTAL
var number_range:int=-1
var cells:Array=[]
var blank=false

func _ready():
	get_parent().update()

func setup(s:Vector2,o:int,nr:int,b:bool):
	size=s
	orientation=o
	number_range=nr
	blank=b
	randomize()
	set_columns(size.x)
	generate_cells()

func generate_numbers():
	var numbers:Array=[]
	if blank:
		for y in size.y:
			var row:Array=[]
			for x in size.x:
				row.append(-1)
			numbers.append(row)
		return numbers
	var rng_helper:Array=[]
	for i in number_range:
		rng_helper.append(i+1)
	var random_numbers:Array=[]
	
	for i in (size.x*size.y):
		random_numbers.append(rng_helper.pop_at(randi()%rng_helper.size()))
	random_numbers.sort()
	if orientation==Orientation.HORIZONTAL:
		for y in size.y:
			var row:Array=[]
			for x in size.x:
				row.append(random_numbers[x + y*size.x])
			numbers.append(row)
	else:
		for y in size.y:
			var row:Array=[]
			for x in size.x:
				row.append(random_numbers[x*size.y + y])
			numbers.append(row)
	print(str(numbers))
	return numbers

func generate_cells():
	var numbers=generate_numbers()
	for y in size.y:
		var row:Array=[]
		for x in size.x:
			var cell=number_cell_scene.instance()
			cell.number=numbers[y][x]
			add_child(cell)
			row.append(cell)
		cells.append(row)

func mark(n:int)->bool:
	for row in cells:
		for cell in row:
			if cell.number==n:
				cell.mark()
				return true
	return false

""" WIP
func check_rows():
	var rows=0
	for y in size.y:
		var counter=0
		for x in size.x:
			if cells[y][x].marked:
				counter+=1
		rows+=1
	return rows

func check_lines():
	var lines=0
	for x in size.x:
		var counter=0
		for y in size.y:
			if cells[y][x].marked:
				counter+=1
		lines+=1
	return lines
"""

func reset():
	for row in cells:
		for cell in row:
			cell.number=-1
			if cell.marked:
				cell.mark()
