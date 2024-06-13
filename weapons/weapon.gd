extends Area2D

class_name Weapon

signal fired(bullet: Array[Bullet])

@export var safty: bool = true

@onready var game = get_node("/root/Game")

var aiming: bool = false

@export var primary_faction: Faction = null
@export var secondary_faction: Faction = null

signal faction_updated(value: Faction)

@export var faction: Faction = null:
    set (value):
        faction = value
        faction_updated.emit(faction)

func _ready():
    self.faction_updated.connect(set_faction_data)
    set_faction_data(self.faction)

func set_faction_data(faction: Faction):
    collision_layer = faction.targeting_layer
    collision_mask = faction.targeting_mask

func trigger():
    if aiming and not safty:
        var bullets = shoot()
        for bullet in bullets:
            bullet.entity_owner = self.owner
            bullet.faction = bullet.FACTIONS[faction.name]
            %ShootingPoint.add_child(bullet)
        fired.emit(bullets)
        
        # TODO add shoot signal and hook that instead with other fx ...
        var shootSfx = self.get_node("ShootSfx")
        if shootSfx:
            shootSfx.play()
        

func find_targetable_enemies() -> Array[Node2D]:
    return Utils.filter_obscured(
        self,
        get_overlapping_bodies(),
        game.m_highground,
        game.m_concealment
    )
    
func aim_at(target):
    if target:
        look_at(target.global_position)
        var r = int(global_rotation_degrees) % 365
        var gsy = get_parent().global_scale.y
        if r < -90 or r > 90:
            scale.y = abs(scale.y) * -1 * gsy
        else:
            scale.y = abs(scale.y) * gsy
        aiming = true
    else:
        rotation = 0
        scale.y = abs(scale.y)
        aiming = false

func shoot():
    assert(false, "Required method 'shoot' not implemented by weapon.")
