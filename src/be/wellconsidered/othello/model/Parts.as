package be.wellconsidered.othello.model
{
	import be.wellconsidered.othello.model.events.PartsEvent;
	
	import flash.events.EventDispatcher;
	
	public class Parts extends EventDispatcher
	{
		private var _arrTiles:Array;
		
		public function Parts(grid_count:int = 8)
		{
			_arrTiles = new Array();
			
			for(var i:int = 0; i < grid_count; i++)
			{
				_arrTiles[i] = new Array();
				
				for(var j:int = 0; j < grid_count; j++)
					_arrTiles[i][j] = new TileData(i, j);
			}
		}
		
		public function reset():void
		{
			for(var i:int = 0; i < tiles.length; i++)
			{
				var arrTiles:Array = tiles[i] as Array;
				
				for(var j:int = 0; j < arrTiles.length; j++)
				{
					tiles[i][j] = new TileData(i, j);
				}
			}
		}
		
		public function get tiles():Array
		{
			return _arrTiles;
		}
		
		public function set tiles(value:Array):void
		{
			_arrTiles = value;
			
			dispatchEvent(new PartsEvent(PartsEvent.TILES_CHANGED));
		}
	}
}