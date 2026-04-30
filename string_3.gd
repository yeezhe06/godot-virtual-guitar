extends Node2D

@onready var audio = $AudioStreamPlayer2D
@onready var line = $Line2D

var amplitude = 0
var decay = 0.95
var last_mouse_y = 0
var fret = 0

func _input(event):
	if event is InputEventMouseMotion:
		var current_y = event.position.y
		var speed = abs(current_y - last_mouse_y)

		if abs(current_y - global_position.y) < 10:
			if speed > 5:
				pluck_with_strength(speed)

		last_mouse_y = current_y
		
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			fret += 1
		elif event.keycode == KEY_A:
			fret -= 1
		
		fret = clamp(fret, 0, 12)

func _process(delta):
	amplitude *= decay
	
	if amplitude < 0.1:
		amplitude = 0
		
	update_string()

func update_pitch():
	var pitch = pow(2, fret / 12.0)
	audio.pitch_scale = pitch
	
func is_mouse_over():
	var mouse_y = get_global_mouse_position().y
	return abs(mouse_y - global_position.y) < 10
	
func pluck():
	update_pitch()
	audio.stop()
	audio.play()
	amplitude = 20
	
func pluck_with_strength(speed):
	update_pitch()
	audio.stop()
	audio.play()

	amplitude = clamp(speed * 0.5, 10, 40)

	audio.volume_db = linear_to_db(clamp(speed / 50.0, 0.1, 1.0))

	line.width = clamp(speed / 5, 2, 6)

func update_string():
	var points = []
	
	for x in range(100, 700, 10):
		var y = sin(x * 0.05 + Time.get_ticks_msec() * 0.01) * amplitude
		points.append(Vector2(x, y))
	
	line.points = points
