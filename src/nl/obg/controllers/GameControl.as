package nl.obg.controllers {
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.locals.*;
	import nl.obg.mine.*;
	import nl.obg.www.*;
	import nl.obg.mapsprites.*;
	import nl.obg.entities.*;
	import nl.obg.widgets.*;
	
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class GameControl
	{
		public static var main:Main;
		private static var level:uint = 1;
		public static var inGame:Boolean = false;
		
		public static function init(nwMain:Main):void {
			main = nwMain;
		}
		
		public static function gameOverMenuKeys(event:KeyboardEvent):void {
			var dumbKey:Boolean;
			
			switch(event.keyCode) {
				case Key.ENTER: continueGame(); break;
				case Key.Q: quitGame();			break;
				default: dumbKey = true;		break;
			}
			if (!dumbKey) {
				main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, gameOverMenuKeys);
				MenuControl.removeMenu();
				trace("alive:" + Engine.player.ent.alive);
			}
		}
		
		public static function quitGame():void {
			// for now
			restartGame();
		}
		
		public static function quitGameM(event:MouseEvent):void {
			quitGame();
		}
		
		public static function continueGameM(event:MouseEvent):void {
			continueGame();
		}
		
		public static function continueGame():void {
			MineMap.coverMines();
			revivePlayer();
		}
		
		public static function nextLevelMenuKeys(event:KeyboardEvent):void {
			var dumbKey:Boolean;
			
			switch(event.keyCode) {
				case Key.ENTER: nextLevel(); break;
				case Key.Q: quitGame();			break;
				default: dumbKey = true;		break;
			}
			if (!dumbKey) {
				main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, nextLevelMenuKeys);
				MenuControl.removeMenu();
			}
		}
		
		public static function nextLevelM(event:MouseEvent):void {
			nextLevel();
		}
		
		public static  function newGame():void {	
			const player:Player = Engine.player;
			Engine.counting = true;
			MenuControl.removeMenu();
			restartGame();
			//player.ent = new MineSweeper(StartPosition.getPosition(player));
		}
		
		public static function restartGame():void {
			level = 1;
			loadLevel(Levels.names[level]);
		}
		
		public static function nextLevel():void {
			level++;
			loadLevel(Levels.names[level]);
			Engine.player.ent.activate();
		}
		
		public static function getLevel():uint {
			return level;
		}
		
		private static function loadLevel(mapName:String = ""):void {
			if (mapName != "") {
				Engine.isMapLoaded = true;
				Map.Switch(mapName);
			}
			inGame = true;
			new TileIndicator("TileIndicator"); 
		}
		
		public static function saveState(nwSaveState:SaveState):void {
			GameModel.saveState = nwSaveState; 
		}
		
		public static function clear():void {
			MenuControl.removeMenu();
		}
		
		public static function toggleGameMenu():void {
			var midW:uint = Map.width / 2, midH:uint = Map.height / 2;
			var menu:Widget;
			
			MenuControl.addMenu("GameMenu");
			
			//freeze = true;
			inGame = false;
		}
		
		public static function winGame():void {
			freezeGame();
			MenuControl.addMenu("StageClearedMenu");
			inGame = false;
			Map.clearLevel();
		}
		
		public static function gameOver():void {
			Engine.player.ent.setLife(false);
			freezeGame();
			MenuControl.addMenu("GameOverMenu");
			Map.clearLevel();
			MineMap.uncoverMines();
		}
		
		public static function freezeGame():void {
			Engine.player.ent.setActive(false);
			Engine.player.ent.stop();
			inGame = false;
		}
		
		public static function setPlayer(ent:Entity):void {
			Engine.player.ent = ent;
		}
		
		public static function revivePlayer():void {
			const player:Player = Engine.player;
			const p:Entity = player.ent;
			const s:SaveState = GameModel.saveState;
			
			p.activate();
			p.setLife(true);
			player.reset();
			p.move(s.x, s.y, s.z);
		}
		
		public static function addPlayerToMap(x:uint, y:uint, z:uint):void {
			const player:Player = Engine.player, p:Entity = player.ent;
			
			Engine.addMapSprite(p);
			Engine.addSolidMapSprite(p);
			Engine.addEnt(p);
			
			p.setLife(true);
			player.reset();
			p.onNewMap();
			
			p.move(x, y, z);
		}
	}

}