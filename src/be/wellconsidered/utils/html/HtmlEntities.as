package be.wellconsidered.utils.html
{
	import flash.xml.*
	
	public class HtmlEntities
	{
		public function HtmlEntities() {}
		
		public static function htmlEscape(str:String):String
		{
		    return XML(new XMLNode(XMLNodeType.TEXT_NODE, str)).toXMLString();
		}
		
		public static function htmlUnescape(str:String):String
		{
		    return new XMLDocument(str).firstChild.nodeValue;
		}
	}
}