/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.signals.signaltons
{
    import com.imrahil.bbapps.cleverinstant.model.vo.ChatRoomVO;
    
    import org.osflash.signals.Signal;

    public class ChatRoomChangedSignal extends Signal
    {
        public function ChatRoomChangedSignal()
        {
            super(ChatRoomVO);
        }
    }
}
