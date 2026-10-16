extends Node2D

#@onready var tower = 
var radius = 250
var circleColor = Color(1,1,1,0.6)
@export var pointCount = 64
@export var width = 2.0


func _ready() -> void:
	getRadius()

func _draw() -> void:
	draw_arc(
		Vector2.ZERO,
		radius,
		0,
		TAU,
		pointCount,
		circleColor,
		width
	)
	
	var fillColor = Color(1,1,1,0.12)
	draw_circle(Vector2.ZERO, radius, fillColor)

func getRadius() -> void:
	radius = get_parent().attackRange
	if get_parent().scale.x != 0:
		radius = radius / get_parent().scale.x

func updateAttackRange() -> void:
	getRadius()
	queue_redraw()
