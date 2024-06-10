extends Node

class_name Effect

var effect_name: String
var duration: int
var duration_pred: int
var apply_effect: Callable
var remove_effect: Callable

func _init(effect_name_param: String, duration_param: int, duration_pred_param: int, apply_effect_param: Callable, remove_effect_param: Callable):
	self.effect_name = effect_name_param
	self.duration = duration_param
	self.duration_pred = duration_pred_param
	self.apply_effect = apply_effect_param
	self.remove_effect = remove_effect_param
