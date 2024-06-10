extends Node2D

## Selects %Sprite2D.frame_coords.y frame based on owner direction.
## TODO use signals, remove movement dependencie, no external dependencies
class_name DirectionSelector

## Number for direction frames in the y axis of the sprite sheet.
@export var frames: int = 8

## Number of frames offset until right facing direction.
@export var offset: int = 0

## Frames are counterclockwise from top to bottom.
## TODO make dropdown selectable enum instead
@export var counterclockwise: bool = false

## For unordered frames each index must be provided.
@export var lookup: Array[int] = []

## TODO on ready validate vars make sense respective to sprite 2d data

func _process(_delta):
	if %Movement.target:
		var pos = self.owner.global_position
		var angle = pos.direction_to(%Movement.target).angle()
		var index = int(snapped(angle, (2*PI)/frames) / ((2*PI)/frames))
		if lookup:
			%Sprite2D.frame_coords.y = lookup[wrapi(index, 0, frames)]
		else:
			if counterclockwise:
				%Sprite2D.frame_coords.y = wrapi(offset - index, 0, frames)
			else:
				%Sprite2D.frame_coords.y = wrapi(offset + index, 0, frames)
