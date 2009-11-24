package application
{ 
	import com.collectivecolors.rpc.IServiceAgent;
	import com.collectivecolors.rpc.RemoteService;
	
	import mx.rpc.events.ResultEvent;
 
 
	public class RemoteServices extends RemoteService
	{
		/**
		 * Variables
		 **/
 
		public static const SOURCE : String = 'views';
 		private static const GET : String = 'get';
 		
 		/**
 		 * Constructor
 		 **/
 
		public function RemoteServices( agent : IServiceAgent, urls : Array = null )
		{
			super( agent, urls );
 
			// Register view service handlers
			agent.register( GET, viewGetResultHandler, serviceFaultHandler );
		}
 
 
 
		/**
		 * Methods
		 **/
		 
		// Service methods
		public function viewGetHandlers( resultHandler : Function,
		                                 faultHandler : Function = null ) : void
		{
		  registerHandlers( GET, resultHandler, faultHandler );
		}
 
		//Execute remote connect method and return current user.
		public function viewGet( input:String ) : void
		{
		  agent.execute( GET , input );
		}
		
		//Executed when remote connect method returns sucessfully.
		protected function viewGetResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event,  parseViewGetResult);
		}
		
		// Result parsers
		protected function parseViewGetResult( result:Object ) : Array
		{
			var fullBlogs:Array = result as Array;
			var displayBlogs:Array = new Array;
			
			
			for(var i:int = 0 ; i<fullBlogs.length ; i++){
				var blog:BlogVO = new BlogVO();
				blog.title = fullBlogs[i].title;
				blog.dateCreated = fullBlogs[i].created;
				blog.teaser = fullBlogs[i].teaser;
				blog.path = fullBlogs[i].path;
				displayBlogs.push(blog);
			}
			displayBlogs.sortOn("path");
			
			return displayBlogs;
		}
	}
}