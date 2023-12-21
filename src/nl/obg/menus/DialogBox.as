package nl.obg.menus {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import nl.obg.controllers.*;
	import nl.obg.standards.*;
	import nl.obg.engine.*;
	import nl.obg.locals.*;
	
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class DialogBox extends Menu {
		
		public const texts:Array = [];
		public var currentText:String = "";
		public var keysUp:Boolean = false;
		
		public function DialogBox() {
			super();
		}
		
		public override function init():void {
			MenuControl.setMenu(this);
			move(160, stage.stageHeight - 128 - 30);
			
			setSize(stage.stageWidth - 280, 128);
			
			addTopLeftItem("Avatar", new Bitmap(PObjectList.getBitmapData("images/avatar.png")));
			//addBottomRightText("next", "Next", TEXTSIZE, Color.SILVER);
			addBackground(Color.WHITESMOKE);
			
			addItemEventListener("next", MouseEvent.CLICK, endDialogBox);
			
			Engine.addHookTimer(keyControl);
		}
		
		public function keyControl():void {
			const key:int = KeyControl.lastKeyDown;
			
			if (key == -1) {
				keysUp = true;
				return;
			}
			
			if(keysUp) {
				switch(key) {
					case Key.ENTER: 
					case Key.DOWN:
					case Key.UP:
					case Key.RIGHT:
					case Key.LEFT: 
					endDialogBox(null);
					break;
				}
			}
		}
		
		public function endDialogBox(event:MouseEvent):void {
			Engine.removeHookTimer(keyControl);
			MenuControl.removeMenu();
		}
		
		public function addDialogText(text:String):void {
			if (!texts.length) addCenterText("Dialog", text, Menu.DIALOGSIZE);
 			texts.push(text);
		}
	}
}