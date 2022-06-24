package nl.obg.menus {
	/**
	 * ...
	 * @author ...
	 */
	import flash.display.DisplayObject;
	import nl.obg.widgets.*;
	import nl.obg.standards.Color;
	 
	public class Menu extends Widget {
		public static const DEFAULT_COLOR:uint = Color.WHITESMOKE;
		public static const DEFAULT_MENUCHOICE_COLOR:uint = Color.NEOGEOORANGE;
		
		public static const TITLESIZE:uint = 40;
		public static const TEXTSIZE:uint = 20;
		public static const SMALLSIZE:uint = 12;
		public static const DIALOGSIZE:uint = 15;
		
		protected var menuItems:Array = [];
		protected var choice:int = 0;
		
		public function setMenuItems(... items):void {
			var item:DisplayObject;
			for (var i:uint = 0; i < items.length; i++) {
				item = getItem(items[i]);
				if(item != null) menuItems.push(item);
			}
		}
	}
}