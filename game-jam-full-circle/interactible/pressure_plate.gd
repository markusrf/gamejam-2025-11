extends Area3D

@onready var mesh = $"../MeshInstance3D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: PhysicsBody3D):
	if(body.get("player_size")):
		var player_size = body.get("player_size")
		if(player_size > 0):
			print("push")
			var tween = create_tween()
			tween.tween_property(mesh, "position:y", -0.08, 0.5)
		
	
	
