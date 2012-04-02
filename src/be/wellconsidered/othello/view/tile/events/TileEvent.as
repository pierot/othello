package be.wellconsidered.othello.view.tile.events
{
	import flash.events.Event;

	public class TileEvent extends Event
	{
		public static var CLICK:String = "Click"; 
		
		public function TileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}