package nl.obg.engine {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	 
	public class MapData extends Sprite {
		public var layers:Array;
		public var obs:Array;
		public var zones:Array;
		public var scripts:Array;
		public var entities:Array;
		public var tsp:String;
		public var mapWidth:uint;
		public var mapHeight:uint;
		public var numLayers:uint;
		public var tileWidth:uint;
		public var tileHeight:uint;
		
		public function MapData() {}
	}
}