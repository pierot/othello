/**************************************
title: CoverFlow knockoff
author: John Dyer (johndyer.name)
license: MIT
*************************************/

package be.wellconsidered.display.coverflow
{	
    import flash.events.*;

	public class CoverFlowEvent extends Event 
	{	
		public static var READY:String = "Ready";
		
		public static var ITEM_FOCUS:String = "itemFocus";
		public static var ITEM_CLICK:String = "itemClick";		
		
		public static var FLOW_END:String = "FlowAtEnd";		
		public static var FLOW_START:String = "FlowAtStart";		

		public static var HOVER_OVER:String = "HoverOver";		
		public static var HOVER_OUT:String = "HoverOut";

		public var itemIndex:Number = -1;
		
		function CoverFlowEvent(type:String, itemIndex:Number)  
		{
			super(type);
		
			this.itemIndex = itemIndex;
		}
	}
}