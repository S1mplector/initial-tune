extends CharacterBody2D

# AI Car Controller - follows waypoints on the track

var waypoints: Array = []
var current_waypoint_index: int = 0
var speed: float = 0.0
var max_speed: float = 800.0
var acceleration: float = 400.0
var deceleration: float = 600.0
var turn_speed: float = 3.0
var waypoint_threshold: float = 100.0

# Difficulty settings
var skill_level: float = 0.8  # 0.0 to 1.0
var rubber_banding: bool = true
var player_car: Node2D = null

func _ready():
	# Randomize skill slightly
	skill_level = randf_range(0.6, 1.0)
	max_speed = max_speed * skill_level

func set_waypoints(points: Array):
	waypoints = points
	current_waypoint_index = 0

func set_player_reference(player: Node2D):
	player_car = player

func _physics_process(delta):
	if waypoints.size() == 0:
		return
	
	var target = waypoints[current_waypoint_index]
	var direction = (target - global_position).normalized()
	var distance = global_position.distance_to(target)
	
	# Check if reached waypoint
	if distance < waypoint_threshold:
		current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
	
	# Rubber banding - speed up if behind, slow down if ahead
	if rubber_banding and player_car:
		var player_progress = get_player_progress()
		var ai_progress = current_waypoint_index
		if ai_progress < player_progress - 2:
			max_speed = 900.0 * skill_level
		elif ai_progress > player_progress + 2:
			max_speed = 600.0 * skill_level
		else:
			max_speed = 800.0 * skill_level
	
	# Calculate target angle
	var target_angle = direction.angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	
	# Slow down for sharp turns
	var turn_factor = 1.0 - abs(angle_diff) / PI * 0.5
	var target_speed = max_speed * turn_factor
	
	# Accelerate/decelerate
	if speed < target_speed:
		speed = min(speed + acceleration * delta, target_speed)
	else:
		speed = max(speed - deceleration * delta, target_speed)
	
	# Turn towards waypoint
	rotation = lerp_angle(rotation, target_angle, turn_speed * delta)
	
	# Move
	velocity = Vector2.from_angle(rotation) * speed
	move_and_slide()

func get_player_progress() -> int:
	if not player_car:
		return 0
	# Estimate player progress based on distance to waypoints
	var min_dist = INF
	var closest_wp = 0
	for i in range(waypoints.size()):
		var dist = player_car.global_position.distance_to(waypoints[i])
		if dist < min_dist:
			min_dist = dist
			closest_wp = i
	return closest_wp
