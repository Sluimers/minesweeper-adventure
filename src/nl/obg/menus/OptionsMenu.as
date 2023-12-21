package nl.obg.menus {
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import nl.obg.www.*;
	import nl.obg.standards.*;
	import nl.obg.widgets.*;
	import nl.obg.engine.*;
	import nl.obg.controllers.*;
	
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class OptionsMenu extends ScreenMenu {
		private static var hasSolidCovers:Boolean = 		Settings.hasSolidCovers();	
		private static var hasRadar:Boolean =				Settings.hasRadar();
		private static var fullScreen:Boolean =				Settings.fullScreen();
		
		private static var flagKey:uint =					Settings.flagKey();
		private static var actionKey:uint =					Settings.actionKey();
		
		private static var hasSolidCoversToggle:String = 	hasSolidCovers?"On":"Off";
		private static var hasRadarToggle:String = 			hasRadar?"On":"Off";
		private static var fullScreenToggle:String =		fullScreen?"On":"Off";
		private static var body:Widget;
		
		public function OptionsMenu() {
			super();
		}
		
		public override function init():void {
			var appW:uint = stage.stageWidth;
			var appH:uint = stage.stageHeight;
			var midW:uint = appW / 2;
			
			setSize(appW, appH);
			
			addTopText("Title", "Option Menu", TITLESIZE, DEFAULT_COLOR);
			body = addWidget("Body", "center", "center");
			
			body.addCenterLeftText("Fog of War", "Fog of War " + hasRadarToggle, TEXTSIZE, DEFAULT_COLOR);
			body.addCenterLeftText("Solid Covers", "Solid covers" + hasSolidCoversToggle, TEXTSIZE, DEFAULT_COLOR);
			body.addCenterLeftText("Fullscreen", "Fullscreen " + fullScreenToggle, TEXTSIZE, DEFAULT_COLOR);
			
			addBottomRightText("save", "SAVE", TEXTSIZE, DEFAULT_COLOR);
			
			setMenuItems("Fog of War", "Solid Covers", "Fullscreen", "save");
			
			menuItems[0].textColor = DEFAULT_MENUCHOICE_COLOR;
			
			addItemEventListener("save", MouseEvent.CLICK, saveAndCloseM);
			
			addBackground(Color.BLACK);
			
			Engine.addHookTimer(keyControl);
		}
		
		public function keyControl():void {
			const kpq:Array = KeyControl.keyDownQueue, kpql:uint = kpq.length;
			const len:uint = menuItems.length;
			const key:int = KeyControl.keyPressed;
			
			if (key == -1) return;
			
			switch(key) {
				case Key.DOWN:  menuItems[choice].textColor = DEFAULT_COLOR; choice++; 	break;
				case Key.UP:	menuItems[choice].textColor = DEFAULT_COLOR; choice--; 	break;
				case Key.ENTER: 
					switch(choice) {
						case 0: toggleRadar(); return;
						case 1: toggleSolidCovers(); return;
						case 2: toggleFullscreen(); return;
						case 3: saveAndClose(); return;
					}
				break;
			}
			
			if (choice == len) choice = 0;
			else if (choice < 0) choice = len - 1;
				
			menuItems[choice].textColor = DEFAULT_MENUCHOICE_COLOR;
			
		}
		
		public function toggleRadar():void {
			hasRadar = !hasRadar;
			hasRadarToggle = hasRadar?"On":"Off";
			body.editText("Fog of War", "Fog of War " + hasRadarToggle);
		}
		
		public function toggleSolidCovers():void {
			hasSolidCovers = !hasSolidCovers;
			hasSolidCoversToggle = hasSolidCovers?"On":"Off";
			body.editText("Solid Covers", "Solid Covers" + hasSolidCoversToggle);
		}
		
		public function toggleFullscreen():void {
			fullScreen = !fullScreen;
			fullScreenToggle = fullScreen?"On":"Off";
			body.editText("Fullscreen", "Fullscreen" + fullScreenToggle);
		}
		
		public function saveAndCloseM(e:MouseEvent):void {
			saveAndClose();
		}
		
		public function saveAndClose():void {
			Settings.saveData([hasSolidCovers, hasRadar, actionKey, flagKey, fullScreen]);
			goBackToMainMenu();
		}
		
		public function goBackToMainMenu():void {
			Settings.checkForFullScreen(stage);
			Engine.removeHooks();
			MenuControl.removeMenu();
			MenuControl.addMenu("StartMenu");
		}	
	}
}