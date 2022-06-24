package nl.obg.menus {
	/**
	 * ...
	 * @author ...
	 */
	import flash.display.DisplayObject;
	
	 
	public class ScreenMenu extends Menu {
		protected var stageWidth:uint;
		protected var stageHalfWidth:uint;
		protected var stageHeight:uint;
		
		public override function init():void {
			stageWidth = stage.stageWidth;
			stageHalfWidth = stage.stageWidth / 2;
			stageHeight = stage.stageHeight;
		}
	}
}