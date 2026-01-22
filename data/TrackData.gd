extends Node

enum TrackType {
	AKINA
}

var selected_track: int = TrackType.AKINA

var tracks = {
	TrackType.AKINA: {
		"name": "Akina",
		"description": "The legendary downhill course. Technical hairpins and fast straights.",
		"scene": "res://scenes/race/map/akina/Akina.tscn",
		"preview": "res://assets/akinamap.png",
		"length_km": 4.2,
		"difficulty": "Medium",
		"best_time": 64.37,
		"best_time_holder": "Chamikey"
	}
}

func get_track_data(track_type: int) -> Dictionary:
	if tracks.has(track_type):
		return tracks[track_type]
	return tracks[TrackType.AKINA]

func get_selected_track_data() -> Dictionary:
	return get_track_data(selected_track)

func set_selected_track(track_type: int) -> void:
	selected_track = track_type

func get_track_count() -> int:
	return tracks.size()

func get_track_name(track_type: int) -> String:
	if tracks.has(track_type):
		return tracks[track_type]["name"]
	return "Unknown"

func get_all_track_types() -> Array:
	return tracks.keys()

func get_selected_track_scene() -> String:
	return get_selected_track_data()["scene"]
