extends Node2D

var fret = 0

@onready var strings = [
	$String1,
	$String2,
	$String3,
	$String4,
	$String5,
	$String6
]

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		
		# 🎸 pluck strings
		match event.keycode:
			KEY_1: $String1.pluck()
			KEY_2: $String2.pluck()
			KEY_3: $String3.pluck()
			KEY_4: $String4.pluck()
			KEY_5: $String5.pluck()
			KEY_6: $String6.pluck()

		# 🎸 fret control
		if event.keycode == KEY_Q:
			fret += 1

		elif event.keycode == KEY_A:
			fret -= 1
			
		apply_fret()
		fret = clamp(fret, 0, 12)

func apply_fret():
	for s in strings:
		s.fret = fret
		
func _on_h_slider_value_changed(value):
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
