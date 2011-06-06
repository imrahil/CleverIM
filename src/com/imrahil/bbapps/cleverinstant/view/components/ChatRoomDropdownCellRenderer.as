/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.components
{
    import com.imrahil.bbapps.cleverinstant.model.vo.ChatRoomVO;
    
    import qnx.ui.listClasses.DropDownCellRenderer;
    
    public class ChatRoomDropdownCellRenderer extends DropDownCellRenderer
    {
        private var _chatRoom:ChatRoomVO;

        public function ChatRoomDropdownCellRenderer()
        {
            super();
        }
        
        override public function set data(value:Object):void
        {
            _chatRoom = value as ChatRoomVO;
            setLabel(_chatRoom.displayName);
        }
        
        override public function get data():Object
        {
            return _chatRoom;
        }
    }
}