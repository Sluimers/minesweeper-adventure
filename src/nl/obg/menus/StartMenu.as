package nl.obg.menus {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.controllers.*;
	
	public class StartMenu extends ScreenMenu {
		
		
		public function StartMenu():void {
			super();
		}
		
		public override function init():void {
			super.init();
			setSize(stageWidth, stageHeight);
			
			addTopText("Title", "MINESWEEPER ADVENTURE", TITLESIZE, DEFAULT_COLOR);
			addCenterText("Start Button", "START", TEXTSIZE, DEFAULT_COLOR);
			addCenterText("Options Button", "OPTIONS MENU", TEXTSIZE, DEFAULT_COLOR);
			setMenuItems("Start Button", "Options Button");
			
			addBottomRightText("version", "version 0.3", SMALLSIZE, DEFAULT_COLOR);
			
			addItemEventListener("Start Button", MouseEvent.CLICK, start);
			addItemEventListener("Options Button", MouseEvent.CLICK, options);
			
			menuItems[0].textColor = DEFAULT_MENUCHOICE_COLOR;
			
			addBackground(Color.BLACK);
			
			Engine.addHookTimer(keyControl);
		}
		
		public function keyControl():void {
			const len:uint = menuItems.length;
			const key:int = KeyControl.keyPressed;
			
			if (key == -1) return;
			
			switch(key) {
				case Key.DOWN:  menuItems[choice].textColor = DEFAULT_COLOR; choice++; 	break;
				case Key.UP:	menuItems[choice].textColor = DEFAULT_COLOR; choice--; 	break;
				case Key.ENTER: 
					switch(choice) {
						case 0: startMineSweeper(); return;
						case 1: goToOptionMenu(); return;
					}
				break;
			}
			
			if (choice == len) choice = 0;
			else if (choice < 0) choice = len - 1;
			
			menuItems[choice].textColor = DEFAULT_MENUCHOICE_COLOR;
		}
		
		public function start(event:MouseEvent):void {
			startMineSweeper();
		}
		
		public function options(event:MouseEvent):void {
			goToOptionMenu();
		}
		
		public function startMineSweeper():void {
			Engine.removeHooks();
			MenuControl.removeMenu();
			// GameControl.startGame();
		}
		
		public function goToOptionMenu():void {
			Engine.removeHooks();
			MenuControl.removeMenu();
			MenuControl.addMenu("OptionsMenu");
		}
	}
}