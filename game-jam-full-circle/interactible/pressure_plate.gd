extends Area3D

@onready var mesh = $"../MeshInstance3D"

var is_pressed: bool

signal button_pressed()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_pressed = false



func _on_body_entered(body: PhysicsBody3D):
	if not is_pressed:
		if(body.get("player_size")):
			var player_size = body.get("player_size")
			if(player_size > get_parent_node_3d().req_weight):
				is_pressed = true
				emit_signal("button_pressed")
				var tween = create_tween()
				tween.tween_property(mesh, "position:y", -0.1, 0.5)
				SfxController.press_button()
