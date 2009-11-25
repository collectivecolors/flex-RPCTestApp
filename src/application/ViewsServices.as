package application
{ 
	import com.collectivecolors.rpc.IServiceAgent;
	import com.collectivecolors.rpc.RemoteService;
	
	import mx.rpc.events.ResultEvent;
 
 
	public class ViewsServices extends RemoteService
	{
		/**
		 * Variables
		 **/
 
 		private static const GET : String = 'get';
 		
 		/**
 		 * Constructor
 		 **/
 
		public function ViewsServices( agent : IServiceAgent, urls : Array = null )
		{
			super( agent, urls );
 
			// Register view service handlers
			agent.register( GET, viewGetResultHandler, serviceFaultHandler );
		}
 
 
 
		/**
		 * Methods
		 **/
		 
		// Service methods
		public function viewGetHandlers( resultHandler : Function, faultHandler : Function = null ) : void
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
		
		// Convert the returned blog entry objects into easier to display BlogVO's
		protected function parseViewGetResult( result:Object ) : Array
		{
			var fullBlogs:Array = result as Array;
			//Sort the blogs based on their date of creation
			fullBlogs.sortOn("created");
			fullBlogs.reverse();
			//Create an array to hold the newly created BlogVO's
			var displayBlogs:Array = new Array;
			//Iterate through all of the returned blog objects and create BlogVO's out of them
			for(var i:int = 0 ; i<fullBlogs.length ; i++){
				var blog:BlogVO = new BlogVO();
				blog.title = fullBlogs[i].title;
				blog.dateCreated = fullBlogs[i].created;
				blog.teaser = fullBlogs[i].teaser;
				blog.path = fullBlogs[i].path;
				//Add the newly created BlogVO to the displayBlogs array
				displayBlogs.push(blog);
			}
			//Return the displayBlogs array
			return displayBlogs;
		}
	}
}