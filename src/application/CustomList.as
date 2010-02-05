package application
{
	import flash.display.Sprite;
	
	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;

	public class CustomList extends List
	{
		
	/**
     *  @private
     */
    override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
    {
        //super.drawHighlightIndicator(indicator, 0, y, unscaledWidth - viewMetrics.left - viewMetrics.right, height, color, itemRenderer);
    }

    /**
     *  @private
     */
    override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
    {
        //super.drawCaretIndicator(indicator, 0, y, unscaledWidth - viewMetrics.left - viewMetrics.right, height, color, itemRenderer);
    }

    /**
     *  @private
     */
    override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
    {
        //super.drawSelectionIndicator(indicator, 0, y, unscaledWidth - viewMetrics.left - viewMetrics.right, height, color, itemRenderer);
    }
		
	}
}