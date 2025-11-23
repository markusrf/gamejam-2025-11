extends Polygon2D

@onready var player = $"../../Frog"


var circle_radius: float = 1
	

func _draw():
	var white : Color = Color.WHITE
	var green : Color = Color.GREEN_YELLOW
	var grey : Color = Color("414042")


	# Four circles for the 2 eyes: 2 white, 2 grey.
	draw_circle(Vector2(42.479, 65.4825), 40, white)
	draw_circle(Vector2(43.423, 65.92), circle_radius, green)


func _on_frog_size_changed(player_size: float) -> void:
	circle_radius = player_size * 40/100
	queue_redraw()
