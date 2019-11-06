package objects;

import flixel.FlxObject;
import flixel.FlxSprite;

class FireBall extends FlxSprite {
	private static var MOVE_SPEED:Int = 140;
	private static var BOUNCE_POWER:Int = 160;
	private static var GRAVITY:Int = 960;

	public var direction:Int = -1;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(AssetPaths.fireball__png, true, 8, 8);
		animation.add("shoot", [0, 1, 0, 2], 24);
		animation.add("fade", [0, 3, 4], 24);
		animation.play("shoot");
		acceleration.y = GRAVITY;
	}

	override public function update(elapsed:Float) {
		if (Reg.pause)
			return;

		velocity.x = direction * MOVE_SPEED;

		if (justTouched(FlxObject.FLOOR))
			velocity.y -= BOUNCE_POWER;

		if (justTouched(FlxObject.WALL))
			kill();
		super.update(elapsed);
	}
}
