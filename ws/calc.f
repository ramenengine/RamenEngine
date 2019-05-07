: neg negate ;
: _   swap 10 * + ;

figure blank
s" Calculator" label
nr s"  /s " button s" dup " button s" over" button s" drop " button s" swap" button 
nr s" 7  _" button s" 8  _" button s" 9  _" button s"   /  " button
nr s" 4  _" button s" 5  _" button s" 6  _" button s"   *  " button
nr s" 1  _" button s" 2  _" button s" 3  _" button s"   -  " button
nr s" neg " button s" 0  _" button s" 10 /" button s"   +  " button
nr s"  */ " button s" mod " button s" /mod" button s"   0  " button 
nr s" sqrt" button s" cos " button s" sin " button s" atan2" button s" log2" button
nr s" pfloor" button s" pceil" button
0
