package be.wellconsidered.othello.view
{
	import be.wellconsidered.logging.Logger;
	import be.wellconsidered.othello.model.Parts;
	import be.wellconsidered.othello.model.TileData;
	import be.wellconsidered.othello.view.events.BoardEvent;
	import be.wellconsidered.othello.view.tile.Tile;
	import be.wellconsidered.othello.view.tile.events.TileEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class Board extends Sprite
	{
		private var _parts:Parts;
		private var _iWidth:int;
		
		private var _tiles:Array;
		
		public function Board()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			drawGrid();
		}
		
		private function drawGrid():void
		{
			var tileWidth:int = _iWidth / _parts.tiles.length;
			
			_tiles = new Array();
			
			for(var i:int = 0; i < _parts.tiles.length; i++)
			{
				var arrTiles:Array = _parts.tiles[i] as Array;
				
				for(var j:int = 0; j < arrTiles.length; j++)
				{
					var t:Tile = new Tile(tileWidth);
					
					t.model = _parts.tiles[i][j] as TileData;
					
					t.x = i * tileWidth; 
					t.y = j * tileWidth;
					
					addChild(t);
					
					_tiles.push(t);
				}				
			}
		}
		
		private function clearGrid():void
		{
			for(var i:int = 0; i < _tiles.length; i++)
			{
				var t:Tile = _tiles[i] as Tile;
				
				removeChild(t);
				
				t.removeEventListener(TileEvent.CLICK, onTileClicked);
				t = null;
			}
			
			_tiles = null;
		}
		
		public function ready():void
		{
			Logger.log("Board is ready for User Action");
			
			for(var i:int = 0; i < _tiles.length; i++)
			{
				var t:Tile = _tiles[i] as Tile;
				
				t.addEventListener(TileEvent.CLICK, onTileClicked, false, 0, true);
				
				t.ready();
			}
		}
		
		public function render():void
		{
			// Logger.log("Render Board");
			
			clearGrid();
			drawGrid();
		}
		
		private function onTileClicked(e:TileEvent):void
		{
			dispatchEvent(new BoardEvent(BoardEvent.TILE_CLICK, false, false, e));
		}
		
		public function set parts(value:Parts):void
		{
			_parts = value;
		}
		
		public function set board_width(value:int):void
		{
			_iWidth = value;
		}
	}
}