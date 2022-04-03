extends Node2D

var number=-1 setget set_number
var color=Color(1,1,1,1) setget set_color

func set_number(n):
	number=n
	$CenterContainer/Number.set_text(str(number))

func set_color(c):
	color=c
	$Color.set_modulate(color)
