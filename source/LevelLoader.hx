package;

import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;

class LevelLoader {

public static function loadLevel(state: PlayState, level: String) {
    var tiledMap = new TiledMap("assets/data/" + level + ".tmx" );
    var mainLayer: TiledTileLayer = cast tiledMap.getLayer("main");

    state.map = new FlxTilemap();
    state.map.loadMapFromArray(mainLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);

    var backLayer: TiledTileLayer = cast tiledMap.getLayer("back");
    var backMap = new FlxTilemap();
    backMap.loadMapFromArray(backLayer.tileArray, tiledMap.width, tiledMap.height, AssetPaths.tiles__png, 16, 16, 1);
    backMap.solid = false;

    state.add(backMap);
    state.add(state.map);

}

}
