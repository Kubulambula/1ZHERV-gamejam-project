extends CharacterBody3D

const BASE_SPEED: float  = 2.5
const ACCELERATION: float = 8.0
const FRICTION: float = 10.0

const DASH_SPEED: float = 8.0
const DASH_DURATION: float = 0.15
const DASH_COOLDOWN: float = 0.5

var input: Vector2 = Vector2.ZERO
var horizontal_velocity: Vector2 = Vector2.ZERO
var speed: float = BASE_SPEED
var movement_enabled: bool = true
var dash_enabled: bool = true

var interactables_in_range: Array[Interactable] = []

var closest_interactable: Interactable = null

@onready var dash_audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var animation_enabled: bool = false

@onready var particles: GPUParticles3D = $GPUParticles3D

var interact_cooldown: Timer = Timer.new()
const INTERACT_COOLDOWN_TIME: float = 0.35


func _ready() -> void:
	BlackBoard.player = self
	add_child(interact_cooldown)
	rotation.y = PI # face the camera on startup


func _physics_process(_delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down", 0.2)
	
	play_animation(input != Vector2.ZERO)
	
	if Input.is_action_just_pressed("dash"):
		dash()
	
	if movement_enabled:
		move()
	
	if closest_interactable:
		closest_interactable.unhighlight()
	closest_interactable = get_closest_interactable(interactables_in_range)
	if closest_interactable:
		closest_interactable.highlight()
	
	velocity = Vector3(horizontal_velocity.x, 0, horizontal_velocity.y)
	
	if velocity != Vector3.ZERO:
		var lookdir: float = atan2(-velocity.x, -velocity.z)
		rotation.y = lerp_angle(rotation.y, lookdir, 0.3)
	
	move_and_slide()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		if closest_interactable and interact_cooldown.time_left == 0:
			closest_interactable.interact()
			interact_cooldown.wait_time = INTERACT_COOLDOWN_TIME
			interact_cooldown.one_shot = true
			interact_cooldown.start()


func move() -> void:
	if input: # player moving
		horizontal_velocity += input * ACCELERATION
		horizontal_velocity = horizontal_velocity.normalized() * min(horizontal_velocity.length(), speed)
	elif horizontal_velocity.length() > FRICTION: # player stopping
		horizontal_velocity -= horizontal_velocity.normalized() * FRICTION
	else: # palayer stopped
		horizontal_velocity = Vector2.ZERO


func dash() -> void:
	if not dash_enabled or input == Vector2.ZERO:
		return
	dash_audio.play()
	particles.restart()
	particles.emitting = true
	dash_enabled = false
	horizontal_velocity = input.normalized() * DASH_SPEED
	movement_enabled = false
	await get_tree().create_timer(DASH_DURATION).timeout
	movement_enabled = true
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	dash_enabled = true


func _on_area_3d_area_entered(area: Area3D) -> void:
	if not area is Interactable:
		return
	interactables_in_range.append(area)
	#if closest_interactable:
		#closest_interactable.unhighlight()
	#closest_interactable = get_closest_interactable(interactables_in_range)
	#closest_interactable.highlight()


func _on_area_3d_area_exited(area: Area3D) -> void:
	if not area is Interactable:
		return
	interactables_in_range.erase(area)
	#closest_interactable.unhighlight()
	#closest_interactable = get_closest_interactable(interactables_in_range)
	#if closest_interactable:
		#closest_interactable.highlight()


func get_closest_interactable(from: Array[Interactable]) -> Interactable:
	if from.is_empty():
		return null
	
	var closest: Interactable = from[0]
	for i in range(1, from.size()):
		if from[i].global_position.distance_squared_to(global_position) < closest.global_position.distance_squared_to(global_position):
			closest = from[i]
	
	return closest


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if animation_enabled:
		if anim_name == "walk1":
			animation_player.play("walk2")
		else:
			animation_player.play("walk1")


func play_animation(is_moving: bool) -> void:
	if is_moving and not animation_enabled:
		animation_enabled = true
		animation_player.play("walk1")
	elif not is_moving:
		animation_enabled = false
