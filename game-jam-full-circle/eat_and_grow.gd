extends RigidBody3D
@onready var area_3d: Area3D = $Area3D

func _ready():
	area_3d.connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is StaticBody3D:
		
		print("Hit a StaticBody3D:", body.name)
		body.queue_free()
		$Area3D.scale *=1.5
		$CollisionShape3D.scale *=1.5
		$MeshInstance3D.scale *=1.5
