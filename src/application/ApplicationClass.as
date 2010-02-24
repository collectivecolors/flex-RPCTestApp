package application
{	
	import com.collectivecolors.rpc.AMFAgent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.effects.Pause;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import application.vo.*;
	import application.components.*;
	import application.services.*;
	
	public class ApplicationClass extends Application
	{
		/**
		 * MXML Components
		 **/
		 
		 public var lstBlogs:CustomList;
		 public var lstTerms:CustomList;
		 
		 
		 /**
		 * RPC Services
		 **/
		 
		 public var views:ViewsServices;

		/**
		 * Constructor And Creation Complete Handler
		 **/

		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}


		public function creationCompleteHandler(value:Event):void
		{	
			//Add Event Listeners
			lstBlogs.addEventListener(ListEvent.ITEM_CLICK, lstBlogsClickHandler);
			lstTerms.addEventListener(ListEvent.ITEM_CLICK, lstTermsClickHandler);
			
			//Create instance of AMFAgent with the "views" source
			var viewsAmfAgent:AMFAgent = new AMFAgent("views", null);
			//Set the URL to the Drupal Services Module we mean to connect with
			viewsAmfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			//Create instance of ViewsServices, and give it a reference to the above AMFAgent
			views = new ViewsServices(viewsAmfAgent, null);
			//Set the event handlers for the ViewsServices class
			views.viewGetHandlers(viewsConnectHandler, faultHandler);
			
			//Retrieve the popular blog terms
			retrieveBlogTerms();
			//Retrieve all blogs
			retrieveBlogs();
		}


		/**
		 * Event Handlers
		 **/
		 
		 //On a click to the blog list, open that blog's page in a new tab
		 public function lstBlogsClickHandler( event:ListEvent ):void{
		 	//Take them to that blog in a new browser window/tab
		 	var url:String = "http://services6.collectivecolors.com/" + lstBlogs.selectedItem.path;
		 	navigateToURL(new URLRequest(url));
		 }
		 
		 //On a click to the term list, filter for blogs that involve that term
		 public function lstTermsClickHandler( event:ListEvent ):void{
		 	//The "ALL" term is special as its not truly a term supported by the site, so we handle it locally
		 	//The "ALL" term is added by the parser in the ViewsServices class
		 	if(lstTerms.selectedItem == "ALL"){
		 		retrieveBlogs();
		 	}
		 	//The user has selected a specific term, so we'll give them only blogs that match that parameter
		 	else{
		 		retrieveBlogs(lstTerms.selectedItem as String);
		 	}
		 }
		
		//On return of the results from the ViewsServices class, determine what type of information it contains
		public function viewsConnectHandler( result:Array ):void{
			//Check to see if the returned results are BlogVOs
			if(result[0] is BlogVO){
				lstBlogs.dataProvider = result;
			}
			//Check to see if the returned results are Strings
			else if(result[0] is String){
				lstTerms.dataProvider = result; 
			}
		 }
		
		//On a fault from the ViewsService class
		 public function faultHandler( fault:Object ):void{
		 	//Display the fault
		 	Alert.show(String(fault));
		 }
		 
		 /**
		 * Methods
		 **/
		 
		 //Retrieves the current popular blog terms
		 public function retrieveBlogTerms():void{			
			views.viewGet("popular_blog_terms", "terms");
		 }
		 
		 //Retrieves either all blogs or blogs that contain a specific keyword depending on input
		 public function retrieveBlogs(term:String = null):void{
			//The user wants to search for all blog entries
			if(term == null){
		 		views.viewGet("recent_blog_entries", "blogs");
		 	}
		 	//The user only want to search for a specific keyword
		 	else{
		 		views.viewGet("recent_blog_entries", "blogs", term);
		 	}
		 }
	}
}