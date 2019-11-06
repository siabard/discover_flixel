package objects;

import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import utils.ControlsHandler;

class Player extends FlxSprite {
	private static var INVINCIBLE_DURATION:Float = 5.0;

	private static inline var ACCELERATION:Int = 320;
	private static inline var DRAG:Int = 320;
	private static inline var GRAVITY:Int = 600;
	public static inline var JUMP_FORCE:Int = -280;
	public static inline var WALK_SPEED:Int = 80;
	private static inline var RUN_SPEED:Int = 140;
	private static inline var FALLING_SPEED:Int = 300;

	private var _stopAnimations = false;
	private var _canShoot = true;

	public var flickering:Bool = false;
	public var direction:Int = 1;
	public var invincible:Bool = false;

	public function new() {
		super();
		health = 2;

		reloadGraphics();

		drag.x = DRAG;
		acceleration.y = GRAVITY;
		maxVelocity.set(WALK_SPEED, FALLING_SPEED);
	}

	public function jump() {
		if (ControlsHandler.keyPressedJump())
			velocity.y = JUMP_FORCE;
		else
			velocity.y = JUMP_FORCE / 2;
	}

	private function move():Void {
		acceleration.x = 0;

		if (ControlsHandler.keyPressedLeft()) {
			flipX = true;
			direction = -1;
			acceleration.x -= ACCELERATION;
		} else if (ControlsHandler.keyPressedRight()) {
			flipX = false;
			direction = 1;
			acceleration.x = ACCELERATION;
		}

		if (velocity.y == 0) {
			if (ControlsHandler.keyPressedJump() && isTouching(FlxObject.FLOOR)) {
				FlxG.sound.play("jump");
				jump();
			}
			if (ControlsHandler.keyPressedRun())
				maxVelocity.x = RUN_SPEED;
			else
				maxVelocity.x = WALK_SPEED;
		}

		if ((velocity.y < 0) && (ControlsHandler.keyReleasedJump()))
			velocity.y = velocity.y * 0.5;

		if (x < 0)
			x = 0;

		if (y > Reg.PS.map.height - height)
			kill();
	}

	override public function update(elapsed:Float):Void {
		if (!Reg.pause) {
			move();
			shootFireball();
		}

		if (!_stopAnimations)
			animate();

		if (invincible) {
			color = FlxColor.fromHSB((Reg.time * 1800) % 360, 1, 1);
		} else {
			color = FlxColor.WHITE;
		}
		super.update(elapsed);
	}

	private function animate():Void {
		if (!alive)
			animation.play("dead");
		else if ((velocity.y <= 0) && (!isTouching(FlxObject.FLOOR))) {
			animation.play("jump");
		} else if (velocity.y > 0)
			animation.play("full");
		else if (velocity.x == 0)
			animation.play("idle");
		else {
			if (FlxMath.signOf(velocity.x) != FlxMath.signOf(direction))
				animation.play("skid");
			else
				animation.play("walk");
		}
	}

	override public function kill() {
		if (alive) {
			FlxG.sound.play("death");
			FlxG.sound.music.stop();
			FlxG.camera.shake(0.01, 0.2);
			alive = false;
			velocity.set(0, 0);
			acceleration.set(0, 0);
			Reg.lives -= 1;
			Reg.pause = true;
			new FlxTimer().start(2.0, function(_) {
				FlxG.sound.play("dying");
				acceleration.y = GRAVITY;
				jump();
			}, 1);

			new FlxTimer().start(6.0, function(_) {
				FlxG.camera.fade(FlxColor.BLACK, .2, false, function() {
					Reg.pause = false;
					FlxG.resetState();
				});
			});
		}
	}

	private function reloadGraphics() {
		loadGraphic(AssetPaths.player_all__png, true, 16, 32);
		var animationOffset:Int = 0;

		switch (health) {
			case 0:
				setSize(8, 12);
				offset.set(4, 20);

				animation.add("powerup", [5, 12], 24);
			case 1:
				setSize(8, 24);
				offset.set(4, 8);

				animationOffset = 7;
				animation.add("powerup", [12, 19], 24);
				animation.add("damage", [5, 12], 24);
			case 2:
				setSize(8, 24);
				offset.set(4, 8);

				animationOffset = 14;

				animation.add("shoot", [20]);
				animation.add("damage", [5, 19], 24);
		}
		animation.add("idle", [0 + animationOffset]);
		animation.add("walk", [
			1 + animationOffset,
			2 + animationOffset,
			3 + animationOffset,
			2 + animationOffset
		], 12);
		animation.add("skid", [4 + animationOffset]);
		animation.add("jump", [5 + animationOffset]);
		animation.add("fall", [5 + animationOffset]);

		animation.add("dead", [6]);
	}

	public function powerUp() {
		if (health >= 2)
			return;

		var _prevVelocity:FlxPoint = new FlxPoint().copyFrom(velocity);
		var _prevAccel:FlxPoint = new FlxPoint().copyFrom(acceleration);

		Reg.pause = true;
		_stopAnimations = true;
		animation.play("powerup");
		velocity.set(0, 0);
		acceleration.set(0, 0);

		new FlxTimer().start(1.0, function(_) {
			health++;
			reloadGraphics();

			if (health == 1)
				y -= 16;

			Reg.pause = false;
			_stopAnimations = false;

			velocity = _prevVelocity;
			acceleration = _prevAccel;
		});
	}

	public function damage() {
		if ((FlxSpriteUtil.isFlickering(this)) || (Reg.pause))
			return;

		if (health > 0) {
			var _prevVelocity:FlxPoint = new FlxPoint().copyFrom(velocity);
			var _prevAccel:FlxPoint = new FlxPoint().copyFrom(acceleration);

			Reg.pause = true;
			_stopAnimations = true;

			health = 1;
			animation.play("damage");
			velocity.set(0, 0);
			acceleration.set(0, 0);

			new FlxTimer().start(1.0, function(_) {
				health--;
				reloadGraphics();
				y += 16;

				FlxSpriteUtil.flicker(this, 2.0, 0.04, true);
				Reg.pause = false;
				_stopAnimations = false;
				velocity = _prevVelocity;
				acceleration = _prevAccel;
			});
		} else
			kill();
	}

	public function makeInvincible():Void {
		invincible = true;
		new FlxTimer().start(INVINCIBLE_DURATION, function(_) {
			invincible = false;
		});
	}

	private function shootFireball() {
		if (health != 2)
			return;

		if (ControlsHandler.keyJustPressedRun() && _canShoot) {
			var fireball:FireBall = new FireBall(x, y);
			fireball.direction = direction;
			Reg.PS.items.add(fireball);
			FlxG.sound.play("fireball");

			_canShoot = false;
			new FlxTimer().start(0.25, function(_) _canShoot = true);

			if (velocity.y == 0) {
				_stopAnimations = true;
				animation.play("shoot");
				new FlxTimer().start(0.1, function(_) _stopAnimations = false);
			}
		}
	}
}
