package states;

import haxe.io.Encoding;
import objects.FireBall;
import objects.InvincibilityBonus;
import flixel.ui.FlxVirtualPad;
import flixel.math.FlxPoint;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Player;
import objects.Coin;
import objects.Enemy;
import objects.PowerUp;
import objects.BonusBlock;
import objects.BrickBlock;
import objects.Goal;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.FlxState;
import utils.LevelLoader;

class PlayState extends FlxState {
	private var _hud:HUD;
	private var _entities:FlxGroup;

	private var _gameCamera:FlxCamera;
	private var _hudCamera:FlxCamera;
	private var _terrain:FlxGroup;

	public var map:FlxTilemap;
	public var player(default, null):Player;
	public var items(default, null):FlxTypedGroup<FlxSprite>;
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	public var blocks(default, null):FlxTypedGroup<FlxSprite>;
	public var checkpoint:FlxPoint;

	#if mobile
	public var virtualPad:FlxVirtualPad;
	#end

	override public function create():Void {
		Reg.PS = this;
		Reg.pause = false;
		Reg.time = 300;

		_gameCamera = new FlxCamera();
		_hudCamera = new FlxCamera();

		FlxG.cameras.reset(_gameCamera);
		FlxG.cameras.add(_hudCamera);
		_hudCamera.bgColor = FlxColor.TRANSPARENT;
		FlxCamera.defaultCameras = [_gameCamera];

		_hud = new HUD();
		_hud.setCamera(_hudCamera);

		_entities = new FlxGroup();
		_terrain = new FlxGroup();

		player = new Player();
		items = new FlxTypedGroup<FlxSprite>();
		blocks = new FlxTypedGroup<FlxSprite>();
		enemies = new FlxTypedGroup<Enemy>();

		LevelLoader.loadLevel(this, Reg.levels[Reg.currentLevel]);
		add(player);

		_entities.add(items);
		_entities.add(blocks);
		_entities.add(enemies);

		add(_entities);

		_terrain.add(map);
		_terrain.add(blocks);

		add(_hud);

		#if mobile
		virtualPad = new FlxVirtualPad(LEFT_RIGHT, A_B);
		virtualPad.alpha = 0.75;
		add(virtualPad);
		#end

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);

		openSubState(new IntroSubState(FlxColor.BLACK));
		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (player.alive) {
			FlxG.overlap(_entities, player, collideEntities);
			FlxG.collide(_terrain, player);
		}

		FlxG.collide(_terrain, _entities);
		FlxG.collide(enemies, enemies);
		FlxG.overlap(_entities, enemies, collideEntities);
		updateTime(elapsed);
		updateCheckPoint();
	}

	function collideEntities(entity:FlxSprite, subject:FlxSprite):Void {
		if (Std.is(subject, Player)) {
			var player:Player = cast subject;

			if (Std.is(entity, Coin))
				(cast entity).collect();

			if (Std.is(entity, Enemy))
				(cast entity).interact(player);

			if (Std.is(entity, BonusBlock))
				(cast entity).hit(player);

			if (Std.is(entity, PowerUp)) {
				(cast entity).collect(player);
			}

			if (Std.is(entity, InvincibilityBonus))
				(cast entity).collect(player);

			if (Std.is(entity, Goal)) {
				(cast entity).reach(player);
			}

			if (Std.is(entity, BrickBlock)) {
				(cast entity).hit(player);
			}
		} else if (Std.is(subject, Enemy)) {
			var enemy:Enemy = cast subject;
			if (Std.is(entity, Enemy))
				enemy.collideOtherEnemy(cast entity);

			if (Std.is(entity, FireBall))
				enemy.collideFireball(cast entity);
		}
	}

	function collideItems(coin:Coin, player:Player):Void {
		coin.collect();
	}

	function collideEnemies(enemy:Enemy, player:Player):Void {
		enemy.interact(player);
	}

	private function updateTime(elapsed:Float) {
		if (!Reg.pause) {
			if (Reg.time > 0)
				Reg.time -= elapsed;
			else {
				Reg.time = 0;
				player.kill();
			}
		}
	}

	public function updateCheckPoint() {
		if (checkpoint == null || Reg.checkpointReached)
			return;

		if (player.x >= checkpoint.x) {
			trace("Checkpoint Reached");
			Reg.checkpointReached = true;
		}
	}

	public function nextLevel():Void {
		Reg.checkpointReached = false;
		checkpoint = null;
		FlxG.cameras.fade(FlxColor.BLACK, .2, false, function() {
			Reg.currentLevel++;
			if (Reg.currentLevel < Reg.levels.length)
				FlxG.resetState();
			else
				FlxG.switchState(new IntroSubState(FlxColor.BLACK));
		});
	}
}
