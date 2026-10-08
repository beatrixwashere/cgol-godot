class_name Cell
extends Node2D

var on: bool = false
var next: bool = false
var neighbors: Array[Cell]

static var birth: Array[int] = [3]
static var survive: Array[int] = [2, 3]


func tick() -> void:
	var count: int = 0
	for i in neighbors:
		if i.on:
			count += 1
	if on:
		for i in survive:
			if count == i:
				next = true
				return
		next = false
	else:
		for i in birth:
			if count == i:
				next = true
				return
		next = false


func recolor() -> void:
	if on:
		$state.color = Color.WHITE
	else:
		$state.color = Color.BLACK


func toggle() -> void:
	on = not on
	recolor()
