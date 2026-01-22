extends Node

# Car definitions with base stats
# Each car has unique characteristics that define its handling

enum CarType {
	AE86_TRUENO,
	RX7_FC,
	SILVIA_S13,
	EVO_III
}

var selected_car: int = CarType.AE86_TRUENO

# Car data structure
# All cars use AE86 sprite as fallback until custom sprites are added
const DEFAULT_SPRITE = "res://assets/cars/ae86.png"

var cars = {
	CarType.AE86_TRUENO: {
		"name": "AE86 Trueno",
		"description": "Lightweight FR coupe. Excellent balance and nimble handling.",
		"sprite": "res://assets/cars/ae86.png",
		"engine_sound": "res://assets/sounds/corollahp.wav",
		"engine_sound_sub": "res://assets/sounds/corollahp2.wav",
		"engine_sound_bass": "res://assets/sounds/corollalp.wav",
		"engine_power": 175,
		"weight": 1.2,
		"steering_weight_multiplier": 0.5,
		"brake_power": -2.0,
		"final_drive_ratio": 4.5,
		"gear_ratio": [-2.8, 0, 3.0, 1.5, 1.0, 0.9, 0.81],
		"max_rpm": 7000,
		"traction_fast": 0.1,
		"traction_slow": 0.7,
		"slip_speed": 1200,
		"friction": -0.9,
		"drag": -0.0003
	},
	CarType.RX7_FC: {
		"name": "RX-7 FC",
		"description": "Rotary-powered sports car. High revving with smooth power delivery.",
		"sprite": "res://assets/cars/rx7fc.png",
		"engine_sound": "res://assets/sounds/corollahp.wav",
		"engine_sound_sub": "res://assets/sounds/corollahp2.wav",
		"engine_sound_bass": "res://assets/sounds/corollalp.wav",
		"engine_power": 185,
		"weight": 1.25,
		"steering_weight_multiplier": 0.48,
		"brake_power": -2.2,
		"final_drive_ratio": 4.3,
		"gear_ratio": [-2.6, 0, 2.8, 1.6, 1.1, 0.88, 0.78],
		"max_rpm": 8000,
		"traction_fast": 0.12,
		"traction_slow": 0.68,
		"slip_speed": 1300,
		"friction": -0.88,
		"drag": -0.00028
	},
	CarType.SILVIA_S13: {
		"name": "Silvia S13",
		"description": "Drift-oriented FR. Loose rear end, great for sliding.",
		"sprite": DEFAULT_SPRITE,
		"engine_sound": "res://assets/sounds/corollahp.wav",
		"engine_sound_sub": "res://assets/sounds/corollahp2.wav",
		"engine_sound_bass": "res://assets/sounds/corollalp.wav",
		"engine_power": 190,
		"weight": 1.28,
		"steering_weight_multiplier": 0.46,
		"brake_power": -2.1,
		"final_drive_ratio": 4.4,
		"gear_ratio": [-2.7, 0, 2.9, 1.55, 1.05, 0.85, 0.75],
		"max_rpm": 7500,
		"traction_fast": 0.08,
		"traction_slow": 0.65,
		"slip_speed": 1100,
		"friction": -0.85,
		"drag": -0.00032
	},
	CarType.EVO_III: {
		"name": "Lancer Evo III",
		"description": "AWD rally beast. Maximum grip and acceleration.",
		"sprite": DEFAULT_SPRITE,
		"engine_sound": "res://assets/sounds/corollahp.wav",
		"engine_sound_sub": "res://assets/sounds/corollahp2.wav",
		"engine_sound_bass": "res://assets/sounds/corollalp.wav",
		"engine_power": 200,
		"weight": 1.35,
		"steering_weight_multiplier": 0.52,
		"brake_power": -2.5,
		"final_drive_ratio": 4.2,
		"gear_ratio": [-2.5, 0, 2.7, 1.45, 0.95, 0.82, 0.72],
		"max_rpm": 7200,
		"traction_fast": 0.18,
		"traction_slow": 0.8,
		"slip_speed": 1400,
		"friction": -0.92,
		"drag": -0.00035
	}
}

func get_car_data(car_type: int) -> Dictionary:
	if cars.has(car_type):
		return cars[car_type]
	return cars[CarType.AE86_TRUENO]

func get_selected_car_data() -> Dictionary:
	return get_car_data(selected_car)

func set_selected_car(car_type: int) -> void:
	selected_car = car_type

func get_car_count() -> int:
	return cars.size()

func get_car_name(car_type: int) -> String:
	if cars.has(car_type):
		return cars[car_type]["name"]
	return "Unknown"

func get_all_car_types() -> Array:
	return cars.keys()
