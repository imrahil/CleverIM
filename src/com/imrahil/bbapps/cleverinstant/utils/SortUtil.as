/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.utils
{
    public class SortUtil
    {
        public function SortUtil()
        {
        }

        public static function sortComparePL(obj1:String, obj2:String):int 
        {
            if (obj1 == null && obj2 == null) return 0;
            else if (obj1 == null) return -1;
            else if (obj2 == null) return 1;
            
            var order:String = "0123456789AaĄąBbCcĆćDdEeĘęFfGgHhIiJjKkLlŁłMmNnŃńOoÓóPpQqRrSsŚśTtUuVvWwXxYyZzŹźŻż";
            
            var minLen:int
            var posA:int;
            var posB:int;
            if (!isNaN(Number(obj1)) && ! isNaN(Number(obj2))) 
            {
                if (Number(obj1) < Number(obj2)) return -1;
                else if (Number(obj1) > Number(obj2)) return 1;
                else return 0;
            }
            else
            {
                minLen = obj1.length < obj2.length ? obj1.length : obj2.length;
                var i:int = 0;
                for(; i < minLen; i++)
                {
                    posA = order.indexOf(obj1.slice(i, i + 1));
                    posB = order.indexOf(obj2.slice(i, i + 1));
                    if (posA < posB) return -1;
                    else if(posA > posB) return 1;
                }
                
                if (obj1.length < obj2.length) return -1;
                else if(obj1.length > obj2.length) return 1;
                else return 0;
            }
        }
    }
}
