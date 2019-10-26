package states;

import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Player;
import objects.Coin;
import objects.Enemy;
import objects.PowerUp;
import objects.BonusBlock;
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

		LevelLoader.loadLevel(this, "playground");
		add(player);

		_entities.add(items);
		_entities.add(blocks);
		_entities.add(enemies);

		add(_entities);

		_terrain.add(map);
		_terrain.add(blocks);

		add(_hud);

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

		updateTime(elapsed);
	}

	function collideEntities(entity:FlxSprite, player:Player):Void {
		if (Std.is(entity, Coin))
			(cast entity).collect();

		if (Std.is(entity, Enemy))
			(cast entity).interact(player);

		if (Std.is(entity, BonusBlock))
			(cast entity).hit(player);

		if (Std.is(entity, PowerUp)) {
			(cast entity).collect(player);
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
}
