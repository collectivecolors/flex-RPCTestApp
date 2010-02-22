package application
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDetail;

	public class CustomList extends List
	{

		public function CustomList()
		{
			super();
		}

		/**
		 *  @private
		 */
		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			
		}

		/**
		 *  @private
		 */
		override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			
		}

		/**
		 *  @private
		 */
		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			
		}

	}
}
