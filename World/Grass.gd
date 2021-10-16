extends Node2D

		
func create_grass_effect():
		var GrassEffect = load("res://Effects/GrassEffect.tscn")	# load the scene
		var grassEffect = GrassEffect.instance()					# instance the scene
		var world = get_tree().current_scene						# scene get access to the world
		world.add_child(grassEffect)								# add as child 
		grassEffect.global_position = global_position				# set general position

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
