/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.signals
{
    import org.igniterealtime.xiff.core.EscapedJID;
    import org.osflash.signals.Signal;

    public class ChatMessageReceivedSignal extends Signal
    {
        public function ChatMessageReceivedSignal()
        {
            super(EscapedJID, String);
        }
    }
}
