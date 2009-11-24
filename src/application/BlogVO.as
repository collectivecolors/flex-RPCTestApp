package application
{
	public class BlogVO
	{
		//Variables
		private var created:Date = null;
		public var title:String;
		public var teaser:String;
		public var path:String;
		
		public function BlogVO()
		{
		}
		
		public function set dateCreated(time:String):void{
			
			created = new Date(parseInt(time)*1000);
		}
		
		public function get dateCreated():String{
			if(created==null){
				return null;
			}
			return created.toString();
		}
	}
}