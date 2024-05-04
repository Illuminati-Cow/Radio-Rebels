class_name ChargeIndicator extends Polygon2D

@export var charge_time = 1000
@export_color_no_alpha var charged_color := Color("71e26a")
@export_color_no_alpha var uncharged_color := Color("558f44")
var _charge_tween : Tween
var _gradient := Gradient.new()
var _arrow_gradient := Gradient.new()

func _ready():
	_gradient.add_point(0.01, uncharged_color)
	_gradient.add_point(0, charged_color)
	_gradient.add_point(1, uncharged_color)
	_arrow_gradient.add_point(0.01, uncharged_color)
	_arrow_gradient.add_point(0, charged_color)
	_arrow_gradient.add_point(1, uncharged_color)
	var fade_tween = create_tween().set_loops()
	fade_tween.tween_property(self, "modulate:a", 0.5, 0.5)
	fade_tween.tween_property(self, "modulate:a", 1, 0.25)

func start_charging(angle_deg: float) -> void:
	rotation_degrees = angle_deg
	show()
	_charge_tween = create_tween()
	_charge_tween.tween_method(_gradient.set_offset.bind(1), 0, 1, charge_time*0.73)
	_charge_tween.tween_method(_arrow_gradient.set_offset.bind(1), 0, 1, charge_time*0.27)


func stop_charging() -> void:
	hide()
	if _charge_tween:
		_charge_tween.kill()
	_gradient.set_offset(0, 0.01)
	_arrow_gradient.set_offset(0, 0.01)
	_gradient.set_offset(1, 0)
	_arrow_gradient.set_offset(1, 0)



