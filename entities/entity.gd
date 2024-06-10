extends CharacterBody2D

class_name Entity

@onready var game = get_node("/root/Game")
@onready var player_units = get_node("/root/Game/PlayerUnits")

signal faction_updated(value: Faction)

@export var faction: Faction = null:
    set (value):
        faction = value
        faction_updated.emit(faction)

func _ready():
    self.faction_updated.connect(set_faction_data)
    set_faction_data(self.faction)

func set_faction_data(value: Faction):
    collision_layer = value.object_layer
    collision_mask = value.object_mask

func destroy():
    var death_fx = get_node("DeathFX")
    if death_fx:
        death_fx.trigger()
    queue_free()

