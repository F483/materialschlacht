extends Projectile

class_name Bullet

const SPEED = 666
const RANGE = 666

const FACTIONS = {
    "Player": preload("res://projectiles/bullet/faction_player.tres"),
    "Enemy": preload("res://projectiles/bullet/faction_enemy.tres"),
    "Neutral": preload("res://projectiles/bullet/faction_neutral.tres")
}

@onready var game = get_node("/root/Game")

var travelled_distance: float = 0
var velocity: Vector2 = Vector2.ZERO

func set_faction_data(value: Faction):
    super(value)
    
    if game.m_highground and (rotation < 0 or rotation > 180):
        collision_mask |= Utils.MASK_MAP_LEDGES
    else:
        collision_mask &= ~Utils.MASK_MAP_LEDGES
        
    var model = get_node("Polygon2D")
    model.color = faction.color_primary

func _physics_process(delta):
    var direction = Vector2.RIGHT.rotated(rotation)
    velocity = direction * SPEED
    position += velocity * delta
    travelled_distance += SPEED * delta
    if travelled_distance > RANGE:
        queue_free()

func _on_body_entered(body):
    queue_free()
    var death_fx = get_node("DeathFX")
    if death_fx:
        death_fx.trigger()
