/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.components
{
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    
    import qnx.ui.display.Image;
    import qnx.ui.listClasses.AlternatingCellRenderer;
    
    public class RosterListRenderer extends AlternatingCellRenderer
    {
        private var iconImage:Image = new Image();
        
        public function RosterListRenderer()
        {
            super();
            this.label.visible = true;
            this.addChild(this.iconImage);
        }
        
        override public function set data(value:Object):void
        {
            super.data = value;
            
            var item:RosterItemVO = value as RosterItemVO;
            var label:String = (item.displayName) ? item.displayName : item.uid; 
            setLabel(label);
        }
        
        override protected function drawLabel():void 
        {			
            if (this.data) 
            {
                if ((data as RosterItemVO).online)
                {
                    this.iconImage.setImage("/assets/available.png");
                }
                else
                {
                    this.iconImage.setImage("/assets/offline.png");
                }
                
                this.iconImage.x = this.width - 30;
                this.iconImage.y = this.height / 2 - 8;
            }
            
            super.drawLabel();
        }
    }
}
