extends Node2D

const cell_scene: PackedScene = preload("res://scenes/cell.tscn")
var cells: Array[Array]
var height: int = 20
var width: int = 40
var tick: int = 0
var tickmod: int = 5
var play: bool = false


func _ready() -> void:
	new_grid()


func _physics_process(_delta: float) -> void:
	if play:
		if tick == 0:
			tick_grid()
		tick = (tick + 1) % tickmod


func new_grid() -> void:
	height = %height.value
	width = %width.value
	play = false
	%play.text = "play"
	for i in get_children():
		i.queue_free()
	cells.clear()
	cells.resize(height)
	for i in height:
		cells[i].resize(width)
		for j in width:
			var new_cell: Cell = cell_scene.instantiate()
			new_cell.position = Vector2(j * 32, i * 32)
			add_child(new_cell)
			cells[i][j] = new_cell
	for i in height:
		for j in width:
			for k in [-1, 0, 1]:
				for l in [-1, 0, 1]:
					if (0 <= i + k and i + k < height) and (0 <= j + l and j + l < width) and not (k == 0 and l == 0):
						cells[i][j].neighbors.append(cells[i + k][j + l])
	if width * 1.0 / height > 2.0:
		scale = Vector2(1920.0 / (32 * width), 1920.0 / (32 * width))
	else:
		scale = Vector2(960.0 / (32 * height), 960.0 / (32 * height))


func randomize_grid() -> void:
	for i in height:
		for j in width:
			cells[i][j].on = randi_range(0, 1) == 1
			cells[i][j].recolor()


func tick_grid() -> void:
	Cell.birth.clear()
	for i in %bnums.text:
		Cell.birth.append(int(i))
	Cell.survive.clear()
	for i in %snums.text:
		Cell.survive.append(int(i))
	for i in height:
		for j in width:
			cells[i][j].tick()
	for i in height:
		for j in width:
			cells[i][j].on = cells[i][j].next
			cells[i][j].recolor()


func toggle_grid() -> void:
	play = not play
	%play.text = ("play" if not play else "stop")


func change_speed(val: float) -> void:
	tickmod = int(32 - val)
