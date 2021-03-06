package application.services
{ 
	import com.collectivecolors.rpc.IServiceAgent;
	import com.collectivecolors.rpc.RemoteService;
	
	import mx.rpc.events.ResultEvent;

	import application.vo.*;

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
		public function viewGet( input:String , mode:String, searchTerm:String = null) : void
		{
			if(mode == "blogs"){
				if(searchTerm == null){
					agent.execute( GET , input, ["title" , "created", "teaser", "path", "uid"]);
				}
				else{
					agent.execute( GET , input, ["title" , "created", "teaser", "path", "uid"], [searchTerm]);
				}
			}
			else if(mode == "terms"){
				agent.execute( GET , input );
			}
		}

		//Executed when remote connect method returns sucessfully.
		protected function viewGetResultHandler( event : ResultEvent ) : void
		{
			executeResultHandler(event,  parseViewGetResult);
		}

		// Convert the returned blog entry objects into easier to display BlogVO's
		protected function parseViewGetResult( result:Object , parameters:Object) : Array
		{	
			if(parameters[0]=="popular_blog_terms"){
				var fullBlogTerms:Array = result as Array;
				//Create an array to hold the strings that we care about
				var blogTerms:Array = new Array;
				//Add an "All" option
				blogTerms.push("ALL");
				//Iterate through all of the returned objects and extract the important strings
				for(var i:int = 0 ; i<fullBlogTerms.length ; i++){
					//Add string to the blogTerms array
					blogTerms.push(fullBlogTerms[i].term_data_name);
				}
				//Return the displayBlogs array
				return blogTerms;
			}
			else if(parameters[0]=="recent_blog_entries"){
				var fullBlogs:Array=result as Array;
				//Sort the blogs based on their date of creation
				fullBlogs.sortOn("created");
				fullBlogs.reverse();
				//Create an array to hold the newly created BlogVO's
				var displayBlogs:Array=new Array;
				//Iterate through all of the returned blog objects and create BlogVO's out of them
				for (var j:int = 0; j < fullBlogs.length; j++)
				{
					var blog:BlogVO=new BlogVO();
					blog.title=fullBlogs[j].title;
					blog.dateCreated=fullBlogs[j].created;
					blog.teaser=fullBlogs[j].teaser;
					blog.path=fullBlogs[j].path;
					//Add the newly created BlogVO to the displayBlogs array
					displayBlogs.push(blog);
				}
				//Return the displayBlogs array
				return displayBlogs;
			}
			else{
				return null;
			}
		}
	}
}
