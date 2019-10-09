package utils;

import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import states.PlayState;
import objects.Coin;

class LevelLoader {

	public static function getLevelObjects(map: TiledMap, layer: String): Array<TiledObject> {
		if ((map != null) && (map.getLayer(layer) != null)) {
			var objLayer: TiledObjectLayer = cast map.getLayer(layer);
			return objLayer.objects;
		} else {
			trace("Object layer " + layer + " not found! ");
			return [];
		}
	}

	public static function loadLevel(state:PlayState, level:String) {
		var tiledMap = new TiledMap("assets/data/" + level + ".tmx");
		var mainLayer:TiledTileLayer = cast tiledMap.getLayer("main");

		state.map = new FlxTilemap();
		state.map.loadMapFromArray(mainLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);

		var backLayer:TiledTileLayer = cast tiledMap.getLayer("back");
		var backMap = new FlxTilemap();
		backMap.loadMapFromArray(backLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);
		backMap.solid = false;

		state.add(backMap);
		state.add(state.map);
				
		var playerPos: TiledObject = getLevelObjects(tiledMap, "player")[0];
		state.player.setPosition(playerPos.x, playerPos.y - 16);
		for(coin in getLevelObjects(tiledMap, "coins")) {
			state.items.add(new Coin(coin.x, coin.y - 16));
		}
	}
}
