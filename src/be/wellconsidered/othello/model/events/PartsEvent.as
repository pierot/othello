package be.wellconsidered.othello.model.events
{
	import flash.events.Event;

	public class PartsEvent extends Event
	{
		public static var TILES_CHANGED:String = "TilesChanged";
		
		public function PartsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}