package nl.obg.menus {
	/**
	 * ...
	 * @author ...
	 */
	import flash.display.DisplayObject;
	
	import nl.obg.engine.*;
	
	public class MapMenu extends Menu {
		protected var mapWidth:uint;
		protected var mapHalfWidth:uint;
		protected var mapHeight:uint;
		
		
		public override function init():void {
			mapWidth = Engine.getMapViewWidth();
			mapHalfWidth = mapWidth >> 1;
			mapHeight = Engine.getMapViewHeight();
		}
	}
}