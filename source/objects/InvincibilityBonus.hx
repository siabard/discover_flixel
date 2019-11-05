package objects;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;

class InvincibilityBonus extends FlxSprite {
	private static var MOVE_SPEED:Int = 80;
	private static var GRAVITY:Int = 420;
	private static var BOUNCE_FORCE:Int = -120;

	private var _direction:Int = 1;
	private var _moving:Bool = false;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(AssetPaths.items__png, true, 16, 16);
		animation.add("idle", [10, 11, 10, 12], 24);
		animation.play("idle");
		FlxG.sound.play("powerup-appear");

		velocity.y = -16;
	}

	override public function update(elapsed:Float) {
		if (Reg.pause) {
			return;
		}

		if (_moving) {
			velocity.x = _direction * MOVE_SPEED;

			if (justTouched(FlxObject.FLOOR)) {
				y -= 1;
				velocity.y = BOUNCE_FORCE;
			}
		}

		if (!_moving && (Math.round(y) % 16 == 0)) {
			velocity.y = 0;
			acceleration.y = GRAVITY;
			_moving = true;
		}

		if (justTouched(FlxObject.WALL)) {
			_direction = -_direction;
		}

		super.update(elapsed);
	}

	public function collect(player:Player) {
		kill();
		player.makeInvincible();
	}
}
