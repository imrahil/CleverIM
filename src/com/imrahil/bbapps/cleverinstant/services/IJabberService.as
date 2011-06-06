/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.services
{
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    
    import org.igniterealtime.xiff.data.Message;

    public interface IJabberService
    {
        function connect(credentials:LoginCredentialsVO):void;
        function disconnect():void;
        function updatePresence(show:String, status:String):void;
        function send(message:Message):void;
    }
}