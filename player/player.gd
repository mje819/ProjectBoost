extends RigidBody3D
class_name Player

@export_range(750, 2500) var thrust := 1000.0
@export var torque_thrust := 100.0

@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio

var transitioning := false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not transitioning:
		if Input.is_action_pressed("boost"):
			apply_central_force(basis.y * delta * thrust)
			if not rocket_audio.is_playing():
				rocket_audio.play()
		else:
			rocket_audio.stop()
		
		if Input.is_action_pressed("rotate_left"):
			apply_torque(Vector3(0, 0, delta * torque_thrust))
		
		if Input.is_action_pressed("rotate_right"):
			apply_torque(Vector3(0, 0, -delta * torque_thrust))

func crash_sequence() -> void:
	transitioning = true
	$ExplosionAudio.play()
	print("KABOOM")
	await get_tree().create_timer(2.5).timeout
	get_tree().reload_current_scene.call_deferred()

func level_complete(next_level_path) -> void:
	transitioning = true
	$SuccessAudio.play()
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file.call_deferred(next_level_path)



func _on_body_entered(body: Node) -> void:
	if not transitioning:
		if "Goal" in body.get_groups():
			print("you win")
			if body.file_path:
				level_complete(body.file_path)
		
		if "Hazard" in body.get_groups():
			crash_sequence()
