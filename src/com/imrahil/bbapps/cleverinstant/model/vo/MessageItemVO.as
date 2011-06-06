/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.model.vo
{
    public class MessageItemVO
    {
        public function MessageItemVO()
        {
        }
        
        private var _author:String;
        private var _message:String;
        
        public function get author():String
        {
            return _author;
        }

        public function set author(value:String):void
        {
            _author = value;
        }

        public function get message():String
        {
            return _message;
        }
        
        public function set message(value:String):void
        {
            _message = value;
        }
    }
}