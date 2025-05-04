extends Node3D

@onready var flag_large_green: MeshInstance3D = $FlagLargeGreen
@onready var flag_large_red: MeshInstance3D = $FlagLargeRed
@onready var mesh_instance_3d: MeshInstance3D = $Circle/MeshInstance3D

const CHECKED_CHECKPOINT = preload("res://Material/CheckedCheckpoint.tres")




	
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		flag_large_red.visible = false
		flag_large_green.visible = true
		mesh_instance_3d.material_overlay = CHECKED_CHECKPOINT
