extends Node2D

@onready var background = $Background

var frames = [
	preload("res://assets/backgrounds/win/cityescape.png"),
	preload("res://assets/backgrounds/win/cityescape2.png"),
	preload("res://assets/backgrounds/win/cityescape3.png"),
	preload("res://assets/backgrounds/win/cityescape4.png")
]


func _ready():
	for frame in frames:
		background.texture = frame
		await get_tree().create_timer(1.5).timeout
