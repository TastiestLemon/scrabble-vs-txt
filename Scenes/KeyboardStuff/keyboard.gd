extends VBoxContainer
class_name Keyboard

signal ON_EDIT

@onready var row = preload("res://Scenes/KeyboardStuff/row.tscn")
@onready var key = preload("res://Scenes/KeyboardStuff/key.tscn")

@export var output: Label
@export var contents: PackedStringArray
@export var coreButtons: HBoxContainer

func _on_ready() -> void:
	for line in contents:
		var newRow = row.instantiate()
		add_child(newRow)
		for l in line:
			var newKey: Button = key.instantiate()
			newKey.text = l
			newRow.add_child(newKey)
			newKey.pressed.connect(func ():
				output.text += newKey.text
				ON_EDIT.emit()
			)
	move_child(coreButtons, get_child_count() - 1)

func _on_backspace_pressed() -> void:
	if output.text.length() > 0:
		output.text = output.text.left(output.text.length() - 1)
		ON_EDIT.emit()

func _on_clear_pressed() -> void:
	output.text = ""
	ON_EDIT.emit()
