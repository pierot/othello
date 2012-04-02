package be.wellconsidered.othello
{
	import be.wellconsidered.logging.Logger;
	import be.wellconsidered.othello.engine.Engine;
	import be.wellconsidered.othello.events.OthelloEvent;
	import be.wellconsidered.othello.model.Parts;
	import be.wellconsidered.othello.model.PlayerColours;
	import be.wellconsidered.othello.model.States;
	import be.wellconsidered.othello.model.TileData;
	import be.wellconsidered.othello.view.Board;
	import be.wellconsidered.othello.view.events.BoardEvent;
	import be.wellconsidered.othello.view.tile.Tile;
	import be.wellconsidered.othello.view.tile.events.TileEvent;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.core.UIComponent;

	public class Othello extends UIComponent
	{
		private var _iGridCount:int;
		private var _iDefaultDepth:int;

		private var _parts:Parts;
		private var _board:Board;
		private var _engine:Engine;
		
		private var _iZetTeller:int;
		
		private var _iColourCurrent:int;
		
		private var _iColourStarter:int = 1; // ZWART
		
		private var _isComputer:Boolean = true;
		private var _bPassPlayer1:Boolean = false;
		private var _bPassPlayer2:Boolean = false;
		
		public function Othello()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		private function init(e:Event):void
		{
			Logger.log("Othello Init");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_parts = new Parts(_iGridCount);
			
			_engine = new Engine(_iGridCount);
			
			createOuterBorder();
			createBoard();
			
			startPosition();
		}
		
		public function createOuterBorder():void
		{
			Logger.log("Create Outer Border");
			
			var i:int = 0;
			
			for(i = 0; i < _parts.tiles.length; i++)
				(_parts.tiles[0][i] as TileData).state = States.RAND;
				
			for(i = 0; i < _parts.tiles.length; i++)
				(_parts.tiles[_parts.tiles.length - 1][i] as TileData).state = States.RAND;
				
			for(i = 0; i < _parts.tiles.length; i++)
				(_parts.tiles[i][0] as TileData).state = States.RAND;
				
			for(i = 0; i < _parts.tiles.length; i++)
				(_parts.tiles[i][_parts.tiles.length - 1] as TileData).state = States.RAND;
		}
		
		private function createBoard():void
		{
			Logger.log("Create Board");
			
			_board = new Board();
			
			_board.parts = _parts;
			_board.board_width = width;
			
			_board.addEventListener(BoardEvent.TILE_CLICK, onTileClicked, false, 0, true);
			
			addChild(_board);
		}
		
		public function startNewGame():void
		{
			Logger.log("Start New Game");
			
			_iColourCurrent = _iColourStarter;
			_iZetTeller = 0;
			
			resetPositions();
			createOuterBorder();
			startPosition();
			
			setTimeout(gameLoop, 100);
		}
			
		private function gameLoop():void
		{
			Logger.log("--------------------------------------- (" + _iZetTeller + ")");
			
			var arrLegalTurns:Array = _engine.legalActionPossible(_parts.tiles, _iColourCurrent);
			
			if(_iColourCurrent == PlayerColours.PLAYER1 && _isComputer)
			{
				Logger.log("Current turn: Computer (Player1)");
				
				// COMPUTER
				if(arrLegalTurns.length > 0)
				{
					_bPassPlayer1 = false;
					
					var t:Number = new Date().getTime();
					var td:TileData = _engine.getOptimalTurn(_parts.tiles, _iZetTeller, _iZetTeller > 50 ? 10 : _iDefaultDepth) as TileData;
					
					Logger.log("Execution time: " + (new Date().getTime() - t) + "ms");
					Logger.log("Tile Selected: " + td);
					
					td.state = _iColourCurrent;
					
					executeTurn(td);
				}
				else
				{
					Logger.log("Player 1 PASS");
					
					_bPassPlayer1 = true;
					
					checkEnd();
				}
			}
			else
			{
				Logger.log("Current turn: Player " + _iColourCurrent);
				
				// SPELER
				if(arrLegalTurns.length > 0)
				{
					_board.ready();
				}
				else
				{
					Logger.log("Player 2 PASS");
					
					_bPassPlayer2 = true;
					
					checkEnd();
				}
			}
		}
		
		private function resetPositions():void
		{
			Logger.log("Reset Position");
			
			_parts.reset();	
		}
		
		private function startPosition():void
		{
			Logger.log("Start Position");
			
			(_parts.tiles[(_iGridCount / 2 - 1)][(_iGridCount / 2 - 1)] as TileData).state = States.WIT;
			(_parts.tiles[(_iGridCount / 2 - 1)][(_iGridCount / 2)] as TileData).state = States.ZWART;
			(_parts.tiles[(_iGridCount / 2)][(_iGridCount / 2)] as TileData).state = States.WIT;
			(_parts.tiles[(_iGridCount / 2)][(_iGridCount / 2 - 1)] as TileData).state = States.ZWART;
			
			(_parts.tiles[(_iGridCount / 2)][(_iGridCount / 2 - 2)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 - 1)][(_iGridCount / 2 - 2)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 - 2)][(_iGridCount / 2 - 2)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 - 2)][(_iGridCount / 2 - 1)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 - 2)][(_iGridCount / 2)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 - 2)][(_iGridCount / 2 + 1)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 - 1)][(_iGridCount / 2 + 1)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2)][(_iGridCount / 2 + 1)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 + 1)][(_iGridCount / 2 + 1)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 + 1)][(_iGridCount / 2)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 + 1)][(_iGridCount / 2 - 1)] as TileData).state = States.ZET;
			(_parts.tiles[(_iGridCount / 2 + 1)][(_iGridCount / 2 - 2)] as TileData).state = States.ZET;
			
			_board.render();
		}
		
		private function onTileClicked(e:BoardEvent):void
		{
			var te:TileEvent = e.data as TileEvent;
			var t:Tile = te.target as Tile;
			var td:TileData = t.model as TileData;
			
			Logger.log("Tile Clicked: " + td.toString());
			
			if(_engine.legalAction(_engine.currentLegalTurns, td))
			{
				_bPassPlayer2 = false;
				
				td.state = _iColourCurrent;
				
				executeTurn(td);
			}
			else
			{
				Logger.log("No legal action, try again");
			}
		}
		
		private function executeTurn(td:TileData):void
		{
			// Logger.log("Execute Turn");
			
			_engine.flipTiles(_parts.tiles, td);
			
			_iZetTeller++;
			
			_board.render();
			
			checkEnd();
		}
		
		private function checkEnd():void
		{
			Logger.log("Check End");
			
			if(_engine.isEnd(_iZetTeller, _bPassPlayer1, _bPassPlayer2))
			{
				Logger.log("EINDE!");
				
				var iZwart:int = _engine.getScore(_parts.tiles);
				
				Logger.log("Computer : " + iZwart);
				Logger.log("Player2 : " + (0 - iZwart));
				
				dispatchEvent(new OthelloEvent(OthelloEvent.END_GAME));
			}
			else
			{
				if(_iColourCurrent == PlayerColours.PLAYER1)
					_iColourCurrent = PlayerColours.PLAYER2
				else
					_iColourCurrent = PlayerColours.PLAYER1;
					
				dispatchEvent(new OthelloEvent(OthelloEvent.PLAYER_SWITCH, false, false, _iColourCurrent));
					
				setTimeout(gameLoop, 100);
			}
		}
		
		public function getScore(pColour:Number):int
		{
			var iZwart:int = _engine.getScore(_parts.tiles);
				
			return pColour == PlayerColours.PLAYER1 ? iZwart : 0 - iZwart;
		}
		
		public function set grid_size(value:int):void
		{
			_iGridCount = value + 2;
		}
		
		public function set defaultDepth(value:int):void
		{
			_iDefaultDepth = value;
		}
	}
}