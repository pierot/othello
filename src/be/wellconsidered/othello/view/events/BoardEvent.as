package be.wellconsidered.othello.view.events
{
	import flash.events.Event;

	public class BoardEvent extends Event
	{
		public static var TILE_CLICK:String = "TileClick";
		
		private var _data:*;
		
		public function BoardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():*
		{
			return _data;
		}
	}
}