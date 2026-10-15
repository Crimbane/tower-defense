extends Node2D

#@onready var tower = 
var radius = 500
var circleColor = Color(1,1,1,0.5)
@export var pointCount = 64
@export var width = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

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
	
	
