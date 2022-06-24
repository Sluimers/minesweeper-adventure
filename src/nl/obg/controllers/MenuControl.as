package nl.obg.controllers {
	
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import nl.obg.gtk.GtkWidget;
	
	import nl.obg.engine.*;
	import nl.obg.menus.*;
	import nl.obg.widgets.*;
	import nl.obg.standards.*;
	
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class MenuControl
	{
		public static var main:Main;
		private static var menu:Widget;
		
		public static function init(nwMain:Main):void {
			main = nwMain;
		}
		
		public static function setMenu(nwMenu:Menu):void {
			menu = nwMenu;
			main.stage.addChild(nwMenu);
		}
		
		// Adds a main engine menu
		public static function addMenu(type:String):void {
			var menu2:GtkWidget = new GtkWidget();
			if (menu == null) {
				switch(type) {
					case "StartMenu": 			menu = new StartMenu();			break;
					//case "StartMenu": 		menu2 = new StartMenu2();		break;
					case "OptionsMenu":			menu = new OptionsMenu();		break;
					case "GameOverMenu":		menu = new GameOverMenu();		break;
					case "GameMenu":			menu = new GameMenu();			break;
					case "StageClearedMenu":	menu = new StageClearedMenu();	break;
					default:					menu = new Widget();			break;
				}
				if (menu == null) {
					main.stage.addChild(menu2);
					menu2.init();
					return;
				}
				main.stage.addChild(menu);
				menu.init();
			}
		}
		
		public static function removeMenu():void {
			var m:Widget = menu; 
			
			if (m != null) {
				m.removeEvents();
				m.removeItems();
				main.stage.removeChild(menu);
				menu = null;
				main.stage.focus = main;
			}
		}
		
		public static function quitGame():void {
			//removeMenu();
			//removeMap();
			
			//Engine.isMapLoaded = false;
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, gameMenu);
			main.stage.removeEventListener(Event.ENTER_FRAME, Engine.run);
			
			main.stage.focus = main;
			Engine.freeze = false;
			//KeyControl.escPressed = false;
			
			//addMenu("StartMenu");
		}
		
		public static function gameMenu(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case Key.ENTER: {
					Engine.freeze = false;
					GameControl.inGame = true;
					main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, gameMenu);
					break;
				}
				case Key.ESC: {
					quitGame();
					break;
				}
			}
		}
	}
}