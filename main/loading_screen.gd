extends CanvasLayer

@onready var progress_bar: ProgressBar = $HBoxContainer/ProgressBar
@onready var label: Label = $HBoxContainer/Label


func reset() -> void:
	progress_bar.value = .2
	
func test(p) -> void:
	progress_bar.value = p
	
func _process(delta: float) -> void:
	progress_bar.value += 0.1
