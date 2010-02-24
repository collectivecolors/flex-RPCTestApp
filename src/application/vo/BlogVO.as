package application.vo
{
	import mx.formatters.DateFormatter;
	
	public class BlogVO
	{
		//Variables
		private var created:Date = null;
		public var title:String;
		public var teaser:String;
		public var path:String;
		private var formatter:DateFormatter = new DateFormatter();
		
		public function BlogVO()
		{
			formatter.formatString = "MM.DD.YY";
		}
		
		public function set dateCreated(time:String):void{
			created = new Date(parseInt(time)*1000);
		}
		
		public function get dateCreated():String{
			if(created==null){
				return null;
			}
			return formatter.format(created);
		}
	}
}