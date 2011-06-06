/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.signals.signaltons
{
    import mx.collections.ArrayCollection;
    
    import org.osflash.signals.Signal;

    public class ChatRoomListChangedSignal extends Signal
    {
        public function ChatRoomListChangedSignal()
        {
            super(ArrayCollection);
        }
    }
}
