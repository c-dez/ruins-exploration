extends MeshInstance3D

# para asegurarse de que el mesh se comporte apropiadamente al mover la camara/ mover characterbody3D se usa top level y global_position
func _ready() -> void:
	top_level = true


func _process(_delta: float) -> void:
	global_position = owner.global_position
	pass
