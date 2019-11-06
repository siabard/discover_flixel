package objects;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxObject;
import flixel.FlxSprite;

class Enemy extends FlxSprite {
	private static inline var GRAVITY:Int = 420;
	private static inline var FALLING_SPEED:Int = 200;
	private static var FLIP_FORCE:Int = -100;
	private static inline var SCORE_AMOUNT:Int = 100;

	private var _direction:Int = -1;
	private var _appeared:Bool = false;
	private var _dieFlip:Bool = false;
	private var _canFireballDamage:Bool = true;

	public var damageOthers:Bool = true;

	public function new(x:Float, y:Float) {
		super(x, y);

		acceleration.y = GRAVITY;
		maxVelocity.y = FALLING_SPEED;

		flipX = true;
		_direction = -1;
	}

	override public function update(elapsed:Float) {
		if (!inWorldBounds()) {
			exists = false;
		}

		if (isOnScreen()) {
			_appeared = true;
		}

		if (_appeared && alive) {
			move();

			if (justTouched(FlxObject.WALL)) {
				flipDirection();
			}
		}

		if (!Reg.pause)
			super.update(elapsed);
	}

	private function flipDirection() {
		flipX = !flipX;
		_direction = -_direction;
	}

	private function move() {}

	public function interact(player:Player) {
		checkIfInvincible(player);

		if (!alive)
			return;

		FlxObject.separateY(this, player);
		if ((player.velocity.y > 0) && (isTouching(FlxObject.UP))) {
			kill();
			player.jump();
		} else {
			player.damage();
		}
	}

	override public function kill() {
		alive = false;
		Reg.score += SCORE_AMOUNT;
		FlxG.sound.play("defeat");

		if (!_dieFlip) {
			velocity.x = 0;
			acceleration.x = 0;
			animation.play("dead");

			new FlxTimer().start(1.0, function(_) {
				exists = false;
				visible = false;
			}, 1);
		} else {
			flipY = true;
			velocity.y = FLIP_FORCE;
			acceleration.x = 0;
			solid = false;
		}
	}

	public function killFlipping() {
		_dieFlip = true;
		kill();
	}

	private function checkIfInvincible(player:Player) {
		if (player.invincible) {
			killFlipping();
		}
	}

	public function collideOtherEnemy(otherEnemy:Enemy) {
		if (otherEnemy.damageOthers)
			killFlipping();
		else
			FlxObject.separate(this, otherEnemy);
	}

	public function collideFireball(fireball:FireBall) {
		fireball.kill();
		if (_canFireballDamage)
			killFlipping();
	}
}
