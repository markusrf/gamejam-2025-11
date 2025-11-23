extends Area3D

@onready var mesh = $"../MeshInstance3D"


signal button_pressed()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



func _on_body_entered(body: PhysicsBody3D):
	if(body.get("player_size")):
		var player_size = body.get("player_size")
		if(player_size > get_parent_node_3d().req_weight):
			emit_signal("button_pressed")
			var tween = create_tween()
			tween.tween_property(mesh, "position:y", -0.1, 0.5)
		
	
	
