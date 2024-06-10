extends Node2D

class_name Movement

signal stopped
signal stuck
signal arrived

@export var movement_disabled: bool = false
@export var movement_speed: float = 100.0

@export var knockback_disabled: bool = false
@export var knockback_factor: float = 1.0

var knockback_vec: Vector2 = Vector2.ZERO
var knockback_ttl: float = 0.0

var tolerance_factor: float = 0.015
var target: Vector2 = Vector2.ZERO
# TODO implement propper pathfinding ...

func on_damaged(src_hitbox: HitBox):
    if not knockback_disabled:
        var direction = src_hitbox.owner.velocity.normalized()
        var hit_knockback_vec = (
            direction * src_hitbox.knockback_speed * knockback_factor
        )
        if knockback_ttl > 0.0: # stack knockback on multiple quick hits
            knockback_vec += hit_knockback_vec
            knockback_ttl += src_hitbox.knockback_time
        else:
            knockback_vec = hit_knockback_vec
            knockback_ttl = src_hitbox.knockback_time

func stop():
    target = Vector2.ZERO
    if not knockback_disabled and knockback_ttl > 0.0:
        self.owner.velocity = knockback_vec
    else:
        self.owner.velocity = Vector2.ZERO
    stopped.emit()

func _physics_process(delta):
    var tolerance = movement_speed * tolerance_factor
    if not movement_disabled and target != Vector2.ZERO:
        if self.owner.global_position.distance_to(target) > tolerance:
            var direction = self.owner.global_position.direction_to(target)
            self.owner.velocity = direction * movement_speed
        else:
            stop()
            arrived.emit()
    
    if not knockback_disabled and knockback_ttl > 0.0:
        self.owner.velocity += knockback_vec

    if self.owner.velocity != Vector2.ZERO:
        var prev_position = self.owner.global_position
        self.owner.move_and_slide()
        var distance_moved = self.owner.global_position.distance_to(prev_position)
        if distance_moved < tolerance:
            stop()
            stuck.emit()
    
    knockback_ttl -= delta
