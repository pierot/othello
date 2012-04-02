package be.wellconsidered.othello.model.events
{
	import flash.events.Event;

	public class TileDataEvent extends Event
	{
		public static var CHANGE_COLOUR:String = "ChangeColour";
		public static var CHANGE_SIZE:String = "ChangeSize";
		public static var CHANGE_LOCKED:String = "ChangeLocked";
		
		public function TileDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}