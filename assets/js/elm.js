(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS
//
// For some reason, tabs can appear in href protocols and it still works.
// So '\tjava\tSCRIPT:alert("!!!")' and 'javascript:alert("!!!")' are the same
// in practice. That is why _VirtualDom_RE_js and _VirtualDom_RE_js_html look
// so freaky.
//
// Pulling the regular expressions out to the top level gives a slight speed
// boost in small benchmarks (4-10%) but hoisting values to reduce allocation
// can be unpredictable in large programs where JIT may have a harder time with
// functions are not fully self-contained. The benefit is more that the js and
// js_html ones are so weird that I prefer to see them near each other.


var _VirtualDom_RE_script = /^script$/i;
var _VirtualDom_RE_on_formAction = /^(on|formAction$)/i;
var _VirtualDom_RE_js = /^\s*j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:/i;
var _VirtualDom_RE_js_html = /^\s*(j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:|d\s*a\s*t\s*a\s*:\s*t\s*e\s*x\s*t\s*\/\s*h\s*t\s*m\s*l\s*(,|;))/i;


function _VirtualDom_noScript(tag)
{
	return _VirtualDom_RE_script.test(tag) ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return _VirtualDom_RE_on_formAction.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return _VirtualDom_RE_js.test(value)
		? /**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return _VirtualDom_RE_js_html.test(value)
		? /**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlJson(value)
{
	return (typeof _Json_unwrap(value) === 'string' && _VirtualDom_RE_js_html.test(_Json_unwrap(value)))
		? _Json_wrap(
			/**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		) : value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}


// CREATE

var _Regex_never = /.^/;

var _Regex_fromStringWith = F2(function(options, string)
{
	var flags = 'g';
	if (options.multiline) { flags += 'm'; }
	if (options.caseInsensitive) { flags += 'i'; }

	try
	{
		return $elm$core$Maybe$Just(new RegExp(string, flags));
	}
	catch(error)
	{
		return $elm$core$Maybe$Nothing;
	}
});


// USE

var _Regex_contains = F2(function(re, string)
{
	return string.match(re) !== null;
});


var _Regex_findAtMost = F3(function(n, re, str)
{
	var out = [];
	var number = 0;
	var string = str;
	var lastIndex = re.lastIndex;
	var prevLastIndex = -1;
	var result;
	while (number++ < n && (result = re.exec(string)))
	{
		if (prevLastIndex == re.lastIndex) break;
		var i = result.length - 1;
		var subs = new Array(i);
		while (i > 0)
		{
			var submatch = result[i];
			subs[--i] = submatch
				? $elm$core$Maybe$Just(submatch)
				: $elm$core$Maybe$Nothing;
		}
		out.push(A4($elm$regex$Regex$Match, result[0], result.index, number, _List_fromArray(subs)));
		prevLastIndex = re.lastIndex;
	}
	re.lastIndex = lastIndex;
	return _List_fromArray(out);
});


var _Regex_replaceAtMost = F4(function(n, re, replacer, string)
{
	var count = 0;
	function jsReplacer(match)
	{
		if (count++ >= n)
		{
			return match;
		}
		var i = arguments.length - 3;
		var submatches = new Array(i);
		while (i > 0)
		{
			var submatch = arguments[i];
			submatches[--i] = submatch
				? $elm$core$Maybe$Just(submatch)
				: $elm$core$Maybe$Nothing;
		}
		return replacer(A4($elm$regex$Regex$Match, match, arguments[arguments.length - 2], count, _List_fromArray(submatches)));
	}
	return string.replace(re, jsReplacer);
});

var _Regex_splitAtMost = F3(function(n, re, str)
{
	var string = str;
	var out = [];
	var start = re.lastIndex;
	var restoreLastIndex = re.lastIndex;
	while (n--)
	{
		var result = re.exec(string);
		if (!result) break;
		out.push(string.slice(start, result.index));
		start = re.lastIndex;
	}
	out.push(string.slice(start));
	re.lastIndex = restoreLastIndex;
	return _List_fromArray(out);
});

var _Regex_infinity = Infinity;



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});



function _Time_now(millisToPosix)
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(millisToPosix(Date.now())));
	});
}

var _Time_setInterval = F2(function(interval, task)
{
	return _Scheduler_binding(function(callback)
	{
		var id = setInterval(function() { _Scheduler_rawSpawn(task); }, interval);
		return function() { clearInterval(id); };
	});
});

function _Time_here()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(
			A2($elm$time$Time$customZone, -(new Date().getTimezoneOffset()), _List_Nil)
		));
	});
}


function _Time_getZoneName()
{
	return _Scheduler_binding(function(callback)
	{
		try
		{
			var name = $elm$time$Time$Name(Intl.DateTimeFormat().resolvedOptions().timeZone);
		}
		catch (e)
		{
			var name = $elm$time$Time$Offset(new Date().getTimezoneOffset());
		}
		callback(_Scheduler_succeed(name));
	});
}
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$List$cons = _List_cons;
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var $elm$url$Url$Http = {$: 'Http'};
var $elm$url$Url$Https = {$: 'Https'};
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 'Nothing') {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Http,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Https,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0.a;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2($elm$core$Task$map, toMessage, task)));
	});
var $elm$browser$Browser$element = _Browser_element;
var $author$project$Main$GotSeed = function (a) {
	return {$: 'GotSeed', a: a};
};
var $author$project$Main$Menu = {$: 'Menu'};
var $author$project$PortDefinition$RegisterSounds = function (a) {
	return {$: 'RegisterSounds', a: a};
};
var $author$project$Direction$Down = {$: 'Down'};
var $author$project$Direction$Left = {$: 'Left'};
var $author$project$Entity$Player = {$: 'Player'};
var $author$project$Direction$Right = {$: 'Right'};
var $author$project$Direction$Up = {$: 'Up'};
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $author$project$Game$insert = F3(
	function (pos, entity, game) {
		return _Utils_update(
			game,
			{
				cells: A3(
					$elm$core$Dict$insert,
					pos,
					{entity: entity, id: game.nextId},
					game.cells),
				nextId: game.nextId + 1
			});
	});
var $author$project$Config$roomSize = 5;
var $author$project$Game$addPlayer = F2(
	function (_v0, game) {
		var x = _v0.a;
		var y = _v0.b;
		return A3(
			$author$project$Game$insert,
			_Utils_Tuple2(x, y),
			$author$project$Entity$Player,
			_Utils_update(
				game,
				{
					playerDirection: (!x) ? $author$project$Direction$Right : (_Utils_eq(x, $author$project$Config$roomSize - 1) ? $author$project$Direction$Left : ((!y) ? $author$project$Direction$Down : $author$project$Direction$Up)),
					playerPos: $elm$core$Maybe$Just(
						_Utils_Tuple2(x, y))
				}));
	});
var $author$project$Gen$Sound$Explosion = {$: 'Explosion'};
var $author$project$Gen$Sound$Move = {$: 'Move'};
var $author$project$Gen$Sound$Push = {$: 'Push'};
var $author$project$Gen$Sound$Retry = {$: 'Retry'};
var $author$project$Gen$Sound$Undo = {$: 'Undo'};
var $author$project$Gen$Sound$Win = {$: 'Win'};
var $author$project$Gen$Sound$asList = _List_fromArray(
	[$author$project$Gen$Sound$Explosion, $author$project$Gen$Sound$Move, $author$project$Gen$Sound$Push, $author$project$Gen$Sound$Retry, $author$project$Gen$Sound$Undo, $author$project$Gen$Sound$Win]);
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $dillonkearns$elm_ts_json$TsJson$Encode$encoder = F2(
	function (_v0, input) {
		var encodeFn = _v0.a;
		return encodeFn(input);
	});
var $dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder = F2(
	function (a, b) {
		return {$: 'Decoder', a: a, b: b};
	});
var $dillonkearns$elm_ts_json$Internal$TsJsonType$Literal = function (a) {
	return {$: 'Literal', a: a};
};
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $elm$json$Json$Decode$fail = _Json_fail;
var $elm$json$Json$Decode$value = _Json_decodeValue;
var $dillonkearns$elm_ts_json$TsJson$Decode$literal = F2(
	function (value_, literalValue) {
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder,
			A2(
				$elm$json$Json$Decode$andThen,
				function (decodeValue) {
					return _Utils_eq(literalValue, decodeValue) ? $elm$json$Json$Decode$succeed(value_) : $elm$json$Json$Decode$fail(
						'Expected the following literal value: ' + A2($elm$json$Json$Encode$encode, 0, literalValue));
				},
				$elm$json$Json$Decode$value),
			$dillonkearns$elm_ts_json$Internal$TsJsonType$Literal(literalValue));
	});
var $elm$json$Json$Encode$null = _Json_encodeNull;
var $dillonkearns$elm_ts_json$TsJson$Decode$null = function (value_) {
	return A2($dillonkearns$elm_ts_json$TsJson$Decode$literal, value_, $elm$json$Json$Encode$null);
};
var $author$project$PortDefinition$flags = $dillonkearns$elm_ts_json$TsJson$Decode$null(
	{});
var $dillonkearns$elm_ts_json$Internal$TsJsonType$Boolean = {$: 'Boolean'};
var $dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder = F2(
	function (a, b) {
		return {$: 'Encoder', a: a, b: b};
	});
var $elm$json$Json$Encode$bool = _Json_wrap;
var $dillonkearns$elm_ts_json$TsJson$Encode$bool = A2($dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder, $elm$json$Json$Encode$bool, $dillonkearns$elm_ts_json$Internal$TsJsonType$Boolean);
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $dillonkearns$elm_ts_json$Internal$TsJsonType$TsNever = {$: 'TsNever'};
var $dillonkearns$elm_ts_json$Internal$TsJsonType$Union = function (a) {
	return {$: 'Union', a: a};
};
var $dillonkearns$elm_ts_json$Internal$TsJsonType$Unknown = {$: 'Unknown'};
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $elm$core$Basics$neq = _Utils_notEqual;
var $dillonkearns$elm_ts_json$Internal$TypeReducer$union = function (tsTypes) {
	var withoutNevers = A2(
		$elm$core$List$filter,
		$elm$core$Basics$neq($dillonkearns$elm_ts_json$Internal$TsJsonType$TsNever),
		tsTypes);
	var hadNevers = !_Utils_eq(
		$elm$core$List$length(tsTypes),
		$elm$core$List$length(withoutNevers));
	if (!withoutNevers.b) {
		return hadNevers ? $dillonkearns$elm_ts_json$Internal$TsJsonType$TsNever : $dillonkearns$elm_ts_json$Internal$TsJsonType$Unknown;
	} else {
		if (!withoutNevers.b.b) {
			var singleType = withoutNevers.a;
			return singleType;
		} else {
			var first = withoutNevers.a;
			var rest = withoutNevers.b;
			return $dillonkearns$elm_ts_json$Internal$TsJsonType$Union(
				_Utils_Tuple2(first, rest));
		}
	}
};
var $dillonkearns$elm_ts_json$TsJson$Encode$unwrapUnion = function (_v0) {
	var rawValue = _v0.a;
	return rawValue;
};
var $dillonkearns$elm_ts_json$TsJson$Encode$buildUnion = function (_v0) {
	var toValue = _v0.a;
	var tsTypes_ = _v0.b;
	return A2(
		$dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder,
		A2($elm$core$Basics$composeR, toValue, $dillonkearns$elm_ts_json$TsJson$Encode$unwrapUnion),
		$dillonkearns$elm_ts_json$Internal$TypeReducer$union(tsTypes_));
};
var $dillonkearns$elm_ts_json$Internal$TsJsonType$List = function (a) {
	return {$: 'List', a: a};
};
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var $dillonkearns$elm_ts_json$TsJson$Encode$list = function (_v0) {
	var encodeFn = _v0.a;
	var tsType_ = _v0.b;
	return A2(
		$dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder,
		function (input) {
			return A2($elm$json$Json$Encode$list, encodeFn, input);
		},
		$dillonkearns$elm_ts_json$Internal$TsJsonType$List(tsType_));
};
var $dillonkearns$elm_ts_json$TsJson$Encode$map = F2(
	function (mapFunction, _v0) {
		var encodeFn = _v0.a;
		var tsType_ = _v0.b;
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder,
			function (input) {
				return encodeFn(
					mapFunction(input));
			},
			tsType_);
	});
var $dillonkearns$elm_ts_json$Internal$TsJsonType$TypeObject = function (a) {
	return {$: 'TypeObject', a: a};
};
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			$elm$core$List$foldl,
			F2(
				function (_v0, obj) {
					var k = _v0.a;
					var v = _v0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var $dillonkearns$elm_ts_json$TsJson$Encode$object = function (propertyEncoders) {
	var propertyTypes = $dillonkearns$elm_ts_json$Internal$TsJsonType$TypeObject(
		A2(
			$elm$core$List$map,
			function (_v1) {
				var optionality = _v1.a;
				var propertyName = _v1.b;
				var tsType_ = _v1.d;
				return _Utils_Tuple3(optionality, propertyName, tsType_);
			},
			propertyEncoders));
	var encodeObject = function (input) {
		return $elm$json$Json$Encode$object(
			A2(
				$elm$core$List$filterMap,
				function (_v0) {
					var propertyName = _v0.b;
					var encodeFn = _v0.c;
					return A2(
						$elm$core$Maybe$map,
						function (encoded) {
							return _Utils_Tuple2(propertyName, encoded);
						},
						encodeFn(input));
				},
				propertyEncoders));
	};
	return A2($dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder, encodeObject, propertyTypes);
};
var $dillonkearns$elm_ts_json$TsJson$Encode$Property = F4(
	function (a, b, c, d) {
		return {$: 'Property', a: a, b: b, c: c, d: d};
	});
var $dillonkearns$elm_ts_json$Internal$TsJsonType$Required = {$: 'Required'};
var $dillonkearns$elm_ts_json$TsJson$Encode$required = F3(
	function (name, getter, _v0) {
		var encodeFn = _v0.a;
		var tsType_ = _v0.b;
		return A4(
			$dillonkearns$elm_ts_json$TsJson$Encode$Property,
			$dillonkearns$elm_ts_json$Internal$TsJsonType$Required,
			name,
			function (input) {
				return $elm$core$Maybe$Just(
					encodeFn(
						getter(input)));
			},
			tsType_);
	});
var $dillonkearns$elm_ts_json$Internal$TsJsonType$String = {$: 'String'};
var $elm$json$Json$Encode$string = _Json_wrap;
var $dillonkearns$elm_ts_json$TsJson$Encode$string = A2($dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder, $elm$json$Json$Encode$string, $dillonkearns$elm_ts_json$Internal$TsJsonType$String);
var $author$project$Gen$Sound$toString = function (sound) {
	switch (sound.$) {
		case 'Explosion':
			return 'explosion.wav';
		case 'Move':
			return 'move.wav';
		case 'Push':
			return 'push.wav';
		case 'Retry':
			return 'retry.wav';
		case 'Undo':
			return 'undo.wav';
		default:
			return 'win.wav';
	}
};
var $dillonkearns$elm_ts_json$TsJson$Internal$Encode$UnionBuilder = F2(
	function (a, b) {
		return {$: 'UnionBuilder', a: a, b: b};
	});
var $dillonkearns$elm_ts_json$TsJson$Encode$union = function (constructor) {
	return A2($dillonkearns$elm_ts_json$TsJson$Internal$Encode$UnionBuilder, constructor, _List_Nil);
};
var $dillonkearns$elm_ts_json$TsJson$Encode$literal = function (literalValue) {
	return A2(
		$dillonkearns$elm_ts_json$TsJson$Internal$Encode$Encoder,
		function (_v0) {
			return literalValue;
		},
		$dillonkearns$elm_ts_json$Internal$TsJsonType$Literal(literalValue));
};
var $dillonkearns$elm_ts_json$TsJson$Internal$Encode$UnionEncodeValue = function (a) {
	return {$: 'UnionEncodeValue', a: a};
};
var $dillonkearns$elm_ts_json$TsJson$Encode$variant = F2(
	function (_v0, _v1) {
		var encoder_ = _v0.a;
		var tsType_ = _v0.b;
		var builder = _v1.a;
		var tsTypes_ = _v1.b;
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Internal$Encode$UnionBuilder,
			builder(
				A2($elm$core$Basics$composeR, encoder_, $dillonkearns$elm_ts_json$TsJson$Internal$Encode$UnionEncodeValue)),
			A2($elm$core$List$cons, tsType_, tsTypes_));
	});
var $dillonkearns$elm_ts_json$TsJson$Encode$variantObject = F3(
	function (variantName, objectFields, unionBuilder) {
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Encode$variant,
			$dillonkearns$elm_ts_json$TsJson$Encode$object(
				A2(
					$elm$core$List$cons,
					A3(
						$dillonkearns$elm_ts_json$TsJson$Encode$required,
						'tag',
						$elm$core$Basics$identity,
						$dillonkearns$elm_ts_json$TsJson$Encode$literal(
							$elm$json$Json$Encode$string(variantName))),
					objectFields)),
			unionBuilder);
	});
var $dillonkearns$elm_ts_json$TsJson$Encode$variantTagged = F3(
	function (tagName, dataEncoder, builder) {
		return A3(
			$dillonkearns$elm_ts_json$TsJson$Encode$variantObject,
			tagName,
			_List_fromArray(
				[
					A3($dillonkearns$elm_ts_json$TsJson$Encode$required, 'data', $elm$core$Basics$identity, dataEncoder)
				]),
			builder);
	});
var $author$project$PortDefinition$fromElm = function () {
	var soundEncoder = A2($dillonkearns$elm_ts_json$TsJson$Encode$map, $author$project$Gen$Sound$toString, $dillonkearns$elm_ts_json$TsJson$Encode$string);
	return $dillonkearns$elm_ts_json$TsJson$Encode$buildUnion(
		A3(
			$dillonkearns$elm_ts_json$TsJson$Encode$variantTagged,
			'registerSounds',
			$dillonkearns$elm_ts_json$TsJson$Encode$list(soundEncoder),
			A3(
				$dillonkearns$elm_ts_json$TsJson$Encode$variantTagged,
				'stopSound',
				soundEncoder,
				A3(
					$dillonkearns$elm_ts_json$TsJson$Encode$variantTagged,
					'playSound',
					$dillonkearns$elm_ts_json$TsJson$Encode$object(
						_List_fromArray(
							[
								A3(
								$dillonkearns$elm_ts_json$TsJson$Encode$required,
								'sound',
								function (obj) {
									return $author$project$Gen$Sound$toString(obj.sound);
								},
								$dillonkearns$elm_ts_json$TsJson$Encode$string),
								A3(
								$dillonkearns$elm_ts_json$TsJson$Encode$required,
								'looping',
								function ($) {
									return $.looping;
								},
								$dillonkearns$elm_ts_json$TsJson$Encode$bool)
							])),
					$dillonkearns$elm_ts_json$TsJson$Encode$union(
						F4(
							function (playSound, stopSound, registerSounds, value) {
								switch (value.$) {
									case 'RegisterSounds':
										var list = value.a;
										return registerSounds(list);
									case 'PlaySound':
										var args = value.a;
										return playSound(args);
									default:
										var args = value.a;
										return stopSound(args);
								}
							}))))));
}();
var $author$project$PortDefinition$SoundEnded = function (a) {
	return {$: 'SoundEnded', a: a};
};
var $dillonkearns$elm_ts_json$Internal$TsJsonType$ArrayIndex = F2(
	function (a, b) {
		return {$: 'ArrayIndex', a: a, b: b};
	});
var $dillonkearns$elm_ts_json$Internal$TsJsonType$Intersection = function (a) {
	return {$: 'Intersection', a: a};
};
var $dillonkearns$elm_ts_json$Internal$TsJsonType$Optional = {$: 'Optional'};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Dict$values = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, valueList) {
				return A2($elm$core$List$cons, value, valueList);
			}),
		_List_Nil,
		dict);
};
var $dillonkearns$elm_ts_json$Internal$TypeReducer$deduplicateBy = F2(
	function (toComparable, list) {
		return $elm$core$Dict$values(
			A3(
				$elm$core$List$foldl,
				F2(
					function (value, accum) {
						return A3(
							$elm$core$Dict$insert,
							toComparable(value),
							value,
							accum);
					}),
				$elm$core$Dict$empty,
				list));
	});
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === 'RBNode_elm_builtin') {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === 'RBNode_elm_builtin') {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === 'RBNode_elm_builtin') {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _v0 = alter(
			A2($elm$core$Dict$get, targetKey, dictionary));
		if (_v0.$ === 'Just') {
			var value = _v0.a;
			return A3($elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2($elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var $elm_community$dict_extra$Dict$Extra$insertDedupe = F4(
	function (combine, key, value, dict) {
		var _with = function (mbValue) {
			if (mbValue.$ === 'Just') {
				var oldValue = mbValue.a;
				return $elm$core$Maybe$Just(
					A2(combine, oldValue, value));
			} else {
				return $elm$core$Maybe$Just(value);
			}
		};
		return A3($elm$core$Dict$update, key, _with, dict);
	});
var $elm_community$dict_extra$Dict$Extra$fromListDedupeBy = F3(
	function (combine, keyfn, xs) {
		return A3(
			$elm$core$List$foldl,
			F2(
				function (x, acc) {
					return A4(
						$elm_community$dict_extra$Dict$Extra$insertDedupe,
						combine,
						keyfn(x),
						x,
						acc);
				}),
			$elm$core$Dict$empty,
			xs);
	});
var $dillonkearns$elm_ts_json$Internal$TypeReducer$either = F2(
	function (predicateFn, _v0) {
		var type1 = _v0.a;
		var type2 = _v0.b;
		return predicateFn(type1) || predicateFn(type2);
	});
var $dillonkearns$elm_ts_json$Internal$TypeReducer$isNonEmptyObject = function (tsType) {
	if ((tsType.$ === 'TypeObject') && tsType.a.b) {
		var _v1 = tsType.a;
		var atLeastOne = _v1.a;
		var possiblyMore = _v1.b;
		return true;
	} else {
		return false;
	}
};
var $dillonkearns$elm_ts_json$Internal$TypeReducer$isPrimitive = function (tsType) {
	switch (tsType.$) {
		case 'Number':
			return true;
		case 'Integer':
			return true;
		case 'String':
			return true;
		case 'Boolean':
			return true;
		default:
			return false;
	}
};
var $dillonkearns$elm_ts_json$Internal$TypeReducer$isContradictory = function (types) {
	return A2($dillonkearns$elm_ts_json$Internal$TypeReducer$either, $dillonkearns$elm_ts_json$Internal$TypeReducer$isNonEmptyObject, types) && A2($dillonkearns$elm_ts_json$Internal$TypeReducer$either, $dillonkearns$elm_ts_json$Internal$TypeReducer$isPrimitive, types);
};
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $elm$core$List$maximum = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(
			A3($elm$core$List$foldl, $elm$core$Basics$max, x, xs));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $dillonkearns$elm_ts_json$Internal$TypeToString$parenthesize = function (string) {
	return '(' + (string + ')');
};
var $dillonkearns$elm_ts_json$Internal$TypeToString$doubleQuote = function (string) {
	return '\"' + (string + '\"');
};
var $elm$regex$Regex$Match = F4(
	function (match, index, number, submatches) {
		return {index: index, match: match, number: number, submatches: submatches};
	});
var $elm$regex$Regex$find = _Regex_findAtMost(_Regex_infinity);
var $elm$regex$Regex$fromStringWith = _Regex_fromStringWith;
var $elm$regex$Regex$fromString = function (string) {
	return A2(
		$elm$regex$Regex$fromStringWith,
		{caseInsensitive: false, multiline: false},
		string);
};
var $elm$regex$Regex$never = _Regex_never;
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $dillonkearns$elm_ts_json$Internal$TypeToString$identifierRegex = A2(
	$elm$core$Maybe$withDefault,
	$elm$regex$Regex$never,
	$elm$regex$Regex$fromString('^[a-zA-Z_][a-zA-Z0-9_]*$'));
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $dillonkearns$elm_ts_json$Internal$TypeToString$isIdentifier = A2(
	$elm$core$Basics$composeR,
	$elm$regex$Regex$find($dillonkearns$elm_ts_json$Internal$TypeToString$identifierRegex),
	$elm$core$List$isEmpty);
var $dillonkearns$elm_ts_json$Internal$TypeToString$quoteObjectKey = function (key) {
	var needsQuotes = $dillonkearns$elm_ts_json$Internal$TypeToString$isIdentifier(key);
	return needsQuotes ? $dillonkearns$elm_ts_json$Internal$TypeToString$doubleQuote(key) : key;
};
var $elm$core$List$sortBy = _List_sortBy;
var $dillonkearns$elm_ts_json$Internal$TypeToString$parenthesizeToString = function (type_) {
	var needsParens = function () {
		if (type_.$ === 'Union') {
			var types = type_.a;
			return true;
		} else {
			return false;
		}
	}();
	return needsParens ? $dillonkearns$elm_ts_json$Internal$TypeToString$parenthesize(
		$dillonkearns$elm_ts_json$Internal$TypeToString$toString(type_)) : $dillonkearns$elm_ts_json$Internal$TypeToString$toString(type_);
};
var $dillonkearns$elm_ts_json$Internal$TypeToString$toString = function (tsType_) {
	switch (tsType_.$) {
		case 'TsNever':
			return 'never';
		case 'String':
			return 'string';
		case 'Integer':
			return 'number';
		case 'Number':
			return 'number';
		case 'Boolean':
			return 'boolean';
		case 'Unknown':
			return 'JsonValue';
		case 'List':
			var listType = tsType_.a;
			return $dillonkearns$elm_ts_json$Internal$TypeToString$parenthesizeToString(listType) + '[]';
		case 'Literal':
			var literalValue = tsType_.a;
			return A2($elm$json$Json$Encode$encode, 0, literalValue);
		case 'Union':
			var _v1 = tsType_.a;
			var firstType = _v1.a;
			var tsTypes = _v1.b;
			return A2(
				$elm$core$String$join,
				' | ',
				A2(
					$elm$core$List$map,
					$dillonkearns$elm_ts_json$Internal$TypeToString$parenthesizeToString,
					A2($elm$core$List$cons, firstType, tsTypes)));
		case 'TypeObject':
			var keyTypes = tsType_.a;
			return '{ ' + (A2(
				$elm$core$String$join,
				'; ',
				A2(
					$elm$core$List$map,
					function (_v3) {
						var optionality = _v3.a;
						var key = _v3.b;
						var tsType__ = _v3.c;
						var quotedKey = $dillonkearns$elm_ts_json$Internal$TypeToString$quoteObjectKey(key);
						return function () {
							if (optionality.$ === 'Required') {
								return quotedKey;
							} else {
								return quotedKey + '?';
							}
						}() + (' : ' + $dillonkearns$elm_ts_json$Internal$TypeToString$toString(tsType__));
					},
					A2(
						$elm$core$List$sortBy,
						function (_v2) {
							var fieldName = _v2.b;
							return fieldName;
						},
						keyTypes))) + ' }');
		case 'ObjectWithUniformValues':
			var tsType = tsType_.a;
			return '{ [key: string]: ' + ($dillonkearns$elm_ts_json$Internal$TypeToString$toString(tsType) + ' }');
		case 'Tuple':
			var tsTypes = tsType_.a;
			var maybeRestType = tsType_.b;
			var restTypePart = A2(
				$elm$core$Maybe$map,
				function (restType) {
					return '...(' + ($dillonkearns$elm_ts_json$Internal$TypeToString$toString(restType) + ')[]');
				},
				maybeRestType);
			return '[ ' + (A2(
				$elm$core$String$join,
				', ',
				A2(
					$elm$core$List$filterMap,
					$elm$core$Basics$identity,
					_Utils_ap(
						A2(
							$elm$core$List$map,
							function (type_) {
								return $elm$core$Maybe$Just(
									$dillonkearns$elm_ts_json$Internal$TypeToString$toString(type_));
							},
							tsTypes),
						_List_fromArray(
							[restTypePart])))) + ' ]');
		case 'Intersection':
			var types = tsType_.a;
			return $dillonkearns$elm_ts_json$Internal$TypeToString$parenthesize(
				A2(
					$elm$core$String$join,
					' & ',
					A2($elm$core$List$map, $dillonkearns$elm_ts_json$Internal$TypeToString$parenthesizeToString, types)));
		default:
			var _v5 = tsType_.a;
			var index = _v5.a;
			var tsType = _v5.b;
			var otherIndices = tsType_.b;
			var dict = $elm$core$Dict$fromList(
				A2(
					$elm$core$List$cons,
					_Utils_Tuple2(index, tsType),
					otherIndices));
			var highestIndex = A2(
				$elm$core$Maybe$withDefault,
				0,
				$elm$core$List$maximum(
					$elm$core$Dict$keys(dict)));
			return '[' + (A2(
				$elm$core$String$join,
				',',
				_Utils_ap(
					A2(
						$elm$core$List$map,
						function (cur) {
							return $dillonkearns$elm_ts_json$Internal$TypeToString$toString(
								A2(
									$elm$core$Maybe$withDefault,
									$dillonkearns$elm_ts_json$Internal$TsJsonType$Unknown,
									A2($elm$core$Dict$get, cur, dict)));
						},
						A2($elm$core$List$range, 0, highestIndex)),
					_List_fromArray(
						['...JsonValue[]']))) + ']');
	}
};
var $dillonkearns$elm_ts_json$Internal$TypeReducer$intersect = F2(
	function (type1, type2) {
		if ($dillonkearns$elm_ts_json$Internal$TypeReducer$isContradictory(
			_Utils_Tuple2(type1, type2))) {
			return $dillonkearns$elm_ts_json$Internal$TsJsonType$TsNever;
		} else {
			if (_Utils_eq(type1, type2)) {
				return type1;
			} else {
				var _v8 = _Utils_Tuple2(type1, type2);
				_v8$1:
				while (true) {
					_v8$8:
					while (true) {
						switch (_v8.a.$) {
							case 'Unknown':
								var _v9 = _v8.a;
								var known = _v8.b;
								return known;
							case 'Intersection':
								switch (_v8.b.$) {
									case 'Unknown':
										break _v8$1;
									case 'Intersection':
										var types1 = _v8.a.a;
										var types2 = _v8.b.a;
										return $dillonkearns$elm_ts_json$Internal$TypeReducer$simplifyIntersection(
											_Utils_ap(types1, types2));
									default:
										break _v8$8;
								}
							case 'ArrayIndex':
								switch (_v8.b.$) {
									case 'Unknown':
										break _v8$1;
									case 'ArrayIndex':
										if ((!_v8.a.b.b) && (!_v8.b.b.b)) {
											var _v11 = _v8.a;
											var _v12 = _v11.a;
											var index1 = _v12.a;
											var indexType1 = _v12.b;
											var _v13 = _v8.b;
											var _v14 = _v13.a;
											var index2 = _v14.a;
											var indexType2 = _v14.b;
											return A2(
												$dillonkearns$elm_ts_json$Internal$TsJsonType$ArrayIndex,
												_Utils_Tuple2(index1, indexType1),
												_List_fromArray(
													[
														_Utils_Tuple2(index2, indexType2)
													]));
										} else {
											break _v8$8;
										}
									default:
										break _v8$8;
								}
							case 'TypeObject':
								switch (_v8.b.$) {
									case 'Unknown':
										break _v8$1;
									case 'TypeObject':
										var fields1 = _v8.a.a;
										var fields2 = _v8.b.a;
										return $dillonkearns$elm_ts_json$Internal$TsJsonType$TypeObject(
											A2($dillonkearns$elm_ts_json$Internal$TypeReducer$mergeFields, fields1, fields2));
									case 'Union':
										var fields1 = _v8.a.a;
										var unionedTypes = _v8.b.a;
										return $dillonkearns$elm_ts_json$Internal$TsJsonType$Intersection(
											_List_fromArray(
												[type1, type2]));
									default:
										break _v8$8;
								}
							case 'String':
								switch (_v8.b.$) {
									case 'Unknown':
										break _v8$1;
									case 'Number':
										var _v15 = _v8.a;
										var _v16 = _v8.b;
										return $dillonkearns$elm_ts_json$Internal$TsJsonType$TsNever;
									default:
										break _v8$8;
								}
							case 'Number':
								switch (_v8.b.$) {
									case 'Unknown':
										break _v8$1;
									case 'String':
										var _v17 = _v8.a;
										var _v18 = _v8.b;
										return $dillonkearns$elm_ts_json$Internal$TsJsonType$TsNever;
									default:
										break _v8$8;
								}
							default:
								if (_v8.b.$ === 'Unknown') {
									break _v8$1;
								} else {
									break _v8$8;
								}
						}
					}
					return _Utils_eq(type1, type2) ? type1 : $dillonkearns$elm_ts_json$Internal$TsJsonType$Intersection(
						_List_fromArray(
							[type1, type2]));
				}
				var known = _v8.a;
				var _v10 = _v8.b;
				return known;
			}
		}
	});
var $dillonkearns$elm_ts_json$Internal$TypeReducer$mergeFields = F2(
	function (fields1, fields2) {
		return $elm$core$Dict$values(
			A3(
				$elm_community$dict_extra$Dict$Extra$fromListDedupeBy,
				F2(
					function (_v5, _v6) {
						var optionality1 = _v5.a;
						var fieldName1 = _v5.b;
						var fieldType1 = _v5.c;
						var optionality2 = _v6.a;
						var fieldName2 = _v6.b;
						var fieldType2 = _v6.c;
						return (_Utils_eq(optionality1, $dillonkearns$elm_ts_json$Internal$TsJsonType$Required) || _Utils_eq(optionality2, $dillonkearns$elm_ts_json$Internal$TsJsonType$Required)) ? _Utils_Tuple3(
							$dillonkearns$elm_ts_json$Internal$TsJsonType$Required,
							fieldName1,
							A2($dillonkearns$elm_ts_json$Internal$TypeReducer$intersect, fieldType1, fieldType2)) : _Utils_Tuple3($dillonkearns$elm_ts_json$Internal$TsJsonType$Optional, fieldName1, fieldType1);
					}),
				function (_v7) {
					var fieldName = _v7.b;
					return fieldName;
				},
				_Utils_ap(fields1, fields2)));
	});
var $dillonkearns$elm_ts_json$Internal$TypeReducer$simplifyIntersection = function (types) {
	var thing = function () {
		var _v0 = A2($dillonkearns$elm_ts_json$Internal$TypeReducer$deduplicateBy, $dillonkearns$elm_ts_json$Internal$TypeToString$toString, types);
		if (_v0.b) {
			if (!_v0.b.b) {
				var single = _v0.a;
				return single;
			} else {
				var first = _v0.a;
				var rest = _v0.b;
				if (first.$ === 'TypeObject') {
					var fields = first.a;
					var _v2 = A3(
						$elm$core$List$foldr,
						F2(
							function (thisType, _v3) {
								var objectsSoFar = _v3.a;
								var otherSoFar = _v3.b;
								if (thisType.$ === 'TypeObject') {
									var theseFields = thisType.a;
									return _Utils_Tuple2(
										A2($dillonkearns$elm_ts_json$Internal$TypeReducer$mergeFields, theseFields, objectsSoFar),
										otherSoFar);
								} else {
									return _Utils_Tuple2(
										objectsSoFar,
										A2($elm$core$List$cons, thisType, otherSoFar));
								}
							}),
						_Utils_Tuple2(fields, _List_Nil),
						rest);
					var otherObjects = _v2.a;
					var nonObjectTypes = _v2.b;
					return $dillonkearns$elm_ts_json$Internal$TsJsonType$Intersection(
						A2(
							$elm$core$List$cons,
							$dillonkearns$elm_ts_json$Internal$TsJsonType$TypeObject(otherObjects),
							nonObjectTypes));
				} else {
					return $dillonkearns$elm_ts_json$Internal$TsJsonType$Intersection(types);
				}
			}
		} else {
			return $dillonkearns$elm_ts_json$Internal$TsJsonType$TsNever;
		}
	}();
	return thing;
};
var $dillonkearns$elm_ts_json$TsJson$Decode$map2 = F3(
	function (mapFn, _v0, _v1) {
		var innerDecoder1 = _v0.a;
		var innerType1 = _v0.b;
		var innerDecoder2 = _v1.a;
		var innerType2 = _v1.b;
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder,
			A3($elm$json$Json$Decode$map2, mapFn, innerDecoder1, innerDecoder2),
			A2($dillonkearns$elm_ts_json$Internal$TypeReducer$intersect, innerType1, innerType2));
	});
var $dillonkearns$elm_ts_json$TsJson$Decode$andMap = $dillonkearns$elm_ts_json$TsJson$Decode$map2($elm$core$Basics$apR);
var $dillonkearns$elm_ts_json$TsJson$Decode$andThen = F2(
	function (_v0, _v1) {
		var _function = _v0.a;
		var tsTypes = _v0.b;
		var innerDecoder = _v1.a;
		var innerType = _v1.b;
		var andThenDecoder_ = function (value_) {
			var _v2 = _function(value_);
			var innerDecoder_ = _v2.a;
			var innerType_ = _v2.b;
			return innerDecoder_;
		};
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder,
			A2($elm$json$Json$Decode$andThen, andThenDecoder_, innerDecoder),
			A2(
				$dillonkearns$elm_ts_json$Internal$TypeReducer$intersect,
				innerType,
				$dillonkearns$elm_ts_json$Internal$TypeReducer$union(tsTypes)));
	});
var $dillonkearns$elm_ts_json$TsJson$Decode$StaticAndThen = F2(
	function (a, b) {
		return {$: 'StaticAndThen', a: a, b: b};
	});
var $dillonkearns$elm_ts_json$TsJson$Decode$andThenInit = function (constructor) {
	return A2($dillonkearns$elm_ts_json$TsJson$Decode$StaticAndThen, constructor, _List_Nil);
};
var $dillonkearns$elm_ts_json$TsJson$Decode$decoder = function (_v0) {
	var decoder_ = _v0.a;
	return decoder_;
};
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$string = _Json_decodeString;
var $dillonkearns$elm_ts_json$TsJson$Decode$tsType = function (_v0) {
	var tsType_ = _v0.b;
	return tsType_;
};
var $dillonkearns$elm_ts_json$TsJson$Decode$discriminatedUnion = F2(
	function (discriminantField, decoders) {
		var table = $elm$core$Dict$fromList(decoders);
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder,
			A2(
				$elm$json$Json$Decode$andThen,
				function (discriminantValue) {
					var _v0 = A2($elm$core$Dict$get, discriminantValue, table);
					if (_v0.$ === 'Just') {
						var variantDecoder = _v0.a;
						return $dillonkearns$elm_ts_json$TsJson$Decode$decoder(variantDecoder);
					} else {
						return $elm$json$Json$Decode$fail('Unexpected discriminant value \'' + (discriminantValue + ('\' for field \'' + (discriminantField + '\''))));
					}
				},
				A2($elm$json$Json$Decode$field, discriminantField, $elm$json$Json$Decode$string)),
			$dillonkearns$elm_ts_json$Internal$TypeReducer$union(
				A2(
					$elm$core$List$map,
					function (_v1) {
						var discriminantValue = _v1.a;
						var variantDecoder = _v1.b;
						return A2(
							$dillonkearns$elm_ts_json$Internal$TypeReducer$intersect,
							$dillonkearns$elm_ts_json$Internal$TsJsonType$TypeObject(
								_List_fromArray(
									[
										_Utils_Tuple3(
										$dillonkearns$elm_ts_json$Internal$TsJsonType$Required,
										discriminantField,
										$dillonkearns$elm_ts_json$Internal$TsJsonType$Literal(
											$elm$json$Json$Encode$string(discriminantValue)))
									])),
							$dillonkearns$elm_ts_json$TsJson$Decode$tsType(variantDecoder));
					},
					decoders)));
	});
var $dillonkearns$elm_ts_json$TsJson$Decode$fail = function (message) {
	return A2(
		$dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder,
		$elm$json$Json$Decode$fail(message),
		$dillonkearns$elm_ts_json$Internal$TsJsonType$Unknown);
};
var $dillonkearns$elm_ts_json$TsJson$Decode$field = F2(
	function (fieldName, _v0) {
		var innerDecoder = _v0.a;
		var innerType = _v0.b;
		return A2(
			$dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder,
			A2($elm$json$Json$Decode$field, fieldName, innerDecoder),
			$dillonkearns$elm_ts_json$Internal$TsJsonType$TypeObject(
				_List_fromArray(
					[
						_Utils_Tuple3($dillonkearns$elm_ts_json$Internal$TsJsonType$Required, fieldName, innerType)
					])));
	});
var $author$project$Gen$Sound$fromString = function (string) {
	switch (string) {
		case 'explosion.wav':
			return $elm$core$Maybe$Just($author$project$Gen$Sound$Explosion);
		case 'move.wav':
			return $elm$core$Maybe$Just($author$project$Gen$Sound$Move);
		case 'push.wav':
			return $elm$core$Maybe$Just($author$project$Gen$Sound$Push);
		case 'retry.wav':
			return $elm$core$Maybe$Just($author$project$Gen$Sound$Retry);
		case 'undo.wav':
			return $elm$core$Maybe$Just($author$project$Gen$Sound$Undo);
		case 'win.wav':
			return $elm$core$Maybe$Just($author$project$Gen$Sound$Win);
		default:
			return $elm$core$Maybe$Nothing;
	}
};
var $dillonkearns$elm_ts_json$TsJson$Decode$string = A2($dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder, $elm$json$Json$Decode$string, $dillonkearns$elm_ts_json$Internal$TsJsonType$String);
var $dillonkearns$elm_ts_json$TsJson$Decode$succeed = function (value_) {
	return A2(
		$dillonkearns$elm_ts_json$TsJson$Internal$Decode$Decoder,
		$elm$json$Json$Decode$succeed(value_),
		$dillonkearns$elm_ts_json$Internal$TsJsonType$Unknown);
};
var $author$project$PortDefinition$toElm = A2(
	$dillonkearns$elm_ts_json$TsJson$Decode$discriminatedUnion,
	'type',
	_List_fromArray(
		[
			_Utils_Tuple2(
			'soundEnded',
			A2(
				$dillonkearns$elm_ts_json$TsJson$Decode$andMap,
				A2(
					$dillonkearns$elm_ts_json$TsJson$Decode$field,
					'sound',
					A2(
						$dillonkearns$elm_ts_json$TsJson$Decode$andThen,
						$dillonkearns$elm_ts_json$TsJson$Decode$andThenInit(
							function (string) {
								return A2(
									$elm$core$Maybe$withDefault,
									$dillonkearns$elm_ts_json$TsJson$Decode$fail('Unkown sound ended: ' + string),
									A2(
										$elm$core$Maybe$map,
										$dillonkearns$elm_ts_json$TsJson$Decode$succeed,
										$author$project$Gen$Sound$fromString(string)));
							}),
						$dillonkearns$elm_ts_json$TsJson$Decode$string)),
				$dillonkearns$elm_ts_json$TsJson$Decode$succeed($author$project$PortDefinition$SoundEnded)))
		]));
var $author$project$PortDefinition$interop = {flags: $author$project$PortDefinition$flags, fromElm: $author$project$PortDefinition$fromElm, toElm: $author$project$PortDefinition$toElm};
var $author$project$Port$interopFromElm = _Platform_outgoingPort('interopFromElm', $elm$core$Basics$identity);
var $author$project$Port$fromElm = function (value) {
	return $author$project$Port$interopFromElm(
		A3($elm$core$Basics$apR, $author$project$PortDefinition$interop.fromElm, $dillonkearns$elm_ts_json$TsJson$Encode$encoder, value));
};
var $elm$random$Random$Generate = function (a) {
	return {$: 'Generate', a: a};
};
var $elm$random$Random$Seed = F2(
	function (a, b) {
		return {$: 'Seed', a: a, b: b};
	});
var $elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var $elm$random$Random$next = function (_v0) {
	var state0 = _v0.a;
	var incr = _v0.b;
	return A2($elm$random$Random$Seed, ((state0 * 1664525) + incr) >>> 0, incr);
};
var $elm$random$Random$initialSeed = function (x) {
	var _v0 = $elm$random$Random$next(
		A2($elm$random$Random$Seed, 0, 1013904223));
	var state1 = _v0.a;
	var incr = _v0.b;
	var state2 = (state1 + x) >>> 0;
	return $elm$random$Random$next(
		A2($elm$random$Random$Seed, state2, incr));
};
var $elm$time$Time$Name = function (a) {
	return {$: 'Name', a: a};
};
var $elm$time$Time$Offset = function (a) {
	return {$: 'Offset', a: a};
};
var $elm$time$Time$Zone = F2(
	function (a, b) {
		return {$: 'Zone', a: a, b: b};
	});
var $elm$time$Time$customZone = $elm$time$Time$Zone;
var $elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var $elm$time$Time$millisToPosix = $elm$time$Time$Posix;
var $elm$time$Time$now = _Time_now($elm$time$Time$millisToPosix);
var $elm$time$Time$posixToMillis = function (_v0) {
	var millis = _v0.a;
	return millis;
};
var $elm$random$Random$init = A2(
	$elm$core$Task$andThen,
	function (time) {
		return $elm$core$Task$succeed(
			$elm$random$Random$initialSeed(
				$elm$time$Time$posixToMillis(time)));
	},
	$elm$time$Time$now);
var $elm$random$Random$step = F2(
	function (_v0, seed) {
		var generator = _v0.a;
		return generator(seed);
	});
var $elm$random$Random$onEffects = F3(
	function (router, commands, seed) {
		if (!commands.b) {
			return $elm$core$Task$succeed(seed);
		} else {
			var generator = commands.a.a;
			var rest = commands.b;
			var _v1 = A2($elm$random$Random$step, generator, seed);
			var value = _v1.a;
			var newSeed = _v1.b;
			return A2(
				$elm$core$Task$andThen,
				function (_v2) {
					return A3($elm$random$Random$onEffects, router, rest, newSeed);
				},
				A2($elm$core$Platform$sendToApp, router, value));
		}
	});
var $elm$random$Random$onSelfMsg = F3(
	function (_v0, _v1, seed) {
		return $elm$core$Task$succeed(seed);
	});
var $elm$random$Random$Generator = function (a) {
	return {$: 'Generator', a: a};
};
var $elm$random$Random$map = F2(
	function (func, _v0) {
		var genA = _v0.a;
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v1 = genA(seed0);
				var a = _v1.a;
				var seed1 = _v1.b;
				return _Utils_Tuple2(
					func(a),
					seed1);
			});
	});
var $elm$random$Random$cmdMap = F2(
	function (func, _v0) {
		var generator = _v0.a;
		return $elm$random$Random$Generate(
			A2($elm$random$Random$map, func, generator));
	});
_Platform_effectManagers['Random'] = _Platform_createManager($elm$random$Random$init, $elm$random$Random$onEffects, $elm$random$Random$onSelfMsg, $elm$random$Random$cmdMap);
var $elm$random$Random$command = _Platform_leaf('Random');
var $elm$random$Random$generate = F2(
	function (tagger, generator) {
		return $elm$random$Random$command(
			$elm$random$Random$Generate(
				A2($elm$random$Random$map, tagger, generator)));
	});
var $author$project$Entity$Ground = {$: 'Ground'};
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$List$concatMap = F2(
	function (f, list) {
		return $elm$core$List$concat(
			A2($elm$core$List$map, f, list));
	});
var $elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var $author$project$Position$asGrid = function (_v0) {
	var rows = _v0.rows;
	var columns = _v0.columns;
	return A2(
		$elm$core$List$concatMap,
		function (x) {
			return A2(
				$elm$core$List$map,
				$elm$core$Tuple$pair(x),
				A2($elm$core$List$range, 0, columns - 1));
		},
		A2($elm$core$List$range, 0, rows - 1));
};
var $author$project$Game$empty = {
	cells: $elm$core$Dict$empty,
	doors: $elm$core$Dict$empty,
	floor: $elm$core$Dict$fromList(
		A2(
			$elm$core$List$map,
			function (pos) {
				return A2($elm$core$Tuple$pair, pos, $author$project$Entity$Ground);
			},
			$author$project$Position$asGrid(
				{columns: $author$project$Config$roomSize, rows: $author$project$Config$roomSize}))),
	item: $elm$core$Maybe$Nothing,
	items: $elm$core$Dict$empty,
	nextId: 0,
	particles: $elm$core$Dict$empty,
	playerDirection: $author$project$Direction$Down,
	playerPos: $elm$core$Maybe$Nothing,
	won: false
};
var $author$project$Game$placeItem = F3(
	function (pos, item, game) {
		return _Utils_update(
			game,
			{
				items: A3($elm$core$Dict$insert, pos, item, game.items)
			});
	});
var $author$project$Game$removeFloor = F2(
	function (pos, game) {
		return _Utils_update(
			game,
			{
				floor: A2($elm$core$Dict$remove, pos, game.floor)
			});
	});
var $author$project$Game$Build$fromBlocks = F2(
	function (args, blocks) {
		var game = A3(
			$elm$core$List$foldl,
			function (_v0) {
				var pos = _v0.a;
				var block = _v0.b;
				switch (block.$) {
					case 'EntityBlock':
						var entity = block.a;
						return A2($author$project$Game$insert, pos, entity);
					case 'ItemBlock':
						var item = block.a;
						return A2($author$project$Game$placeItem, pos, item);
					default:
						return $author$project$Game$removeFloor(pos);
				}
			},
			$author$project$Game$empty,
			blocks);
		return _Utils_update(
			game,
			{
				doors: $elm$core$Dict$fromList(args.doors)
			});
	});
var $author$project$Entity$ActiveSmallBomb = {$: 'ActiveSmallBomb'};
var $author$project$Entity$Bomb = {$: 'Bomb'};
var $author$project$Entity$Crate = {$: 'Crate'};
var $author$project$Entity$Diamant = {$: 'Diamant'};
var $author$project$Entity$Enemy = function (a) {
	return {$: 'Enemy', a: a};
};
var $author$project$Game$Build$EntityBlock = function (a) {
	return {$: 'EntityBlock', a: a};
};
var $author$project$Entity$Goblin = {$: 'Goblin'};
var $author$project$Game$Build$HoleBlock = {$: 'HoleBlock'};
var $author$project$Entity$InactiveBomb = function (a) {
	return {$: 'InactiveBomb', a: a};
};
var $author$project$Entity$Wall = {$: 'Wall'};
var $author$project$Game$Build$parseEmoji = function (string) {
	switch (string.valueOf()) {
		case '📦':
			return $elm$core$Maybe$Just(
				$author$project$Game$Build$EntityBlock($author$project$Entity$Crate));
		case '💣':
			return $elm$core$Maybe$Just(
				$author$project$Game$Build$EntityBlock(
					$author$project$Entity$InactiveBomb($author$project$Entity$Bomb)));
		case '🧨':
			return $elm$core$Maybe$Just(
				$author$project$Game$Build$EntityBlock($author$project$Entity$ActiveSmallBomb));
		case '❌':
			return $elm$core$Maybe$Just($author$project$Game$Build$HoleBlock);
		case '🐀':
			return $elm$core$Maybe$Just(
				$author$project$Game$Build$EntityBlock(
					$author$project$Entity$Enemy($author$project$Entity$Goblin)));
		case '🧱':
			return $elm$core$Maybe$Just(
				$author$project$Game$Build$EntityBlock($author$project$Entity$Wall));
		case '💎':
			return $elm$core$Maybe$Just(
				$author$project$Game$Build$EntityBlock($author$project$Entity$Diamant));
		case '⬜':
			return $elm$core$Maybe$Nothing;
		default:
			return $elm$core$Maybe$Nothing;
	}
};
var $elm$core$String$foldr = _String_foldr;
var $elm$core$String$toList = function (string) {
	return A3($elm$core$String$foldr, $elm$core$List$cons, _List_Nil, string);
};
var $author$project$Game$Build$fromEmojis = function (rows) {
	return $elm$core$Dict$fromList(
		$elm$core$List$concat(
			A2(
				$elm$core$List$indexedMap,
				F2(
					function (y, strings) {
						return A2(
							$elm$core$List$filterMap,
							$elm$core$Basics$identity,
							A2(
								$elm$core$List$indexedMap,
								F2(
									function (x, string) {
										return A2(
											$elm$core$Maybe$map,
											function (block) {
												return _Utils_Tuple2(
													_Utils_Tuple2(x, y),
													block);
											},
											$author$project$Game$Build$parseEmoji(string));
									}),
								$elm$core$String$toList(strings)));
					}),
				rows)));
};
var $author$project$Game$Build$constant = F2(
	function (emojis, doors) {
		return A2(
			$author$project$Game$Build$fromBlocks,
			{doors: doors},
			$elm$core$Dict$toList(
				$author$project$Game$Build$fromEmojis(emojis)));
	});
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $author$project$World$Map$sokoBombLevels = function (_v0) {
	var x = _v0.a;
	var y = _v0.b;
	return _List_fromArray(
		[
			_Utils_Tuple2(
			_Utils_Tuple2(x, y),
			_List_fromArray(
				['🧱📦⬜📦🧱', '🧱⬜📦⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 1),
			_List_fromArray(
				['🧱📦⬜📦🧱', '🧱⬜⬜⬜🧱', '🧱📦📦📦🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 2),
			_List_fromArray(
				['🧱⬜📦⬜🧱', '🧱⬜⬜⬜🧱', '🧱📦⬜📦🧱', '🧱⬜📦⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 3),
			_List_fromArray(
				['🧱📦📦📦🧱', '🧱⬜⬜⬜🧱', '🧱⬜🧨⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 4),
			_List_fromArray(
				['🧱⬜📦⬜🧱', '🧱📦📦📦🧱', '🧱⬜🧨⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 5),
			_List_fromArray(
				['🧱📦📦📦🧱', '🧱📦🧨📦🧱', '🧱⬜🧨⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 6),
			_List_fromArray(
				['🧱🧱🧱🧱🧱', '🧱⬜⬜⬜🧱', '🧱⬜🧨⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 7),
			_List_fromArray(
				['🧱🧱🧱🧱🧱', '🧱📦📦📦🧱', '🧱🧨🧨🧨🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 8),
			_List_fromArray(
				['🧱🧱🧱🧱🧱', '🧱🧨📦🧨🧱', '🧱📦🧨📦🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 9),
			_List_fromArray(
				['🧱⬜📦⬜🧱', '🧨⬜⬜⬜🧨', '🧱📦📦📦🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 10),
			_List_fromArray(
				['🧱⬜📦⬜🧱', '🧱📦⬜📦🧱', '🧨⬜📦⬜🧨', '🧨📦📦📦🧨', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 11),
			_List_fromArray(
				['🧱⬜🧱⬜🧱', '🧨🧱📦🧱🧨', '🧨📦🧨📦🧨', '🧨⬜🧨⬜🧨', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 12),
			_List_fromArray(
				['🧱🧱🧱🧱🧱', '🧱⬜🧨⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱'])),
			_Utils_Tuple2(
			_Utils_Tuple2(x, y - 13),
			_List_fromArray(
				['🧱🧱🧱🧱🧱', '🧱🧱🧱🧱🧱', '🧱⬜💎⬜🧱', '🧱⬜⬜⬜🧱', '🧱⬜😊⬜🧱']))
		]);
};
var $author$project$World$Map$dict = $elm$core$Dict$fromList(
	_Utils_ap(
		$author$project$World$Map$sokoBombLevels(
			_Utils_Tuple2(0, 0)),
		_List_fromArray(
			[
				_Utils_Tuple2(
				_Utils_Tuple2(-1, -12),
				_List_fromArray(
					['❌❌⬜⬜⬜', '❌❌⬜❌⬜', '⬜❌⬜❌⬜', '⬜❌⬜❌❌', '⬜⬜⬜❌❌'])),
				_Utils_Tuple2(
				_Utils_Tuple2(-2, -12),
				_List_fromArray(
					['❌❌❌❌❌', '❌⬜⬜⬜⬜', '❌⬜📦⬜⬜', '❌❌❌❌❌', '❌⬜⬜⬜❌'])),
				_Utils_Tuple2(
				_Utils_Tuple2(-2, -11),
				_List_fromArray(
					['⬜⬜⬜⬜⬜', '⬜⬜📦⬜⬜', '⬜⬜⬜⬜⬜', '❌❌❌❌❌', '⬜⬜📦⬜⬜'])),
				_Utils_Tuple2(
				_Utils_Tuple2(-2, -10),
				_List_fromArray(
					['⬜⬜⬜⬜⬜', '⬜📦📦📦⬜', '❌❌📦❌❌', '❌❌❌❌❌', '❌❌📦❌❌'])),
				_Utils_Tuple2(
				_Utils_Tuple2(-2, -9),
				_List_fromArray(
					['⬜⬜⬜⬜⬜', '📦📦📦📦📦', '⬜📦⬜📦⬜', '❌❌🧱❌❌', '❌❌❌❌❌'])),
				_Utils_Tuple2(
				_Utils_Tuple2(-2, -8),
				_List_fromArray(
					['⬜⬜⬜⬜⬜', '⬜⬜📦⬜⬜', '⬜📦🧨📦⬜', '❌❌❌❌❌', '🧱🧱🧱🧱🧱'])),
				_Utils_Tuple2(
				_Utils_Tuple2(-1, -8),
				_List_fromArray(
					['🧱🧱🧱🧱🧱', '⬜⬜❌⬜⬜', '⬜📦❌⬜⬜', '⬜⬜❌⬜⬜', '🧱🧱🧱🧱🧱']))
			])));
var $elm$core$Dict$member = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$get, key, dict);
		if (_v0.$ === 'Just') {
			return true;
		} else {
			return false;
		}
	});
var $author$project$World$Map$getDoors = function (_v0) {
	var x = _v0.a;
	var y = _v0.b;
	return A2(
		$elm$core$List$filterMap,
		function (_v1) {
			var room = _v1.a;
			var pos = _v1.b;
			return A2($elm$core$Dict$member, room, $author$project$World$Map$dict) ? $elm$core$Maybe$Just(
				_Utils_Tuple2(
					pos,
					{room: room})) : $elm$core$Maybe$Nothing;
		},
		_List_fromArray(
			[
				_Utils_Tuple2(
				_Utils_Tuple2(x - 1, y),
				_Utils_Tuple2(-1, 2)),
				_Utils_Tuple2(
				_Utils_Tuple2(x, y - 1),
				_Utils_Tuple2(2, -1)),
				_Utils_Tuple2(
				_Utils_Tuple2(x + 1, y),
				_Utils_Tuple2($author$project$Config$roomSize, 2)),
				_Utils_Tuple2(
				_Utils_Tuple2(x, y + 1),
				_Utils_Tuple2(2, $author$project$Config$roomSize))
			]));
};
var $author$project$World$Map$get = function (pos) {
	return A2(
		$author$project$Game$Build$constant,
		A2(
			$elm$core$Maybe$withDefault,
			_List_Nil,
			A2($elm$core$Dict$get, pos, $author$project$World$Map$dict)),
		$author$project$World$Map$getDoors(pos));
};
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Bitwise$xor = _Bitwise_xor;
var $elm$random$Random$peel = function (_v0) {
	var state = _v0.a;
	var word = (state ^ (state >>> ((state >>> 28) + 4))) * 277803737;
	return ((word >>> 22) ^ word) >>> 0;
};
var $elm$random$Random$int = F2(
	function (a, b) {
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v0 = (_Utils_cmp(a, b) < 0) ? _Utils_Tuple2(a, b) : _Utils_Tuple2(b, a);
				var lo = _v0.a;
				var hi = _v0.b;
				var range = (hi - lo) + 1;
				if (!((range - 1) & range)) {
					return _Utils_Tuple2(
						(((range - 1) & $elm$random$Random$peel(seed0)) >>> 0) + lo,
						$elm$random$Random$next(seed0));
				} else {
					var threshhold = (((-range) >>> 0) % range) >>> 0;
					var accountForBias = function (seed) {
						accountForBias:
						while (true) {
							var x = $elm$random$Random$peel(seed);
							var seedN = $elm$random$Random$next(seed);
							if (_Utils_cmp(x, threshhold) < 0) {
								var $temp$seed = seedN;
								seed = $temp$seed;
								continue accountForBias;
							} else {
								return _Utils_Tuple2((x % range) + lo, seedN);
							}
						}
					};
					return accountForBias(seed0);
				}
			});
	});
var $elm$random$Random$map3 = F4(
	function (func, _v0, _v1, _v2) {
		var genA = _v0.a;
		var genB = _v1.a;
		var genC = _v2.a;
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v3 = genA(seed0);
				var a = _v3.a;
				var seed1 = _v3.b;
				var _v4 = genB(seed1);
				var b = _v4.a;
				var seed2 = _v4.b;
				var _v5 = genC(seed2);
				var c = _v5.a;
				var seed3 = _v5.b;
				return _Utils_Tuple2(
					A3(func, a, b, c),
					seed3);
			});
	});
var $elm$core$Bitwise$or = _Bitwise_or;
var $elm$random$Random$independentSeed = $elm$random$Random$Generator(
	function (seed0) {
		var makeIndependentSeed = F3(
			function (state, b, c) {
				return $elm$random$Random$next(
					A2($elm$random$Random$Seed, state, (1 | (b ^ c)) >>> 0));
			});
		var gen = A2($elm$random$Random$int, 0, 4294967295);
		return A2(
			$elm$random$Random$step,
			A4($elm$random$Random$map3, makeIndependentSeed, gen, gen, gen),
			seed0);
	});
var $author$project$World$Room = function (a) {
	return {$: 'Room', a: a};
};
var $author$project$World$Trial = function (a) {
	return {$: 'Trial', a: a};
};
var $author$project$World$new = function (seed) {
	return {
		difficulty: 0,
		nodes: $elm$core$Dict$fromList(
			_List_fromArray(
				[
					_Utils_Tuple2(
					_Utils_Tuple2(0, 0),
					$author$project$World$Room(
						{
							seed: seed,
							solved: false,
							sort: $author$project$World$Trial(0)
						}))
				])),
		player: _Utils_Tuple2(0, 0),
		stages: $elm$core$Dict$empty,
		trials: 1
	};
};
var $author$project$Main$init = function (_v0) {
	var seed = $elm$random$Random$initialSeed(42);
	var room = _Utils_Tuple2(0, 0);
	var initialPlayerPos = _Utils_Tuple2(2, 4);
	var game = $author$project$World$Map$get(room);
	return _Utils_Tuple2(
		{
			frame: 0,
			game: A2($author$project$Game$addPlayer, initialPlayerPos, game),
			history: _List_Nil,
			initialItem: $elm$core$Maybe$Nothing,
			initialPlayerPos: initialPlayerPos,
			levelSeed: seed,
			overlay: $elm$core$Maybe$Just($author$project$Main$Menu),
			room: room,
			seed: seed,
			world: $author$project$World$new(seed)
		},
		$elm$core$Platform$Cmd$batch(
			_List_fromArray(
				[
					$author$project$Port$fromElm(
					$author$project$PortDefinition$RegisterSounds($author$project$Gen$Sound$asList)),
					A2($elm$random$Random$generate, $author$project$Main$GotSeed, $elm$random$Random$independentSeed)
				])));
};
var $author$project$Main$NextFrameRequested = {$: 'NextFrameRequested'};
var $author$project$Main$Received = function (a) {
	return {$: 'Received', a: a};
};
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$time$Time$Every = F2(
	function (a, b) {
		return {$: 'Every', a: a, b: b};
	});
var $elm$time$Time$State = F2(
	function (taggers, processes) {
		return {processes: processes, taggers: taggers};
	});
var $elm$time$Time$init = $elm$core$Task$succeed(
	A2($elm$time$Time$State, $elm$core$Dict$empty, $elm$core$Dict$empty));
var $elm$time$Time$addMySub = F2(
	function (_v0, state) {
		var interval = _v0.a;
		var tagger = _v0.b;
		var _v1 = A2($elm$core$Dict$get, interval, state);
		if (_v1.$ === 'Nothing') {
			return A3(
				$elm$core$Dict$insert,
				interval,
				_List_fromArray(
					[tagger]),
				state);
		} else {
			var taggers = _v1.a;
			return A3(
				$elm$core$Dict$insert,
				interval,
				A2($elm$core$List$cons, tagger, taggers),
				state);
		}
	});
var $elm$core$Process$kill = _Scheduler_kill;
var $elm$core$Dict$foldl = F3(
	function (func, acc, dict) {
		foldl:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldl, func, acc, left)),
					$temp$dict = right;
				func = $temp$func;
				acc = $temp$acc;
				dict = $temp$dict;
				continue foldl;
			}
		}
	});
var $elm$core$Dict$merge = F6(
	function (leftStep, bothStep, rightStep, leftDict, rightDict, initialResult) {
		var stepState = F3(
			function (rKey, rValue, _v0) {
				stepState:
				while (true) {
					var list = _v0.a;
					var result = _v0.b;
					if (!list.b) {
						return _Utils_Tuple2(
							list,
							A3(rightStep, rKey, rValue, result));
					} else {
						var _v2 = list.a;
						var lKey = _v2.a;
						var lValue = _v2.b;
						var rest = list.b;
						if (_Utils_cmp(lKey, rKey) < 0) {
							var $temp$rKey = rKey,
								$temp$rValue = rValue,
								$temp$_v0 = _Utils_Tuple2(
								rest,
								A3(leftStep, lKey, lValue, result));
							rKey = $temp$rKey;
							rValue = $temp$rValue;
							_v0 = $temp$_v0;
							continue stepState;
						} else {
							if (_Utils_cmp(lKey, rKey) > 0) {
								return _Utils_Tuple2(
									list,
									A3(rightStep, rKey, rValue, result));
							} else {
								return _Utils_Tuple2(
									rest,
									A4(bothStep, lKey, lValue, rValue, result));
							}
						}
					}
				}
			});
		var _v3 = A3(
			$elm$core$Dict$foldl,
			stepState,
			_Utils_Tuple2(
				$elm$core$Dict$toList(leftDict),
				initialResult),
			rightDict);
		var leftovers = _v3.a;
		var intermediateResult = _v3.b;
		return A3(
			$elm$core$List$foldl,
			F2(
				function (_v4, result) {
					var k = _v4.a;
					var v = _v4.b;
					return A3(leftStep, k, v, result);
				}),
			intermediateResult,
			leftovers);
	});
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$time$Time$setInterval = _Time_setInterval;
var $elm$core$Process$spawn = _Scheduler_spawn;
var $elm$time$Time$spawnHelp = F3(
	function (router, intervals, processes) {
		if (!intervals.b) {
			return $elm$core$Task$succeed(processes);
		} else {
			var interval = intervals.a;
			var rest = intervals.b;
			var spawnTimer = $elm$core$Process$spawn(
				A2(
					$elm$time$Time$setInterval,
					interval,
					A2($elm$core$Platform$sendToSelf, router, interval)));
			var spawnRest = function (id) {
				return A3(
					$elm$time$Time$spawnHelp,
					router,
					rest,
					A3($elm$core$Dict$insert, interval, id, processes));
			};
			return A2($elm$core$Task$andThen, spawnRest, spawnTimer);
		}
	});
var $elm$time$Time$onEffects = F3(
	function (router, subs, _v0) {
		var processes = _v0.processes;
		var rightStep = F3(
			function (_v6, id, _v7) {
				var spawns = _v7.a;
				var existing = _v7.b;
				var kills = _v7.c;
				return _Utils_Tuple3(
					spawns,
					existing,
					A2(
						$elm$core$Task$andThen,
						function (_v5) {
							return kills;
						},
						$elm$core$Process$kill(id)));
			});
		var newTaggers = A3($elm$core$List$foldl, $elm$time$Time$addMySub, $elm$core$Dict$empty, subs);
		var leftStep = F3(
			function (interval, taggers, _v4) {
				var spawns = _v4.a;
				var existing = _v4.b;
				var kills = _v4.c;
				return _Utils_Tuple3(
					A2($elm$core$List$cons, interval, spawns),
					existing,
					kills);
			});
		var bothStep = F4(
			function (interval, taggers, id, _v3) {
				var spawns = _v3.a;
				var existing = _v3.b;
				var kills = _v3.c;
				return _Utils_Tuple3(
					spawns,
					A3($elm$core$Dict$insert, interval, id, existing),
					kills);
			});
		var _v1 = A6(
			$elm$core$Dict$merge,
			leftStep,
			bothStep,
			rightStep,
			newTaggers,
			processes,
			_Utils_Tuple3(
				_List_Nil,
				$elm$core$Dict$empty,
				$elm$core$Task$succeed(_Utils_Tuple0)));
		var spawnList = _v1.a;
		var existingDict = _v1.b;
		var killTask = _v1.c;
		return A2(
			$elm$core$Task$andThen,
			function (newProcesses) {
				return $elm$core$Task$succeed(
					A2($elm$time$Time$State, newTaggers, newProcesses));
			},
			A2(
				$elm$core$Task$andThen,
				function (_v2) {
					return A3($elm$time$Time$spawnHelp, router, spawnList, existingDict);
				},
				killTask));
	});
var $elm$time$Time$onSelfMsg = F3(
	function (router, interval, state) {
		var _v0 = A2($elm$core$Dict$get, interval, state.taggers);
		if (_v0.$ === 'Nothing') {
			return $elm$core$Task$succeed(state);
		} else {
			var taggers = _v0.a;
			var tellTaggers = function (time) {
				return $elm$core$Task$sequence(
					A2(
						$elm$core$List$map,
						function (tagger) {
							return A2(
								$elm$core$Platform$sendToApp,
								router,
								tagger(time));
						},
						taggers));
			};
			return A2(
				$elm$core$Task$andThen,
				function (_v1) {
					return $elm$core$Task$succeed(state);
				},
				A2($elm$core$Task$andThen, tellTaggers, $elm$time$Time$now));
		}
	});
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm$time$Time$subMap = F2(
	function (f, _v0) {
		var interval = _v0.a;
		var tagger = _v0.b;
		return A2(
			$elm$time$Time$Every,
			interval,
			A2($elm$core$Basics$composeL, f, tagger));
	});
_Platform_effectManagers['Time'] = _Platform_createManager($elm$time$Time$init, $elm$time$Time$onEffects, $elm$time$Time$onSelfMsg, 0, $elm$time$Time$subMap);
var $elm$time$Time$subscription = _Platform_leaf('Time');
var $elm$time$Time$every = F2(
	function (interval, tagger) {
		return $elm$time$Time$subscription(
			A2($elm$time$Time$Every, interval, tagger));
	});
var $author$project$Main$Input = function (a) {
	return {$: 'Input', a: a};
};
var $author$project$Input$InputActivate = {$: 'InputActivate'};
var $author$project$Input$InputDir = function (a) {
	return {$: 'InputDir', a: a};
};
var $author$project$Input$InputReset = {$: 'InputReset'};
var $author$project$Input$InputUndo = {$: 'InputUndo'};
var $author$project$Main$NoOps = {$: 'NoOps'};
var $author$project$Main$toDirection = function (string) {
	switch (string) {
		case 'a':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Left));
		case 'LeftArrow':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Left));
		case 'd':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Right));
		case 'RightArrow':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Right));
		case 'w':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Up));
		case 'UpArrow':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Up));
		case 's':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Down));
		case 'DownArrow':
			return $author$project$Main$Input(
				$author$project$Input$InputDir($author$project$Direction$Down));
		case 'y':
			return $author$project$Main$Input($author$project$Input$InputUndo);
		case 'z':
			return $author$project$Main$Input($author$project$Input$InputUndo);
		case 'c':
			return $author$project$Main$Input($author$project$Input$InputUndo);
		case 'r':
			return $author$project$Main$Input($author$project$Input$InputReset);
		case ' ':
			return $author$project$Main$Input($author$project$Input$InputActivate);
		default:
			return $author$project$Main$NoOps;
	}
};
var $author$project$Main$keyDecoder = A2(
	$elm$json$Json$Decode$map,
	$author$project$Main$toDirection,
	A2($elm$json$Json$Decode$field, 'key', $elm$json$Json$Decode$string));
var $elm$core$Platform$Sub$map = _Platform_map;
var $elm$browser$Browser$Events$Document = {$: 'Document'};
var $elm$browser$Browser$Events$MySub = F3(
	function (a, b, c) {
		return {$: 'MySub', a: a, b: b, c: c};
	});
var $elm$browser$Browser$Events$State = F2(
	function (subs, pids) {
		return {pids: pids, subs: subs};
	});
var $elm$browser$Browser$Events$init = $elm$core$Task$succeed(
	A2($elm$browser$Browser$Events$State, _List_Nil, $elm$core$Dict$empty));
var $elm$browser$Browser$Events$nodeToKey = function (node) {
	if (node.$ === 'Document') {
		return 'd_';
	} else {
		return 'w_';
	}
};
var $elm$browser$Browser$Events$addKey = function (sub) {
	var node = sub.a;
	var name = sub.b;
	return _Utils_Tuple2(
		_Utils_ap(
			$elm$browser$Browser$Events$nodeToKey(node),
			name),
		sub);
};
var $elm$browser$Browser$Events$Event = F2(
	function (key, event) {
		return {event: event, key: key};
	});
var $elm$browser$Browser$Events$spawn = F3(
	function (router, key, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var actualNode = function () {
			if (node.$ === 'Document') {
				return _Browser_doc;
			} else {
				return _Browser_window;
			}
		}();
		return A2(
			$elm$core$Task$map,
			function (value) {
				return _Utils_Tuple2(key, value);
			},
			A3(
				_Browser_on,
				actualNode,
				name,
				function (event) {
					return A2(
						$elm$core$Platform$sendToSelf,
						router,
						A2($elm$browser$Browser$Events$Event, key, event));
				}));
	});
var $elm$core$Dict$union = F2(
	function (t1, t2) {
		return A3($elm$core$Dict$foldl, $elm$core$Dict$insert, t2, t1);
	});
var $elm$browser$Browser$Events$onEffects = F3(
	function (router, subs, state) {
		var stepRight = F3(
			function (key, sub, _v6) {
				var deads = _v6.a;
				var lives = _v6.b;
				var news = _v6.c;
				return _Utils_Tuple3(
					deads,
					lives,
					A2(
						$elm$core$List$cons,
						A3($elm$browser$Browser$Events$spawn, router, key, sub),
						news));
			});
		var stepLeft = F3(
			function (_v4, pid, _v5) {
				var deads = _v5.a;
				var lives = _v5.b;
				var news = _v5.c;
				return _Utils_Tuple3(
					A2($elm$core$List$cons, pid, deads),
					lives,
					news);
			});
		var stepBoth = F4(
			function (key, pid, _v2, _v3) {
				var deads = _v3.a;
				var lives = _v3.b;
				var news = _v3.c;
				return _Utils_Tuple3(
					deads,
					A3($elm$core$Dict$insert, key, pid, lives),
					news);
			});
		var newSubs = A2($elm$core$List$map, $elm$browser$Browser$Events$addKey, subs);
		var _v0 = A6(
			$elm$core$Dict$merge,
			stepLeft,
			stepBoth,
			stepRight,
			state.pids,
			$elm$core$Dict$fromList(newSubs),
			_Utils_Tuple3(_List_Nil, $elm$core$Dict$empty, _List_Nil));
		var deadPids = _v0.a;
		var livePids = _v0.b;
		var makeNewPids = _v0.c;
		return A2(
			$elm$core$Task$andThen,
			function (pids) {
				return $elm$core$Task$succeed(
					A2(
						$elm$browser$Browser$Events$State,
						newSubs,
						A2(
							$elm$core$Dict$union,
							livePids,
							$elm$core$Dict$fromList(pids))));
			},
			A2(
				$elm$core$Task$andThen,
				function (_v1) {
					return $elm$core$Task$sequence(makeNewPids);
				},
				$elm$core$Task$sequence(
					A2($elm$core$List$map, $elm$core$Process$kill, deadPids))));
	});
var $elm$browser$Browser$Events$onSelfMsg = F3(
	function (router, _v0, state) {
		var key = _v0.key;
		var event = _v0.event;
		var toMessage = function (_v2) {
			var subKey = _v2.a;
			var _v3 = _v2.b;
			var node = _v3.a;
			var name = _v3.b;
			var decoder = _v3.c;
			return _Utils_eq(subKey, key) ? A2(_Browser_decodeEvent, decoder, event) : $elm$core$Maybe$Nothing;
		};
		var messages = A2($elm$core$List$filterMap, toMessage, state.subs);
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Platform$sendToApp(router),
					messages)));
	});
var $elm$browser$Browser$Events$subMap = F2(
	function (func, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var decoder = _v0.c;
		return A3(
			$elm$browser$Browser$Events$MySub,
			node,
			name,
			A2($elm$json$Json$Decode$map, func, decoder));
	});
_Platform_effectManagers['Browser.Events'] = _Platform_createManager($elm$browser$Browser$Events$init, $elm$browser$Browser$Events$onEffects, $elm$browser$Browser$Events$onSelfMsg, 0, $elm$browser$Browser$Events$subMap);
var $elm$browser$Browser$Events$subscription = _Platform_leaf('Browser.Events');
var $elm$browser$Browser$Events$on = F3(
	function (node, name, decoder) {
		return $elm$browser$Browser$Events$subscription(
			A3($elm$browser$Browser$Events$MySub, node, name, decoder));
	});
var $elm$browser$Browser$Events$onKeyDown = A2($elm$browser$Browser$Events$on, $elm$browser$Browser$Events$Document, 'keydown');
var $elm$json$Json$Decode$decodeValue = _Json_run;
var $author$project$Port$interopToElm = _Platform_incomingPort('interopToElm', $elm$json$Json$Decode$value);
var $author$project$Port$toElm = $author$project$Port$interopToElm(
	$elm$json$Json$Decode$decodeValue(
		$dillonkearns$elm_ts_json$TsJson$Decode$decoder($author$project$PortDefinition$interop.toElm)));
var $author$project$Main$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$batch(
		_List_fromArray(
			[
				$elm$browser$Browser$Events$onKeyDown($author$project$Main$keyDecoder),
				A2(
				$elm$time$Time$every,
				500,
				function (_v1) {
					return $author$project$Main$NextFrameRequested;
				}),
				A2($elm$core$Platform$Sub$map, $author$project$Main$Received, $author$project$Port$toElm)
			]));
};
var $author$project$Game$Event$Fx = function (a) {
	return {$: 'Fx', a: a};
};
var $author$project$PortDefinition$PlaySound = function (a) {
	return {$: 'PlaySound', a: a};
};
var $author$project$Main$WorldMap = {$: 'WorldMap'};
var $author$project$Game$Event$andThen = F2(
	function (fun, output) {
		var newOutput = fun(output.game);
		return _Utils_update(
			output,
			{
				game: newOutput.game,
				kill: _Utils_ap(newOutput.kill, output.kill)
			});
	});
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Main$GameWon = {$: 'GameWon'};
var $author$project$Main$RoomEntered = function (a) {
	return {$: 'RoomEntered', a: a};
};
var $author$project$Entity$ActivatedBomb = function (a) {
	return {$: 'ActivatedBomb', a: a};
};
var $author$project$Entity$Bone = {$: 'Bone'};
var $author$project$Entity$Smoke = {$: 'Smoke'};
var $author$project$Game$Event$attackPlayer = F2(
	function (position, game) {
		return A2(
			$elm$core$Maybe$andThen,
			function (cell) {
				var _v0 = cell.entity;
				if (_v0.$ === 'Player') {
					return $elm$core$Maybe$Just(
						_Utils_update(
							game,
							{
								cells: A2($elm$core$Dict$remove, position, game.cells),
								particles: A3($elm$core$Dict$insert, position, $author$project$Entity$Bone, game.particles)
							}));
				} else {
					return $elm$core$Maybe$Nothing;
				}
			},
			A2($elm$core$Dict$get, position, game.cells));
	});
var $author$project$Game$get = F2(
	function (pos, game) {
		return A2(
			$elm$core$Maybe$map,
			function ($) {
				return $.entity;
			},
			A2($elm$core$Dict$get, pos, game.cells));
	});
var $author$project$Game$remove = F2(
	function (pos, game) {
		return _Utils_update(
			game,
			{
				cells: A2($elm$core$Dict$remove, pos, game.cells),
				playerPos: _Utils_eq(
					game.playerPos,
					$elm$core$Maybe$Just(pos)) ? $elm$core$Maybe$Nothing : game.playerPos
			});
	});
var $author$project$Game$update = F3(
	function (pos, fun, game) {
		return _Utils_update(
			game,
			{
				cells: A3(
					$elm$core$Dict$update,
					pos,
					$elm$core$Maybe$map(
						function (cell) {
							return _Utils_update(
								cell,
								{
									entity: fun(cell.entity)
								});
						}),
					game.cells)
			});
	});
var $author$project$Game$Event$kill = F2(
	function (pos, game) {
		var _v0 = A2($author$project$Game$get, pos, game);
		if (_v0.$ === 'Nothing') {
			return _Utils_update(
				game,
				{
					particles: A3($elm$core$Dict$insert, pos, $author$project$Entity$Smoke, game.particles)
				});
		} else {
			switch (_v0.a.$) {
				case 'Player':
					var _v1 = _v0.a;
					return A2(
						$elm$core$Maybe$withDefault,
						game,
						A2($author$project$Game$Event$attackPlayer, pos, game));
				case 'Crate':
					var _v2 = _v0.a;
					return A2(
						$author$project$Game$remove,
						pos,
						_Utils_update(
							game,
							{
								particles: A3($elm$core$Dict$insert, pos, $author$project$Entity$Bone, game.particles)
							}));
				case 'ActiveSmallBomb':
					var _v3 = _v0.a;
					return A2(
						$author$project$Game$remove,
						pos,
						_Utils_update(
							game,
							{
								particles: A3($elm$core$Dict$insert, pos, $author$project$Entity$Smoke, game.particles)
							}));
				case 'Enemy':
					if (_v0.a.a.$ === 'ActivatedBomb') {
						return A2(
							$author$project$Game$remove,
							pos,
							_Utils_update(
								game,
								{
									particles: A3($elm$core$Dict$insert, pos, $author$project$Entity$Smoke, game.particles)
								}));
					} else {
						return A2(
							$author$project$Game$remove,
							pos,
							_Utils_update(
								game,
								{
									particles: A3($elm$core$Dict$insert, pos, $author$project$Entity$Bone, game.particles)
								}));
					}
				case 'InactiveBomb':
					var item = _v0.a.a;
					return A3(
						$author$project$Game$update,
						pos,
						function (_v4) {
							return $author$project$Entity$Enemy(
								$author$project$Entity$ActivatedBomb(item));
						},
						game);
				default:
					return game;
			}
		}
	});
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $elm$core$Process$sleep = _Process_sleep;
var $author$project$Main$applyEvent = F2(
	function (event, model) {
		switch (event.$) {
			case 'Kill':
				var pos = event.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							game: A2($author$project$Game$Event$kill, pos, model.game)
						}),
					$elm$core$Platform$Cmd$none);
			case 'Fx':
				var sound = event.a;
				return _Utils_Tuple2(
					model,
					$author$project$Port$fromElm(
						$author$project$PortDefinition$PlaySound(
							{looping: false, sound: sound})));
			case 'MoveToRoom':
				var room = event.a;
				return _Utils_Tuple2(
					model,
					$elm$core$Platform$Cmd$batch(
						_List_fromArray(
							[
								A2(
								$elm$core$Task$perform,
								function (_v1) {
									return $author$project$Main$RoomEntered(room);
								},
								$elm$core$Process$sleep(200)),
								$author$project$Port$fromElm(
								$author$project$PortDefinition$PlaySound(
									{looping: false, sound: $author$project$Gen$Sound$Win}))
							])));
			default:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							overlay: $elm$core$Maybe$Just($author$project$Main$GameWon)
						}),
					$elm$core$Platform$Cmd$none);
		}
	});
var $elm$core$Tuple$mapSecond = F2(
	function (func, _v0) {
		var x = _v0.a;
		var y = _v0.b;
		return _Utils_Tuple2(
			x,
			func(y));
	});
var $author$project$Main$applyEvents = F2(
	function (events, model) {
		return A3(
			$elm$core$List$foldl,
			F2(
				function (event, _v0) {
					var m = _v0.a;
					var c1 = _v0.b;
					return A2(
						$elm$core$Tuple$mapSecond,
						function (c2) {
							return $elm$core$Platform$Cmd$batch(
								_List_fromArray(
									[c1, c2]));
						},
						A2($author$project$Main$applyEvent, event, m));
				}),
			_Utils_Tuple2(model, $elm$core$Platform$Cmd$none),
			events);
	});
var $author$project$Main$ApplyEvents = function (a) {
	return {$: 'ApplyEvents', a: a};
};
var $author$project$Main$setGame = F2(
	function (model, game) {
		return _Utils_update(
			model,
			{
				game: game,
				history: A2($elm$core$List$cons, model.game, model.history)
			});
	});
var $author$project$Main$applyGameAndKill = F2(
	function (model, output) {
		return _Utils_Tuple2(
			A2($author$project$Main$setGame, model, output.game),
			A2(
				$elm$core$Task$perform,
				function (_v0) {
					return $author$project$Main$ApplyEvents(output.kill);
				},
				$elm$core$Process$sleep(100)));
	});
var $author$project$Game$getPlayerPosition = function (game) {
	return game.playerPos;
};
var $author$project$Main$gotSeed = F2(
	function (seed, model) {
		return _Utils_update(
			model,
			{seed: seed});
	});
var $author$project$Game$isWon = function (game) {
	return game.won;
};
var $author$project$Game$face = F2(
	function (direction, game) {
		return _Utils_update(
			game,
			{playerDirection: direction});
	});
var $author$project$Game$Event$Kill = function (a) {
	return {$: 'Kill', a: a};
};
var $author$project$Game$Event$MoveToRoom = function (a) {
	return {$: 'MoveToRoom', a: a};
};
var $author$project$Entity$Stunned = function (a) {
	return {$: 'Stunned', a: a};
};
var $author$project$Game$Event$WinGame = {$: 'WinGame'};
var $author$project$Position$addToVector = F2(
	function (_v0, _v1) {
		var x2 = _v0.a;
		var y2 = _v0.b;
		var x = _v1.x;
		var y = _v1.y;
		return _Utils_Tuple2(x2 + x, y2 + y);
	});
var $author$project$Math$posIsValid = function (_v0) {
	var x = _v0.a;
	var y = _v0.b;
	return ((0 <= x) && (_Utils_cmp(x, $author$project$Config$roomSize) < 0)) && ((0 <= y) && (_Utils_cmp(y, $author$project$Config$roomSize) < 0));
};
var $author$project$Direction$toVector = function (dir) {
	switch (dir.$) {
		case 'Right':
			return {x: 1, y: 0};
		case 'Down':
			return {x: 0, y: 1};
		case 'Left':
			return {x: -1, y: 0};
		default:
			return {x: 0, y: -1};
	}
};
var $author$project$Game$findFirstEmptyCellInDirection = F3(
	function (pos, direction, game) {
		findFirstEmptyCellInDirection:
		while (true) {
			var newPos = A2(
				$author$project$Position$addToVector,
				pos,
				$author$project$Direction$toVector(direction));
			if ($author$project$Math$posIsValid(newPos)) {
				var _v0 = A2($author$project$Game$get, newPos, game);
				if (_v0.$ === 'Just') {
					return pos;
				} else {
					var $temp$pos = newPos,
						$temp$direction = direction,
						$temp$game = game;
					pos = $temp$pos;
					direction = $temp$direction;
					game = $temp$game;
					continue findFirstEmptyCellInDirection;
				}
			} else {
				return pos;
			}
		}
	});
var $author$project$Game$Event$map = F2(
	function (fun, output) {
		return _Utils_update(
			output,
			{
				game: fun(output.game)
			});
	});
var $elm$core$Basics$not = _Basics_not;
var $author$project$Game$move = F2(
	function (args, game) {
		return ($author$project$Math$posIsValid(args.to) && (!A2($elm$core$Dict$member, args.to, game.cells))) ? A2(
			$elm$core$Maybe$map,
			function (a) {
				return function (cells) {
					return _Utils_update(
						game,
						{
							cells: cells,
							playerPos: _Utils_eq(
								$elm$core$Maybe$Just(args.from),
								game.playerPos) ? $elm$core$Maybe$Just(args.to) : game.playerPos
						});
				}(
					A2(
						$elm$core$Dict$remove,
						args.from,
						A3($elm$core$Dict$insert, args.to, a, game.cells)));
			},
			A2($elm$core$Dict$get, args.from, game.cells)) : $elm$core$Maybe$Nothing;
	});
var $author$project$Game$Event$none = function (game) {
	return {game: game, kill: _List_Nil};
};
var $author$project$Entity$CrateInLava = {$: 'CrateInLava'};
var $author$project$Game$addFloor = F3(
	function (pos, floor, game) {
		return _Utils_update(
			game,
			{
				floor: A3($elm$core$Dict$insert, pos, floor, game.floor)
			});
	});
var $author$project$Game$Update$pushCrate = F3(
	function (pos, dir, game) {
		var newPos = A2(
			$author$project$Position$addToVector,
			pos,
			$author$project$Direction$toVector(dir));
		if ($author$project$Math$posIsValid(newPos)) {
			var _v0 = A2($author$project$Game$get, newPos, game);
			if (_v0.$ === 'Nothing') {
				return A2($elm$core$Dict$member, newPos, game.floor) ? A2(
					$elm$core$Maybe$map,
					$author$project$Game$Event$none,
					A2(
						$author$project$Game$move,
						{from: pos, to: newPos},
						game)) : $elm$core$Maybe$Just(
					$author$project$Game$Event$none(
						A2(
							$author$project$Game$remove,
							pos,
							A3($author$project$Game$addFloor, newPos, $author$project$Entity$CrateInLava, game))));
			} else {
				if (_v0.a.$ === 'ActiveSmallBomb') {
					var _v1 = _v0.a;
					return A2(
						$elm$core$Maybe$map,
						function (g) {
							return {
								game: g,
								kill: _List_fromArray(
									[
										$author$project$Game$Event$Kill(newPos)
									])
							};
						},
						A2(
							$author$project$Game$move,
							{from: pos, to: newPos},
							A2($author$project$Game$remove, newPos, game)));
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Game$Update$pushSmallBomb = F3(
	function (pos, dir, game) {
		var newPos = A2(
			$author$project$Position$addToVector,
			pos,
			$author$project$Direction$toVector(dir));
		if ($author$project$Math$posIsValid(newPos)) {
			var _v0 = A2($author$project$Game$get, newPos, game);
			if (_v0.$ === 'Nothing') {
				return A2($elm$core$Dict$member, newPos, game.floor) ? A2(
					$elm$core$Maybe$map,
					$author$project$Game$Event$none,
					A2(
						$author$project$Game$move,
						{from: pos, to: newPos},
						game)) : $elm$core$Maybe$Just(
					$author$project$Game$Event$none(
						A2($author$project$Game$remove, pos, game)));
			} else {
				return A2(
					$elm$core$Maybe$map,
					function (g) {
						return {
							game: g,
							kill: _List_fromArray(
								[
									$author$project$Game$Event$Kill(newPos)
								])
						};
					},
					A2(
						$author$project$Game$move,
						{from: pos, to: newPos},
						A2($author$project$Game$remove, newPos, game)));
			}
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Entity$Orc = function (a) {
	return {$: 'Orc', a: a};
};
var $author$project$Direction$mirror = function (direction) {
	switch (direction.$) {
		case 'Up':
			return $author$project$Direction$Down;
		case 'Down':
			return $author$project$Direction$Up;
		case 'Left':
			return $author$project$Direction$Right;
		default:
			return $author$project$Direction$Left;
	}
};
var $author$project$Game$Enemy$stun = F2(
	function (direction, enemy) {
		if (enemy.$ === 'Orc') {
			return $author$project$Entity$Orc(
				$author$project$Direction$mirror(direction));
		} else {
			return enemy;
		}
	});
var $author$project$Game$addItem = F2(
	function (item, game) {
		return _Utils_eq(game.item, $elm$core$Maybe$Nothing) ? $elm$core$Maybe$Just(
			_Utils_update(
				game,
				{
					item: $elm$core$Maybe$Just(item)
				})) : $elm$core$Maybe$Nothing;
	});
var $author$project$Game$Update$takeItem = F2(
	function (pos, game) {
		return A2(
			$elm$core$Maybe$withDefault,
			game,
			A2(
				$elm$core$Maybe$map,
				function (g) {
					return _Utils_update(
						g,
						{
							items: A2($elm$core$Dict$remove, pos, g.items)
						});
				},
				A2(
					$elm$core$Maybe$andThen,
					function (item) {
						return A2($author$project$Game$addItem, item, game);
					},
					A2($elm$core$Dict$get, pos, game.items))));
	});
var $author$project$Game$Update$movePlayer = F2(
	function (position, game) {
		var newLocation = A2(
			$author$project$Position$addToVector,
			position,
			$author$project$Direction$toVector(game.playerDirection));
		var _v0 = A2(
			$elm$core$Maybe$map,
			function ($) {
				return $.entity;
			},
			A2($elm$core$Dict$get, newLocation, game.cells));
		if (_v0.$ === 'Just') {
			switch (_v0.a.$) {
				case 'ActiveSmallBomb':
					var _v1 = _v0.a;
					return A2(
						$elm$core$Maybe$map,
						$author$project$Game$Event$andThen(
							function (g) {
								return {
									game: A2($author$project$Game$Update$takeItem, newLocation, g),
									kill: _List_fromArray(
										[
											$author$project$Game$Event$Fx($author$project$Gen$Sound$Push)
										])
								};
							}),
						A2(
							$elm$core$Maybe$map,
							$author$project$Game$Event$map(
								function (g) {
									return A2(
										$elm$core$Maybe$withDefault,
										g,
										A2(
											$author$project$Game$move,
											{from: position, to: newLocation},
											g));
								}),
							A3($author$project$Game$Update$pushSmallBomb, newLocation, game.playerDirection, game)));
				case 'Crate':
					var _v2 = _v0.a;
					return A2(
						$elm$core$Maybe$map,
						$author$project$Game$Event$andThen(
							function (g) {
								return {
									game: g,
									kill: _List_fromArray(
										[
											$author$project$Game$Event$Fx($author$project$Gen$Sound$Push)
										])
								};
							}),
						A2(
							$elm$core$Maybe$map,
							$author$project$Game$Event$map(
								$author$project$Game$Update$takeItem(newLocation)),
							A2(
								$elm$core$Maybe$map,
								$author$project$Game$Event$map(
									function (g) {
										return A2(
											$elm$core$Maybe$withDefault,
											g,
											A2(
												$author$project$Game$move,
												{from: position, to: newLocation},
												g));
									}),
								A3($author$project$Game$Update$pushCrate, newLocation, game.playerDirection, game))));
				case 'InactiveBomb':
					var item = _v0.a.a;
					var newPos = A3($author$project$Game$findFirstEmptyCellInDirection, newLocation, game.playerDirection, game);
					return $elm$core$Maybe$Just(
						{
							game: function (g) {
								return A2(
									$elm$core$Maybe$withDefault,
									g,
									A2(
										$author$project$Game$move,
										{from: newLocation, to: newPos},
										g));
							}(
								A3(
									$author$project$Game$update,
									newLocation,
									function (_v3) {
										return $author$project$Entity$Stunned(
											A2(
												$author$project$Game$Enemy$stun,
												game.playerDirection,
												$author$project$Entity$ActivatedBomb(item)));
									},
									game)),
							kill: A2($elm$core$Dict$member, newPos, game.floor) ? _List_fromArray(
								[
									$author$project$Game$Event$Fx($author$project$Gen$Sound$Push)
								]) : _List_fromArray(
								[
									$author$project$Game$Event$Kill(newPos),
									$author$project$Game$Event$Fx($author$project$Gen$Sound$Push)
								])
						});
				case 'Diamant':
					var _v4 = _v0.a;
					return $elm$core$Maybe$Just(
						{
							game: game,
							kill: _List_fromArray(
								[$author$project$Game$Event$WinGame])
						});
				default:
					return $elm$core$Maybe$Nothing;
			}
		} else {
			return ($author$project$Math$posIsValid(newLocation) && A2($elm$core$Dict$member, newLocation, game.floor)) ? $elm$core$Maybe$Just(
				$author$project$Game$Event$none(
					A2(
						$elm$core$Maybe$withDefault,
						game,
						A2(
							$elm$core$Maybe$map,
							$author$project$Game$Update$takeItem(newLocation),
							A2(
								$author$project$Game$move,
								{from: position, to: newLocation},
								game))))) : A2(
				$elm$core$Maybe$map,
				function (door) {
					return {
						game: _Utils_update(
							game,
							{
								cells: A2(
									$elm$core$Maybe$withDefault,
									game.cells,
									A2(
										$elm$core$Maybe$map,
										function (a) {
											return A2(
												$elm$core$Dict$remove,
												position,
												A3($elm$core$Dict$insert, newLocation, a, game.cells));
										},
										A2($elm$core$Dict$get, position, game.cells))),
								playerPos: $elm$core$Maybe$Just(newLocation),
								won: true
							}),
						kill: _List_fromArray(
							[
								$author$project$Game$Event$MoveToRoom(door.room)
							])
					};
				},
				A2($elm$core$Dict$get, newLocation, game.doors));
		}
	});
var $author$project$Game$clearParticles = function (game) {
	return _Utils_update(
		game,
		{particles: $elm$core$Dict$empty});
};
var $author$project$Direction$asList = _List_fromArray(
	[$author$project$Direction$Up, $author$project$Direction$Down, $author$project$Direction$Left, $author$project$Direction$Right]);
var $author$project$Game$Enemy$updateCrossBomb = F2(
	function (pos, game) {
		return A3(
			$elm$core$List$foldl,
			F2(
				function (newPos, output) {
					if ($author$project$Math$posIsValid(newPos)) {
						var _v0 = A2($author$project$Game$get, newPos, output.game);
						if ((_v0.$ === 'Just') && (_v0.a.$ === 'Player')) {
							var _v1 = _v0.a;
							return output;
						} else {
							return _Utils_update(
								output,
								{
									kill: A2(
										$elm$core$List$cons,
										$author$project$Game$Event$Kill(newPos),
										output.kill)
								});
						}
					} else {
						return output;
					}
				}),
			{
				game: A2($author$project$Game$removeFloor, pos, game),
				kill: _List_fromArray(
					[
						$author$project$Game$Event$Kill(pos)
					])
			},
			A2(
				$elm$core$List$concatMap,
				function (direction) {
					return A2(
						$elm$core$List$map,
						function (n) {
							return A2(
								$author$project$Position$addToVector,
								pos,
								function (v) {
									return {x: v.x * n, y: v.y * n};
								}(
									$author$project$Direction$toVector(direction)));
						},
						A2($elm$core$List$range, 1, $author$project$Config$roomSize - 1));
				},
				_List_fromArray(
					[$author$project$Direction$Up, $author$project$Direction$Down, $author$project$Direction$Left, $author$project$Direction$Right])));
	});
var $author$project$Game$Enemy$tryMoving = F2(
	function (args, game) {
		return A2($elm$core$Dict$member, args.to, game.floor) ? A2($author$project$Game$move, args, game) : $elm$core$Maybe$Nothing;
	});
var $author$project$Game$Enemy$updateDoppelganger = F2(
	function (pos, game) {
		var newPos = A2(
			$author$project$Position$addToVector,
			pos,
			$author$project$Direction$toVector(
				$author$project$Direction$mirror(game.playerDirection)));
		var _v0 = A2($author$project$Game$get, newPos, game);
		if (_v0.$ === 'Just') {
			if (_v0.a.$ === 'Player') {
				var _v1 = _v0.a;
				return game;
			} else {
				return game;
			}
		} else {
			return A2(
				$elm$core$Maybe$withDefault,
				game,
				A2(
					$author$project$Game$Enemy$tryMoving,
					{from: pos, to: newPos},
					game));
		}
	});
var $author$project$Game$Enemy$updateDynamite = F2(
	function (location, game) {
		return A3(
			$elm$core$List$foldl,
			F2(
				function (direction, output) {
					var newLocation = A2(
						$author$project$Position$addToVector,
						location,
						$author$project$Direction$toVector(direction));
					if ($author$project$Math$posIsValid(newLocation)) {
						var _v0 = A2($author$project$Game$get, newLocation, output.game);
						if ((_v0.$ === 'Just') && (_v0.a.$ === 'Player')) {
							var _v1 = _v0.a;
							return output;
						} else {
							return _Utils_update(
								output,
								{
									kill: A2(
										$elm$core$List$cons,
										$author$project$Game$Event$Kill(newLocation),
										output.kill)
								});
						}
					} else {
						return output;
					}
				}),
			{
				game: game,
				kill: _List_fromArray(
					[
						$author$project$Game$Event$Kill(location),
						$author$project$Game$Event$Fx($author$project$Gen$Sound$Explosion)
					])
			},
			_List_fromArray(
				[$author$project$Direction$Up, $author$project$Direction$Down, $author$project$Direction$Left, $author$project$Direction$Right]));
	});
var $author$project$Game$findFirstInDirection = F3(
	function (position, direction, game) {
		findFirstInDirection:
		while (true) {
			var newPos = A2(
				$author$project$Position$addToVector,
				position,
				$author$project$Direction$toVector(direction));
			if ($author$project$Math$posIsValid(newPos)) {
				var _v0 = A2($elm$core$Dict$get, newPos, game.cells);
				if (_v0.$ === 'Nothing') {
					var $temp$position = newPos,
						$temp$direction = direction,
						$temp$game = game;
					position = $temp$position;
					direction = $temp$direction;
					game = $temp$game;
					continue findFirstInDirection;
				} else {
					var a = _v0.a;
					return $elm$core$Maybe$Just(a.entity);
				}
			} else {
				return $elm$core$Maybe$Nothing;
			}
		}
	});
var $author$project$Game$Enemy$updateGoblin = F2(
	function (position, game) {
		return A2(
			$elm$core$Maybe$withDefault,
			game,
			A3(
				$elm$core$List$foldl,
				F2(
					function (direction, out) {
						if (_Utils_eq(out, $elm$core$Maybe$Nothing)) {
							var _v0 = A3($author$project$Game$findFirstInDirection, position, direction, game);
							_v0$2:
							while (true) {
								if (_v0.$ === 'Just') {
									switch (_v0.a.$) {
										case 'Player':
											var _v1 = _v0.a;
											return A2(
												$author$project$Game$Enemy$tryMoving,
												{
													from: position,
													to: A2(
														$author$project$Position$addToVector,
														position,
														$author$project$Direction$toVector(direction))
												},
												game);
										case 'Enemy':
											if (_v0.a.a.$ === 'ActivatedBomb') {
												return A2(
													$author$project$Game$Enemy$tryMoving,
													{
														from: position,
														to: A2(
															$author$project$Position$addToVector,
															position,
															$author$project$Direction$toVector(
																$author$project$Direction$mirror(direction)))
													},
													game);
											} else {
												break _v0$2;
											}
										default:
											break _v0$2;
									}
								} else {
									break _v0$2;
								}
							}
							return $elm$core$Maybe$Nothing;
						} else {
							return out;
						}
					}),
				$elm$core$Maybe$Nothing,
				_List_fromArray(
					[$author$project$Direction$Up, $author$project$Direction$Down, $author$project$Direction$Left, $author$project$Direction$Right])));
	});
var $author$project$Game$Enemy$updateOrc = F3(
	function (pos, direction, game) {
		var newPos = A2(
			$author$project$Position$addToVector,
			pos,
			$author$project$Direction$toVector(direction));
		var moveToPosOr = F3(
			function (p, fun, g) {
				if ($author$project$Math$posIsValid(p)) {
					var _v3 = A2($author$project$Game$get, p, g);
					if (_v3.$ === 'Just') {
						return fun(_Utils_Tuple0);
					} else {
						var _v4 = A2(
							$elm$core$Maybe$map,
							function (newGame) {
								return newGame;
							},
							A2(
								$author$project$Game$Enemy$tryMoving,
								{from: pos, to: p},
								g));
						if (_v4.$ === 'Just') {
							var a = _v4.a;
							return a;
						} else {
							return fun(_Utils_Tuple0);
						}
					}
				} else {
					return fun(_Utils_Tuple0);
				}
			});
		var backPos = A2(
			$author$project$Position$addToVector,
			pos,
			$author$project$Direction$toVector(
				$author$project$Direction$mirror(direction)));
		return A3(
			moveToPosOr,
			newPos,
			function (_v0) {
				return A3(
					moveToPosOr,
					backPos,
					function (_v1) {
						return game;
					},
					A3(
						$author$project$Game$update,
						pos,
						function (_v2) {
							return $author$project$Entity$Enemy(
								$author$project$Entity$Orc(
									$author$project$Direction$mirror(direction)));
						},
						game));
			},
			game);
	});
var $author$project$Game$Enemy$updateRat = F2(
	function (position, game) {
		return A2(
			$elm$core$Maybe$withDefault,
			game,
			A3(
				$elm$core$List$foldl,
				F2(
					function (direction, out) {
						if (_Utils_eq(out, $elm$core$Maybe$Nothing)) {
							var _v0 = A3($author$project$Game$findFirstInDirection, position, direction, game);
							if ((_v0.$ === 'Just') && (_v0.a.$ === 'Player')) {
								var _v1 = _v0.a;
								return A2(
									$author$project$Game$Enemy$tryMoving,
									{
										from: position,
										to: A2(
											$author$project$Position$addToVector,
											position,
											$author$project$Direction$toVector(direction))
									},
									game);
							} else {
								return $elm$core$Maybe$Nothing;
							}
						} else {
							return out;
						}
					}),
				$elm$core$Maybe$Nothing,
				_List_fromArray(
					[$author$project$Direction$Up, $author$project$Direction$Down, $author$project$Direction$Left, $author$project$Direction$Right])));
	});
var $author$project$Game$Enemy$update = F2(
	function (args, game) {
		var neighboringPlayer = A2(
			$elm$core$List$filter,
			function (newPos) {
				return _Utils_eq(
					A2($author$project$Game$get, newPos, game),
					$elm$core$Maybe$Just($author$project$Entity$Player));
			},
			A2(
				$elm$core$List$map,
				function (dir) {
					return A2(
						$author$project$Position$addToVector,
						args.pos,
						$author$project$Direction$toVector(dir));
				},
				$author$project$Direction$asList));
		return function (out) {
			return _Utils_update(
				out,
				{
					kill: _Utils_ap(
						A2($elm$core$List$map, $author$project$Game$Event$Kill, neighboringPlayer),
						out.kill)
				});
		}(
			function () {
				var _v0 = args.enemy;
				switch (_v0.$) {
					case 'ActivatedBomb':
						var item = _v0.a;
						if (item.$ === 'Bomb') {
							return A2($author$project$Game$Enemy$updateDynamite, args.pos, game);
						} else {
							return A2($author$project$Game$Enemy$updateCrossBomb, args.pos, game);
						}
					case 'Goblin':
						return $author$project$Game$Event$none(
							A2($author$project$Game$Enemy$updateGoblin, args.pos, game));
					case 'Orc':
						var dir = _v0.a;
						return $author$project$Game$Event$none(
							A3($author$project$Game$Enemy$updateOrc, args.pos, dir, game));
					case 'Doppelganger':
						return $author$project$Game$Event$none(
							A2($author$project$Game$Enemy$updateDoppelganger, args.pos, game));
					default:
						return $author$project$Game$Event$none(
							A2($author$project$Game$Enemy$updateRat, args.pos, game));
				}
			}());
	});
var $author$project$Game$Update$updateCell = F2(
	function (_v0, game) {
		var position = _v0.a;
		var cell = _v0.b;
		var _v1 = cell.entity;
		switch (_v1.$) {
			case 'Enemy':
				var enemy = _v1.a;
				return A2(
					$author$project$Game$Enemy$update,
					{enemy: enemy, pos: position},
					game);
			case 'Stunned':
				var enemy = _v1.a;
				return $author$project$Game$Event$none(
					A3(
						$author$project$Game$update,
						position,
						function (_v2) {
							return $author$project$Entity$Enemy(enemy);
						},
						game));
			default:
				return $author$project$Game$Event$none(game);
		}
	});
var $author$project$Game$Update$updateGame = function (game) {
	return A3(
		$elm$core$List$foldl,
		function (tuple) {
			return $author$project$Game$Event$andThen(
				$author$project$Game$Update$updateCell(tuple));
		},
		$author$project$Game$Event$none(
			$author$project$Game$clearParticles(game)),
		$elm$core$Dict$toList(game.cells));
};
var $author$project$Game$Update$movePlayerInDirectionAndUpdateGame = F3(
	function (dir, location, game) {
		return A2(
			$elm$core$Maybe$map,
			$author$project$Game$Event$andThen($author$project$Game$Update$updateGame),
			A2(
				$author$project$Game$Update$movePlayer,
				location,
				A2($author$project$Game$face, dir, game)));
	});
var $elm$core$Basics$modBy = _Basics_modBy;
var $author$project$Main$nextFrameRequested = function (model) {
	return _Utils_update(
		model,
		{
			frame: A2($elm$core$Basics$modBy, 2, model.frame + 1)
		});
};
var $author$project$Main$startRoom = F2(
	function (game, model) {
		return _Utils_update(
			model,
			{
				game: A2(
					$author$project$Game$addPlayer,
					model.initialPlayerPos,
					_Utils_update(
						game,
						{item: model.game.item})),
				overlay: $elm$core$Maybe$Nothing
			});
	});
var $author$project$Main$nextRoom = F2(
	function (room, model) {
		var game = $author$project$World$Map$get(room);
		return A2(
			$author$project$Main$startRoom,
			game,
			_Utils_update(
				model,
				{
					history: _List_Nil,
					initialPlayerPos: A2(
						$elm$core$Maybe$withDefault,
						model.initialPlayerPos,
						A2(
							$elm$core$Maybe$map,
							function (_v0) {
								var x = _v0.a;
								var y = _v0.b;
								return _Utils_Tuple2(
									A2($elm$core$Basics$modBy, $author$project$Config$roomSize, x),
									A2($elm$core$Basics$modBy, $author$project$Config$roomSize, y));
							},
							model.game.playerPos)),
					room: room
				}));
	});
var $author$project$Game$Update$applyBomb = F2(
	function (position, game) {
		var newPosition = A2(
			$author$project$Position$addToVector,
			position,
			$author$project$Direction$toVector(game.playerDirection));
		return A2(
			$elm$core$Maybe$andThen,
			function (item) {
				if ($author$project$Math$posIsValid(newPosition)) {
					var _v0 = A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.entity;
						},
						A2($elm$core$Dict$get, newPosition, game.cells));
					if (_v0.$ === 'Nothing') {
						return A2($elm$core$Dict$member, newPosition, game.floor) ? $elm$core$Maybe$Just(
							A3(
								$author$project$Game$insert,
								newPosition,
								$author$project$Entity$Stunned(
									$author$project$Entity$ActivatedBomb(item)),
								game)) : $elm$core$Maybe$Nothing;
					} else {
						return $elm$core$Maybe$Nothing;
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			},
			game.item);
	});
var $author$project$Game$removeItem = function (game) {
	return _Utils_update(
		game,
		{item: $elm$core$Maybe$Nothing});
};
var $author$project$Game$Update$placeBombeAndUpdateGame = F2(
	function (playerCell, game) {
		return A2(
			$elm$core$Maybe$map,
			$author$project$Game$Update$updateGame,
			A2(
				$elm$core$Maybe$map,
				$author$project$Game$removeItem,
				A2($author$project$Game$Update$applyBomb, playerCell, game)));
	});
var $author$project$Main$restartRoom = function (model) {
	return _Utils_Tuple2(
		A2(
			$author$project$Main$nextRoom,
			model.room,
			_Utils_update(
				model,
				{
					game: function (game) {
						return _Utils_update(
							game,
							{
								item: model.initialItem,
								playerPos: $elm$core$Maybe$Just(model.initialPlayerPos)
							});
					}(model.game),
					history: _List_Nil
				})),
		$author$project$Port$fromElm(
			$author$project$PortDefinition$PlaySound(
				{looping: false, sound: $author$project$Gen$Sound$Retry})));
};
var $author$project$World$move = F2(
	function (dir, world) {
		var newPos = A2(
			$author$project$Position$addToVector,
			world.player,
			$author$project$Direction$toVector(dir));
		var _v0 = A2($elm$core$Dict$get, newPos, world.nodes);
		if ((_v0.$ === 'Just') && (_v0.a.$ === 'Room')) {
			return $elm$core$Maybe$Just(
				_Utils_update(
					world,
					{player: newPos}));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Main$updateWorldMap = F2(
	function (input, model) {
		switch (input.$) {
			case 'InputActivate':
				var _v1 = A2($elm$core$Dict$get, model.world.player, model.world.nodes);
				if ((_v1.$ === 'Just') && (_v1.a.$ === 'Room')) {
					var seed = _v1.a.a.seed;
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
			case 'InputDir':
				var dir = input.a;
				return _Utils_Tuple2(
					A2(
						$elm$core$Maybe$withDefault,
						model,
						A2(
							$elm$core$Maybe$map,
							function (world) {
								return _Utils_update(
									model,
									{world: world});
							},
							A2($author$project$World$move, dir, model.world))),
					$elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Main$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'Input':
				var input = msg.a;
				var _v1 = model.overlay;
				if (_v1.$ === 'Just') {
					switch (_v1.a.$) {
						case 'GameWon':
							var _v2 = _v1.a;
							return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
						case 'WorldMap':
							var _v3 = _v1.a;
							return A2($author$project$Main$updateWorldMap, input, model);
						default:
							var _v4 = _v1.a;
							return _Utils_Tuple2(
								_Utils_update(
									model,
									{overlay: $elm$core$Maybe$Nothing}),
								$elm$core$Platform$Cmd$none);
					}
				} else {
					if ($author$project$Game$isWon(model.game)) {
						return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
					} else {
						switch (input.$) {
							case 'InputActivate':
								return A2(
									$elm$core$Maybe$withDefault,
									_Utils_Tuple2(model, $elm$core$Platform$Cmd$none),
									A2(
										$elm$core$Maybe$andThen,
										function (playerPosition) {
											return A2(
												$elm$core$Maybe$map,
												$author$project$Main$applyGameAndKill(model),
												A2($author$project$Game$Update$placeBombeAndUpdateGame, playerPosition, model.game));
										},
										$author$project$Game$getPlayerPosition(model.game)));
							case 'InputDir':
								var dir = input.a;
								return A2(
									$elm$core$Maybe$withDefault,
									_Utils_Tuple2(model, $elm$core$Platform$Cmd$none),
									A2(
										$elm$core$Maybe$andThen,
										function (playerPosition) {
											return A2(
												$elm$core$Maybe$map,
												$author$project$Main$applyGameAndKill(model),
												A2(
													$elm$core$Maybe$map,
													$author$project$Game$Event$andThen(
														function (m) {
															return {
																game: m,
																kill: _List_fromArray(
																	[
																		$author$project$Game$Event$Fx($author$project$Gen$Sound$Move)
																	])
															};
														}),
													A3($author$project$Game$Update$movePlayerInDirectionAndUpdateGame, dir, playerPosition, model.game)));
										},
										$author$project$Game$getPlayerPosition(model.game)));
							case 'InputUndo':
								var _v6 = model.history;
								if (_v6.b) {
									var head = _v6.a;
									var tail = _v6.b;
									return _Utils_Tuple2(
										_Utils_update(
											model,
											{game: head, history: tail}),
										$author$project$Port$fromElm(
											$author$project$PortDefinition$PlaySound(
												{looping: false, sound: $author$project$Gen$Sound$Undo})));
								} else {
									return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
								}
							case 'InputReset':
								return $author$project$Main$restartRoom(model);
							default:
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											overlay: $elm$core$Maybe$Just($author$project$Main$WorldMap)
										}),
									$elm$core$Platform$Cmd$none);
						}
					}
				}
			case 'ApplyEvents':
				var events = msg.a;
				return A2($author$project$Main$applyEvents, events, model);
			case 'NextFrameRequested':
				return _Utils_Tuple2(
					$author$project$Main$nextFrameRequested(model),
					$elm$core$Platform$Cmd$none);
			case 'GotSeed':
				var seed = msg.a;
				return _Utils_Tuple2(
					A2($author$project$Main$gotSeed, seed, model),
					$elm$core$Platform$Cmd$none);
			case 'NoOps':
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
			case 'RoomEntered':
				var id = msg.a;
				return _Utils_Tuple2(
					A2($author$project$Main$nextRoom, id, model),
					$elm$core$Platform$Cmd$none);
			default:
				var result = msg.a;
				if (result.$ === 'Ok') {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
				}
		}
	});
var $author$project$Config$cellSize = 64;
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $Orasund$elm_layout$Layout$alignAtCenter = A2($elm$html$Html$Attributes$style, 'align-items', 'center');
var $Orasund$elm_layout$Layout$contentCentered = A2($elm$html$Html$Attributes$style, 'justify-content', 'center');
var $Orasund$elm_layout$Layout$centered = _List_fromArray(
	[$Orasund$elm_layout$Layout$contentCentered, $Orasund$elm_layout$Layout$alignAtCenter]);
var $elm$html$Html$div = _VirtualDom_node('div');
var $Orasund$elm_layout$Layout$column = function (attrs) {
	return $elm$html$Html$div(
		_Utils_ap(
			_List_fromArray(
				[
					A2($elm$html$Html$Attributes$style, 'display', 'flex'),
					A2($elm$html$Html$Attributes$style, 'flex-direction', 'column')
				]),
			attrs));
};
var $Orasund$elm_layout$Layout$el = F2(
	function (attrs, content) {
		return A2(
			$elm$html$Html$div,
			A2(
				$elm$core$List$cons,
				A2($elm$html$Html$Attributes$style, 'display', 'flex'),
				attrs),
			_List_fromArray(
				[content]));
	});
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$class = $elm$html$Html$Attributes$stringProperty('className');
var $elm$core$String$fromFloat = _String_fromNumber;
var $Orasund$elm_layout$Layout$gap = function (n) {
	return A2(
		$elm$html$Html$Attributes$style,
		'gap',
		$elm$core$String$fromFloat(n) + 'px');
};
var $Orasund$elm_layout$Html$Style$height = $elm$html$Html$Attributes$style('height');
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $Orasund$elm_layout$Layout$text = F2(
	function (attrs, content) {
		return A2(
			$Orasund$elm_layout$Layout$el,
			attrs,
			$elm$html$Html$text(content));
	});
var $Orasund$elm_layout$Html$Style$width = $elm$html$Html$Attributes$style('width');
var $author$project$View$Screen$gameWon = A2(
	$Orasund$elm_layout$Layout$column,
	_Utils_ap(
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class('dark-background'),
				$Orasund$elm_layout$Html$Style$width('400px'),
				$Orasund$elm_layout$Html$Style$height('400px'),
				A2($elm$html$Html$Attributes$style, 'color', 'white'),
				$Orasund$elm_layout$Layout$gap(16)
			]),
		$Orasund$elm_layout$Layout$centered),
	_List_fromArray(
		[
			A2(
			$Orasund$elm_layout$Layout$text,
			_List_fromArray(
				[
					A2($elm$html$Html$Attributes$style, 'font-size', '46px'),
					$Orasund$elm_layout$Layout$contentCentered
				]),
			'Thanks'),
			A2(
			$Orasund$elm_layout$Layout$text,
			_List_fromArray(
				[
					A2($elm$html$Html$Attributes$style, 'font-size', '46px'),
					$Orasund$elm_layout$Layout$contentCentered
				]),
			'for playing')
		]));
var $elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var $elm$html$Html$Attributes$attribute = $elm$virtual_dom$VirtualDom$attribute;
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $Orasund$elm_layout$Layout$asButton = function (args) {
	return _Utils_ap(
		_List_fromArray(
			[
				A2($elm$html$Html$Attributes$style, 'cursor', 'pointer'),
				A2($elm$html$Html$Attributes$attribute, 'aria-label', args.label),
				A2($elm$html$Html$Attributes$attribute, 'role', 'button')
			]),
		A2(
			$elm$core$Maybe$withDefault,
			_List_Nil,
			A2(
				$elm$core$Maybe$map,
				function (msg) {
					return _List_fromArray(
						[
							$elm$html$Html$Events$onClick(msg)
						]);
				},
				args.onPress)));
};
var $elm$html$Html$img = _VirtualDom_node('img');
var $author$project$Image$pixelated = A2($elm$html$Html$Attributes$style, 'image-rendering', 'pixelated');
var $elm$html$Html$Attributes$src = function (url) {
	return A2(
		$elm$html$Html$Attributes$stringProperty,
		'src',
		_VirtualDom_noJavaScriptOrHtmlUri(url));
};
var $author$project$Image$image = F2(
	function (attrs, args) {
		return A2(
			$elm$html$Html$img,
			_Utils_ap(
				_List_fromArray(
					[
						$author$project$Image$pixelated,
						$elm$html$Html$Attributes$src(args.url),
						A2(
						$elm$html$Html$Attributes$style,
						'width',
						$elm$core$String$fromFloat(args.width) + 'px'),
						A2(
						$elm$html$Html$Attributes$style,
						'height',
						$elm$core$String$fromFloat(args.height) + 'px')
					]),
				attrs),
			_List_Nil);
	});
var $author$project$View$Screen$menu = F2(
	function (attrs, args) {
		return A2(
			$Orasund$elm_layout$Layout$column,
			_Utils_ap(
				_List_fromArray(
					[
						$elm$html$Html$Attributes$class('dark-background'),
						$Orasund$elm_layout$Html$Style$width('400px'),
						$Orasund$elm_layout$Html$Style$height('400px')
					]),
				_Utils_ap(
					$Orasund$elm_layout$Layout$asButton(
						{
							label: 'Next Level',
							onPress: $elm$core$Maybe$Just(args.onClick)
						}),
					_Utils_ap(attrs, $Orasund$elm_layout$Layout$centered))),
			_List_fromArray(
				[
					A2(
					$Orasund$elm_layout$Layout$column,
					_Utils_ap(
						_List_fromArray(
							[
								A2($elm$html$Html$Attributes$style, 'color', 'white'),
								$Orasund$elm_layout$Layout$gap(32)
							]),
						$Orasund$elm_layout$Layout$centered),
					_List_fromArray(
						[
							A2(
							$author$project$Image$image,
							_List_fromArray(
								[$author$project$Image$pixelated, $Orasund$elm_layout$Layout$contentCentered]),
							{height: 19 * 8, url: 'assets/logo.png', width: 39 * 8}),
							A2(
							$Orasund$elm_layout$Layout$text,
							_List_fromArray(
								[
									A2($elm$html$Html$Attributes$style, 'font-size', '18px')
								]),
							'Tap or press SPACE to start')
						]))
				]));
	});
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Image$bitmap = F3(
	function (attrs, args, list) {
		var zero = $elm$core$List$head(
			A2(
				$elm$core$List$filterMap,
				function (_v2) {
					var pos = _v2.a;
					var color = _v2.b;
					return _Utils_eq(
						pos,
						_Utils_Tuple2(0, 0)) ? $elm$core$Maybe$Just(color) : $elm$core$Maybe$Nothing;
				},
				list));
		var width = $elm$core$String$fromFloat(args.columns * args.pixelSize) + 'px';
		var height = $elm$core$String$fromFloat(args.rows * args.pixelSize) + 'px';
		return A2(
			$elm$html$Html$div,
			_Utils_ap(
				_List_fromArray(
					[
						A2($elm$html$Html$Attributes$style, 'width', width),
						A2($elm$html$Html$Attributes$style, 'height', height)
					]),
				attrs),
			_List_fromArray(
				[
					A2(
					$elm$html$Html$div,
					_List_fromArray(
						[
							A2(
							$elm$html$Html$Attributes$style,
							'box-shadow',
							A2(
								$elm$core$String$join,
								',',
								A2(
									$elm$core$List$map,
									function (_v0) {
										var _v1 = _v0.a;
										var x = _v1.a;
										var y = _v1.b;
										var color = _v0.b;
										return A2(
											$elm$core$String$join,
											' ',
											_List_fromArray(
												[
													$elm$core$String$fromFloat(x * args.pixelSize) + 'px',
													$elm$core$String$fromFloat(y * args.pixelSize) + 'px',
													color
												]));
									},
									list))),
							A2(
							$elm$html$Html$Attributes$style,
							'width',
							$elm$core$String$fromFloat(args.pixelSize) + 'px'),
							A2(
							$elm$html$Html$Attributes$style,
							'height',
							$elm$core$String$fromFloat(args.pixelSize) + 'px'),
							A2(
							$elm$html$Html$Attributes$style,
							'background',
							A2($elm$core$Maybe$withDefault, 'transparent', zero))
						]),
					_List_Nil)
				]));
	});
var $author$project$View$Color$black = '#140c1c';
var $author$project$View$Color$red = '#d04648';
var $author$project$View$Color$white = 'white';
var $author$project$View$Color$yellow = '#dad45e';
var $author$project$View$Bitmap$fromEmojis = F3(
	function (attrs, args, rows) {
		return A3(
			$author$project$Image$bitmap,
			attrs,
			{columns: 16, pixelSize: args.pixelSize, rows: 16},
			A2(
				$elm$core$List$filterMap,
				function (_v0) {
					var pos = _v0.a;
					var _char = _v0.b;
					switch (_char.valueOf()) {
						case '⬜':
							return $elm$core$Maybe$Just(
								_Utils_Tuple2(pos, $author$project$View$Color$white));
						case '⬛':
							return $elm$core$Maybe$Just(
								_Utils_Tuple2(pos, $author$project$View$Color$black));
						case '🟨':
							return $elm$core$Maybe$Just(
								_Utils_Tuple2(pos, $author$project$View$Color$yellow));
						case '🟥':
							return $elm$core$Maybe$Just(
								_Utils_Tuple2(pos, $author$project$View$Color$red));
						case '🔘':
							return $elm$core$Maybe$Just(
								_Utils_Tuple2(pos, args.color));
						case '❌':
							return $elm$core$Maybe$Nothing;
						default:
							return $elm$core$Maybe$Nothing;
					}
				},
				$elm$core$List$concat(
					A2(
						$elm$core$List$indexedMap,
						F2(
							function (y, string) {
								return A2(
									$elm$core$List$indexedMap,
									function (x) {
										return $elm$core$Tuple$pair(
											_Utils_Tuple2(x, y));
									},
									$elm$core$String$toList(string));
							}),
						rows))));
	});
var $author$project$View$Controls$fromEmojis = function (attrs) {
	return A2(
		$author$project$View$Bitmap$fromEmojis,
		attrs,
		{color: 'white', pixelSize: 72 / 16});
};
var $author$project$View$Controls$control = function (attrs) {
	return A2(
		$author$project$View$Controls$fromEmojis,
		attrs,
		_List_fromArray(
			['❌❌❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌', '❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌🔘❌', '❌❌❌❌❌❌❌❌❌🔘🔘❌❌❌🔘❌', '❌❌❌❌❌❌❌❌🔘❌❌❌❌❌🔘❌', '❌❌❌❌❌❌🔘🔘❌❌❌❌❌❌🔘❌', '❌❌❌❌🔘🔘❌❌❌❌❌❌❌❌🔘❌', '❌❌❌🔘❌❌❌❌❌❌❌❌❌❌🔘❌', '❌❌🔘❌❌❌❌❌❌❌❌❌❌❌🔘❌', '❌❌🔘❌❌❌❌❌❌❌❌❌❌❌🔘❌', '❌❌❌🔘❌❌❌❌❌❌❌❌❌❌🔘❌', '❌❌❌❌🔘🔘❌❌❌❌❌❌❌❌🔘❌', '❌❌❌❌❌❌🔘🔘❌❌❌❌❌❌🔘❌', '❌❌❌❌❌❌❌❌🔘❌❌❌❌❌🔘❌', '❌❌❌❌❌❌❌❌❌🔘🔘❌❌❌🔘❌', '❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌🔘❌', '❌❌❌❌❌❌❌❌❌❌❌❌❌🔘🔘❌']));
};
var $author$project$View$Controls$arrow = function (attrs) {
	return $author$project$View$Controls$control(attrs);
};
var $Orasund$elm_layout$Html$Style$bottom = $elm$html$Html$Attributes$style('bottom');
var $Orasund$elm_layout$Html$Style$boxSizing = $elm$html$Html$Attributes$style('box-sizing');
var $Orasund$elm_layout$Html$Style$boxSizingBorderBox = $Orasund$elm_layout$Html$Style$boxSizing('border-box');
var $Orasund$elm_layout$Html$Style$left = $elm$html$Html$Attributes$style('left');
var $Orasund$elm_layout$Layout$none = $elm$html$Html$text('');
var $Orasund$elm_layout$Html$Style$position = $elm$html$Html$Attributes$style('position');
var $Orasund$elm_layout$Html$Style$positionAbsolute = $Orasund$elm_layout$Html$Style$position('absolute');
var $Orasund$elm_layout$Html$Style$positionRelative = $Orasund$elm_layout$Html$Style$position('relative');
var $Orasund$elm_layout$Html$Style$right = $elm$html$Html$Attributes$style('right');
var $Orasund$elm_layout$Layout$row = function (attrs) {
	return $elm$html$Html$div(
		_Utils_ap(
			_List_fromArray(
				[
					A2($elm$html$Html$Attributes$style, 'display', 'flex'),
					A2($elm$html$Html$Attributes$style, 'flex-direction', 'row'),
					A2($elm$html$Html$Attributes$style, 'flex-wrap', 'wrap')
				]),
			attrs));
};
var $Orasund$elm_layout$Html$Style$top = $elm$html$Html$Attributes$style('top');
var $author$project$View$Controls$toHtml = function (args) {
	return A2(
		$Orasund$elm_layout$Layout$column,
		$Orasund$elm_layout$Layout$centered,
		_List_fromArray(
			[
				A2(
				$Orasund$elm_layout$Layout$row,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						_Utils_ap(
							$Orasund$elm_layout$Layout$asButton(
								{
									label: 'Retry',
									onPress: $elm$core$Maybe$Just(
										args.onInput($author$project$Input$InputReset))
								}),
							_List_fromArray(
								[
									$Orasund$elm_layout$Html$Style$positionRelative,
									$Orasund$elm_layout$Html$Style$width('72px'),
									$Orasund$elm_layout$Html$Style$height('72px')
								])),
						_List_fromArray(
							[
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											A2($elm$html$Html$Attributes$style, 'color', 'white'),
											$Orasund$elm_layout$Html$Style$bottom('0px'),
											$Orasund$elm_layout$Html$Style$width('72px')
										]),
									$Orasund$elm_layout$Layout$centered),
								args.isLevelSelect ? '' : 'Retry'),
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('16px'),
											$Orasund$elm_layout$Html$Style$left('20px'),
											$Orasund$elm_layout$Html$Style$width('32px'),
											$Orasund$elm_layout$Html$Style$height('32px'),
											A2($elm$html$Html$Attributes$style, 'border', '4px solid white'),
											A2($elm$html$Html$Attributes$style, 'font-size', '20px'),
											A2($elm$html$Html$Attributes$style, 'color', 'white'),
											$Orasund$elm_layout$Html$Style$boxSizingBorderBox
										]),
									$Orasund$elm_layout$Layout$centered),
								'R')
							])),
						A2(
						$elm$html$Html$div,
						A2(
							$elm$core$List$cons,
							$Orasund$elm_layout$Html$Style$positionRelative,
							$Orasund$elm_layout$Layout$asButton(
								{
									label: 'Move Up',
									onPress: $elm$core$Maybe$Just(
										args.onInput(
											$author$project$Input$InputDir($author$project$Direction$Up)))
								})),
						_List_fromArray(
							[
								$author$project$View$Controls$arrow(
								_List_fromArray(
									[
										A2($elm$html$Html$Attributes$style, 'transform', 'rotate(90deg)')
									])),
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$bottom('16px'),
											$Orasund$elm_layout$Html$Style$width('72px'),
											A2($elm$html$Html$Attributes$style, 'font-size', '20px'),
											A2($elm$html$Html$Attributes$style, 'color', 'white')
										]),
									$Orasund$elm_layout$Layout$centered),
								'W')
							])),
						A2(
						$elm$html$Html$div,
						_Utils_ap(
							_List_fromArray(
								[
									$Orasund$elm_layout$Html$Style$positionRelative,
									$Orasund$elm_layout$Html$Style$width('72px'),
									$Orasund$elm_layout$Html$Style$height('72px')
								]),
							$Orasund$elm_layout$Layout$asButton(
								{
									label: 'Undo',
									onPress: $elm$core$Maybe$Just(
										args.onInput($author$project$Input$InputUndo))
								})),
						_List_fromArray(
							[
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											A2($elm$html$Html$Attributes$style, 'color', 'white'),
											$Orasund$elm_layout$Html$Style$bottom('0px'),
											$Orasund$elm_layout$Html$Style$width('72px')
										]),
									$Orasund$elm_layout$Layout$centered),
								args.isLevelSelect ? '' : 'Undo'),
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('16px'),
											$Orasund$elm_layout$Html$Style$left('20px'),
											$Orasund$elm_layout$Html$Style$width('32px'),
											$Orasund$elm_layout$Html$Style$height('32px'),
											A2($elm$html$Html$Attributes$style, 'border', '4px solid white'),
											A2($elm$html$Html$Attributes$style, 'font-size', '20px'),
											A2($elm$html$Html$Attributes$style, 'color', 'white'),
											$Orasund$elm_layout$Html$Style$boxSizingBorderBox
										]),
									$Orasund$elm_layout$Layout$centered),
								'C')
							]))
					])),
				A2(
				$Orasund$elm_layout$Layout$row,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						A2(
							$elm$core$List$cons,
							$Orasund$elm_layout$Html$Style$positionRelative,
							$Orasund$elm_layout$Layout$asButton(
								{
									label: 'Move Left',
									onPress: $elm$core$Maybe$Just(
										args.onInput(
											$author$project$Input$InputDir($author$project$Direction$Left)))
								})),
						_List_fromArray(
							[
								$author$project$View$Controls$arrow(_List_Nil),
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('0'),
											$Orasund$elm_layout$Html$Style$right('20px'),
											$Orasund$elm_layout$Html$Style$height('72px'),
											A2($elm$html$Html$Attributes$style, 'font-size', '20px'),
											A2($elm$html$Html$Attributes$style, 'color', 'white')
										]),
									$Orasund$elm_layout$Layout$centered),
								'A')
							])),
						A2(
						$Orasund$elm_layout$Layout$el,
						_List_fromArray(
							[
								$Orasund$elm_layout$Html$Style$width('72px'),
								$Orasund$elm_layout$Html$Style$height('72px')
							]),
						$Orasund$elm_layout$Layout$none),
						A2(
						$elm$html$Html$div,
						A2(
							$elm$core$List$cons,
							$Orasund$elm_layout$Html$Style$positionRelative,
							$Orasund$elm_layout$Layout$asButton(
								{
									label: 'Move Right',
									onPress: $elm$core$Maybe$Just(
										args.onInput(
											$author$project$Input$InputDir($author$project$Direction$Right)))
								})),
						_List_fromArray(
							[
								$author$project$View$Controls$arrow(
								_List_fromArray(
									[
										A2($elm$html$Html$Attributes$style, 'transform', 'rotate(180deg)')
									])),
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('0'),
											$Orasund$elm_layout$Html$Style$left('20px'),
											$Orasund$elm_layout$Html$Style$height('72px'),
											A2($elm$html$Html$Attributes$style, 'font-size', '20px'),
											A2($elm$html$Html$Attributes$style, 'color', 'white')
										]),
									$Orasund$elm_layout$Layout$centered),
								'D')
							]))
					])),
				A2(
				$Orasund$elm_layout$Layout$row,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$div,
						A2(
							$elm$core$List$cons,
							$Orasund$elm_layout$Html$Style$positionRelative,
							$Orasund$elm_layout$Layout$asButton(
								{
									label: 'Move Down',
									onPress: $elm$core$Maybe$Just(
										args.onInput(
											$author$project$Input$InputDir($author$project$Direction$Down)))
								})),
						_List_fromArray(
							[
								$author$project$View$Controls$arrow(
								_List_fromArray(
									[
										A2($elm$html$Html$Attributes$style, 'transform', 'rotate(-90deg)')
									])),
								A2(
								$Orasund$elm_layout$Layout$text,
								_Utils_ap(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('16px'),
											$Orasund$elm_layout$Html$Style$width('72px'),
											A2($elm$html$Html$Attributes$style, 'font-size', '20px'),
											A2($elm$html$Html$Attributes$style, 'color', 'white')
										]),
									$Orasund$elm_layout$Layout$centered),
								'S')
							]))
					]))
			]));
};
var $author$project$View$World$nodeSize = ($author$project$Config$cellSize / 2) | 0;
var $author$project$Image$sprite = F2(
	function (attrs, args) {
		var _v0 = args.pos;
		var x = _v0.a;
		var y = _v0.b;
		return A2(
			$elm$html$Html$div,
			_Utils_ap(
				_List_fromArray(
					[
						A2(
						$elm$html$Html$Attributes$style,
						'width',
						$elm$core$String$fromFloat(args.width) + 'px'),
						A2(
						$elm$html$Html$Attributes$style,
						'height',
						$elm$core$String$fromFloat(args.height) + 'px'),
						A2($elm$html$Html$Attributes$style, 'background-image', 'url(' + (args.url + ') ')),
						A2(
						$elm$html$Html$Attributes$style,
						'background-position',
						$elm$core$String$fromFloat((-args.width) * x) + ('px ' + ($elm$core$String$fromFloat((-args.height) * y) + 'px'))),
						A2(
						$elm$html$Html$Attributes$style,
						'background-size',
						$elm$core$String$fromFloat(args.width * args.sheetColumns) + ('px ' + ($elm$core$String$fromFloat(args.height * args.sheetRows) + 'px'))),
						A2($elm$html$Html$Attributes$style, 'background-repeat', 'no-repeat')
					]),
				attrs),
			_List_Nil);
	});
var $author$project$View$World$image = F2(
	function (attrs, pos) {
		return A2(
			$author$project$Image$sprite,
			A2($elm$core$List$cons, $author$project$Image$pixelated, attrs),
			{height: $author$project$View$World$nodeSize, pos: pos, sheetColumns: 4, sheetRows: 4, url: 'overworld.png', width: $author$project$View$World$nodeSize});
	});
var $elm$virtual_dom$VirtualDom$keyedNode = function (tag) {
	return _VirtualDom_keyedNode(
		_VirtualDom_noScript(tag));
};
var $elm$html$Html$Keyed$node = $elm$virtual_dom$VirtualDom$keyedNode;
var $author$project$View$World$toHtml = F2(
	function (attrs, world) {
		var scale = 5;
		var _v0 = _Utils_Tuple2(((-$author$project$View$World$nodeSize) / 2) | 0, -$author$project$View$World$nodeSize);
		var offsetX = _v0.a;
		var offsetY = _v0.b;
		var _v1 = world.player;
		var centerX = _v1.a;
		var centerY = _v1.b;
		return A3(
			$elm$html$Html$Keyed$node,
			'div',
			A2($elm$core$List$cons, $Orasund$elm_layout$Html$Style$positionRelative, attrs),
			A2(
				$elm$core$List$sortBy,
				$elm$core$Tuple$first,
				A2(
					$elm$core$List$map,
					function (_v2) {
						var _v3 = _v2.a;
						var x = _v3.a;
						var y = _v3.b;
						var node = _v2.b;
						return _Utils_Tuple2(
							'node_' + ($elm$core$String$fromInt(x) + ('_' + $elm$core$String$fromInt(y))),
							A2(
								$author$project$View$World$image,
								_List_fromArray(
									[
										$Orasund$elm_layout$Html$Style$width(
										$elm$core$String$fromInt($author$project$View$World$nodeSize) + 'px'),
										$Orasund$elm_layout$Html$Style$height(
										$elm$core$String$fromInt($author$project$View$World$nodeSize) + 'px'),
										$Orasund$elm_layout$Html$Style$top(
										$elm$core$String$fromInt(((y - centerY) * $author$project$View$World$nodeSize) + offsetY) + 'px'),
										$Orasund$elm_layout$Html$Style$left(
										$elm$core$String$fromInt(((x - centerX) * $author$project$View$World$nodeSize) + offsetX) + 'px'),
										$Orasund$elm_layout$Html$Style$positionAbsolute
									]),
								function () {
									if (node.$ === 'Wall') {
										return _Utils_Tuple2(3, 0);
									} else {
										var solved = node.a.solved;
										var sort = node.a.sort;
										return _Utils_Tuple2(
											function () {
												if (solved) {
													return 0;
												} else {
													if (sort.$ === 'Trial') {
														return 2;
													} else {
														return 1;
													}
												}
											}(),
											_Utils_eq(
												world.player,
												_Utils_Tuple2(x, y)) ? 1 : 0);
									}
								}()));
					},
					A2(
						$elm$core$List$concatMap,
						function (y) {
							return A2(
								$elm$core$List$filterMap,
								function (x) {
									return A2(
										$elm$core$Maybe$map,
										$elm$core$Tuple$pair(
											_Utils_Tuple2(x, y)),
										A2(
											$elm$core$Dict$get,
											_Utils_Tuple2(x, y),
											world.nodes));
								},
								A2($elm$core$List$range, centerX - scale, centerX + scale));
						},
						A2($elm$core$List$range, centerY - scale, centerY + scale)))));
	});
var $author$project$View$Cell$fromEmojis = function (attrs) {
	return A2(
		$author$project$View$Bitmap$fromEmojis,
		attrs,
		{color: 'white', pixelSize: $author$project$Config$cellSize / 16});
};
var $author$project$View$Door$floor = function (attrs) {
	return A2(
		$author$project$View$Cell$fromEmojis,
		attrs,
		_List_fromArray(
			['⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛']));
};
var $author$project$View$Screen$viewDoorFloors = F2(
	function (prefix, game) {
		var attrs = F2(
			function (x, y) {
				return _List_fromArray(
					[
						A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
						A2(
						$elm$html$Html$Attributes$style,
						'left',
						$elm$core$String$fromFloat($author$project$Config$cellSize * x) + 'px'),
						A2(
						$elm$html$Html$Attributes$style,
						'top',
						$elm$core$String$fromFloat($author$project$Config$cellSize * y) + 'px')
					]);
			});
		return A2(
			$elm$core$List$map,
			function (_v0) {
				var x = _v0.a;
				var y = _v0.b;
				return _Utils_Tuple2(
					prefix + ('_' + ($elm$core$String$fromInt(x) + $elm$core$String$fromInt(y))),
					$author$project$View$Door$floor(
						A2(attrs, x, y)));
			},
			$elm$core$Dict$keys(game.doors));
	});
var $author$project$View$Door$bottom = function (attrs) {
	return A2(
		$author$project$View$Cell$fromEmojis,
		attrs,
		_List_fromArray(
			['⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬛⬜❌❌❌❌❌❌❌❌❌❌❌❌⬜⬛', '⬛⬛⬜⬜❌❌❌❌❌❌❌❌⬜⬜⬛⬛', '⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛', '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛']));
};
var $author$project$View$Door$top = function (attrs) {
	return A2(
		$author$project$View$Cell$fromEmojis,
		attrs,
		_List_fromArray(
			['⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜⬛⬛⬛⬛', '⬛⬛⬜⬜❌❌❌❌❌❌❌❌⬜⬜⬛⬛', '⬛⬜❌❌❌❌❌❌❌❌❌❌❌❌⬜⬛', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜', '⬜❌❌❌❌❌❌❌❌❌❌❌❌❌❌⬜']));
};
var $author$project$View$Screen$viewDoors = F2(
	function (prefix, game) {
		var attrs = F2(
			function (x, y) {
				return _List_fromArray(
					[
						A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
						A2(
						$elm$html$Html$Attributes$style,
						'left',
						$elm$core$String$fromFloat($author$project$Config$cellSize * x) + 'px'),
						A2(
						$elm$html$Html$Attributes$style,
						'top',
						$elm$core$String$fromFloat($author$project$Config$cellSize * y) + 'px')
					]);
			});
		return A2(
			$elm$core$List$map,
			function (_v0) {
				var x = _v0.a;
				var y = _v0.b;
				return _Utils_Tuple2(
					prefix + ('_' + ($elm$core$String$fromInt(x) + $elm$core$String$fromInt(y))),
					_Utils_eq(y, -1) ? $author$project$View$Door$top(
						A2(attrs, x, y)) : (_Utils_eq(x, $author$project$Config$roomSize) ? $author$project$View$Door$bottom(
						A2(
							$elm$core$List$cons,
							A2($elm$html$Html$Attributes$style, 'transform', 'rotate(-90deg)'),
							A2(attrs, x, y))) : (_Utils_eq(x, -1) ? $author$project$View$Door$bottom(
						A2(
							$elm$core$List$cons,
							A2($elm$html$Html$Attributes$style, 'transform', 'rotate(90deg)'),
							A2(attrs, x, y))) : $author$project$View$Door$bottom(
						A2(attrs, x, y)))));
			},
			$elm$core$Dict$keys(game.doors));
	});
var $author$project$View$Cell$diamant = function (attrs) {
	return A2(
		$author$project$View$Cell$fromEmojis,
		attrs,
		_List_fromArray(
			['❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌', '❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌', '❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌', '❌❌❌🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨❌❌❌', '❌❌🟨❌❌🟨❌❌❌❌🟨❌❌🟨❌❌', '❌🟨❌❌🟨❌❌❌❌❌❌🟨❌❌🟨❌', '❌🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨❌', '❌❌🟨❌❌🟨❌❌❌❌🟨❌❌🟨❌❌', '❌❌❌🟨❌❌🟨❌❌🟨❌❌🟨❌❌❌', '❌❌❌❌🟨❌🟨❌❌🟨❌🟨❌❌❌❌', '❌❌❌❌❌🟨❌🟨🟨❌🟨❌❌❌❌❌', '❌❌❌❌❌❌🟨🟨🟨🟨❌❌❌❌❌❌', '❌❌❌❌❌❌❌🟨🟨❌❌❌❌❌❌❌', '❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌', '❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌', '❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌']));
};
var $author$project$View$Cell$directional = F2(
	function (_v0, args) {
		var x = _v0.a;
		var y = _v0.b;
		var _v1 = args.direction;
		switch (_v1.$) {
			case 'Down':
				return _Utils_Tuple2(x + args.frame, y);
			case 'Up':
				return _Utils_Tuple2(x + args.frame, y + 1);
			case 'Left':
				return _Utils_Tuple2((x + 2) + args.frame, y);
			default:
				return _Utils_Tuple2((x + 2) + args.frame, y + 1);
		}
	});
var $author$project$View$Cell$fromEnemy = F2(
	function (args, enemy) {
		switch (enemy.$) {
			case 'ActivatedBomb':
				return _Utils_Tuple2(2 + args.frame, 1);
			case 'Orc':
				var dir = enemy.a;
				return A2(
					$author$project$View$Cell$directional,
					_Utils_Tuple2(4, 2),
					{direction: dir, frame: args.frame});
			case 'Goblin':
				return A2(
					$author$project$View$Cell$directional,
					_Utils_Tuple2(4, 0),
					{direction: $author$project$Direction$Down, frame: args.frame});
			case 'Doppelganger':
				return A2(
					$author$project$View$Cell$directional,
					_Utils_Tuple2(4, 2),
					{
						direction: $author$project$Direction$mirror(args.playerDirection),
						frame: args.frame
					});
			default:
				return _Utils_Tuple2(0 + args.frame, 1);
		}
	});
var $author$project$View$Cell$sprite = F2(
	function (attrs, pos) {
		return A2(
			$author$project$Image$sprite,
			A2($elm$core$List$cons, $author$project$Image$pixelated, attrs),
			{height: $author$project$Config$cellSize, pos: pos, sheetColumns: 8, sheetRows: 8, url: 'assets/tileset.png', width: $author$project$Config$cellSize});
	});
var $author$project$View$Cell$wall = function (attrs) {
	return A2(
		$author$project$View$Cell$fromEmojis,
		attrs,
		_List_fromArray(
			['⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜❌⬜⬜⬜⬜', '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜❌⬜⬜⬜⬜', '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜❌⬜⬜⬜⬜', '❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌', '⬜⬜⬜⬜❌⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜', '⬜⬜⬜⬜❌⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜', '⬜⬜⬜⬜❌⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜', '⬜⬜⬜⬜❌⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜', '⬜⬜⬜⬜❌⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜', '⬜⬜⬜⬜❌⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜', '⬜⬜⬜⬜❌⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜', '❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌', '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜❌⬜⬜⬜⬜', '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜❌⬜⬜⬜⬜', '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜❌⬜⬜⬜⬜', '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜❌⬜⬜⬜⬜']));
};
var $author$project$View$Cell$toHtml = F3(
	function (attrs, args, cell) {
		switch (cell.$) {
			case 'Player':
				return A2(
					$author$project$View$Cell$sprite,
					attrs,
					A2(
						$author$project$View$Cell$directional,
						_Utils_Tuple2(0, 4),
						{direction: args.playerDirection, frame: args.frame}));
			case 'Sign':
				return A2(
					$author$project$View$Cell$sprite,
					attrs,
					_Utils_Tuple2(3, 2));
			case 'Crate':
				return A2(
					$author$project$View$Cell$sprite,
					attrs,
					_Utils_Tuple2(1, 3));
			case 'InactiveBomb':
				return A2(
					$author$project$View$Cell$sprite,
					attrs,
					_Utils_Tuple2(1, 6));
			case 'ActiveSmallBomb':
				return A2(
					$author$project$View$Cell$sprite,
					attrs,
					A2(
						$author$project$View$Cell$fromEnemy,
						{frame: args.frame, playerDirection: args.playerDirection},
						$author$project$Entity$ActivatedBomb($author$project$Entity$Bomb)));
			case 'Enemy':
				var enemy = cell.a;
				return A2(
					$author$project$View$Cell$sprite,
					attrs,
					A2(
						$author$project$View$Cell$fromEnemy,
						{frame: args.frame, playerDirection: args.playerDirection},
						enemy));
			case 'Stunned':
				var enemy = cell.a;
				return A2(
					$author$project$View$Cell$sprite,
					attrs,
					A2(
						$author$project$View$Cell$fromEnemy,
						{frame: args.frame, playerDirection: args.playerDirection},
						enemy));
			case 'Wall':
				return $author$project$View$Cell$wall(attrs);
			default:
				return $author$project$View$Cell$diamant(attrs);
		}
	});
var $author$project$View$Screen$viewEntity = F3(
	function (prefix, args, game) {
		return A2(
			$elm$core$List$map,
			function (_v0) {
				var _v1 = _v0.a;
				var x = _v1.a;
				var y = _v1.b;
				var cell = _v0.b;
				return _Utils_Tuple2(
					prefix + ('_' + $elm$core$String$fromInt(cell.id)),
					A3(
						$author$project$View$Cell$toHtml,
						_List_fromArray(
							[
								A2($elm$html$Html$Attributes$style, 'position', 'absolute'),
								A2(
								$elm$html$Html$Attributes$style,
								'left',
								$elm$core$String$fromFloat($author$project$Config$cellSize * x) + 'px'),
								A2(
								$elm$html$Html$Attributes$style,
								'top',
								$elm$core$String$fromFloat($author$project$Config$cellSize * y) + 'px'),
								A2($elm$html$Html$Attributes$style, 'transition', 'left 0.2s,top 0.2s')
							]),
						{frame: args.frame, playerDirection: game.playerDirection},
						cell.entity));
			},
			$elm$core$Dict$toList(game.cells));
	});
var $author$project$View$Cell$border = F2(
	function (attrs, pos) {
		return A2(
			$author$project$Image$sprite,
			A2($elm$core$List$cons, $author$project$Image$pixelated, attrs),
			{height: $author$project$Config$cellSize, pos: pos, sheetColumns: 2, sheetRows: 2, url: 'assets/border.png', width: $author$project$Config$cellSize});
	});
var $author$project$View$Cell$borders = F2(
	function (_v0, game) {
		var x = _v0.a;
		var y = _v0.b;
		var attrs = _List_fromArray(
			[
				$Orasund$elm_layout$Html$Style$positionAbsolute,
				$Orasund$elm_layout$Html$Style$top('0')
			]);
		return A2(
			$elm$core$List$filterMap,
			$elm$core$Basics$identity,
			_List_fromArray(
				[
					_Utils_eq(
					A2(
						$elm$core$Dict$get,
						_Utils_Tuple2(x - 1, y),
						game.floor),
					$elm$core$Maybe$Just($author$project$Entity$Ground)) ? $elm$core$Maybe$Just(
					A2(
						$author$project$View$Cell$border,
						attrs,
						_Utils_Tuple2(0, 1))) : $elm$core$Maybe$Nothing,
					_Utils_eq(
					A2(
						$elm$core$Dict$get,
						_Utils_Tuple2(x + 1, y),
						game.floor),
					$elm$core$Maybe$Just($author$project$Entity$Ground)) ? $elm$core$Maybe$Just(
					A2(
						$author$project$View$Cell$border,
						attrs,
						_Utils_Tuple2(1, 0))) : $elm$core$Maybe$Nothing,
					_Utils_eq(
					A2(
						$elm$core$Dict$get,
						_Utils_Tuple2(x, y - 1),
						game.floor),
					$elm$core$Maybe$Just($author$project$Entity$Ground)) ? $elm$core$Maybe$Just(
					A2(
						$author$project$View$Cell$border,
						attrs,
						_Utils_Tuple2(0, 0))) : $elm$core$Maybe$Nothing,
					_Utils_eq(
					A2(
						$elm$core$Dict$get,
						_Utils_Tuple2(x, y + 1),
						game.floor),
					$elm$core$Maybe$Just($author$project$Entity$Ground)) ? $elm$core$Maybe$Just(
					A2(
						$author$project$View$Cell$border,
						attrs,
						_Utils_Tuple2(1, 1))) : $elm$core$Maybe$Nothing
				]));
	});
var $author$project$View$Cell$crateInLava = function (attrs) {
	return A2(
		$author$project$View$Cell$sprite,
		attrs,
		_Utils_Tuple2(3, 3));
};
var $author$project$View$Cell$floor = function (attrs) {
	return A2(
		$author$project$View$Cell$sprite,
		attrs,
		_Utils_Tuple2(0, 3));
};
var $author$project$View$Cell$hole = function (attrs) {
	return A2(
		$author$project$View$Cell$sprite,
		attrs,
		_Utils_Tuple2(1, 2));
};
var $author$project$View$Cell$holeTop = function (attrs) {
	return A2(
		$author$project$View$Cell$sprite,
		attrs,
		_Utils_Tuple2(0, 2));
};
var $author$project$View$Cell$item = F2(
	function (attrs, i) {
		return A2(
			$author$project$View$Cell$sprite,
			attrs,
			function () {
				if (i.$ === 'Bomb') {
					return _Utils_Tuple2(1, 6);
				} else {
					return _Utils_Tuple2(3, 6);
				}
			}());
	});
var $author$project$View$Cell$particle = F2(
	function (attrs, particleSort) {
		return A2(
			$author$project$View$Cell$sprite,
			attrs,
			function () {
				if (particleSort.$ === 'Smoke') {
					return _Utils_Tuple2(0, 0);
				} else {
					return _Utils_Tuple2(2, 3);
				}
			}());
	});
var $author$project$View$Screen$viewFloorAndItems = F2(
	function (prefix, game) {
		return A2(
			$elm$core$List$map,
			function (_v0) {
				var x = _v0.a;
				var y = _v0.b;
				return _Utils_Tuple2(
					prefix + ('_' + ($elm$core$String$fromInt(x) + ('_' + $elm$core$String$fromInt(y)))),
					A2(
						$elm$html$Html$div,
						_List_fromArray(
							[
								$Orasund$elm_layout$Html$Style$positionAbsolute,
								A2(
								$elm$html$Html$Attributes$style,
								'left',
								$elm$core$String$fromFloat($author$project$Config$cellSize * x) + 'px'),
								A2(
								$elm$html$Html$Attributes$style,
								'top',
								$elm$core$String$fromFloat($author$project$Config$cellSize * y) + 'px')
							]),
						_Utils_ap(
							_List_fromArray(
								[
									_Utils_eq(
									A2(
										$elm$core$Dict$get,
										_Utils_Tuple2(x, y),
										game.floor),
									$elm$core$Maybe$Just($author$project$Entity$Ground)) ? $author$project$View$Cell$floor(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('0')
										])) : (_Utils_eq(
									A2(
										$elm$core$Dict$get,
										_Utils_Tuple2(x, y - 1),
										game.floor),
									$elm$core$Maybe$Just($author$project$Entity$Ground)) ? $author$project$View$Cell$holeTop(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('0')
										])) : $author$project$View$Cell$hole(
									_List_fromArray(
										[
											$Orasund$elm_layout$Html$Style$positionAbsolute,
											$Orasund$elm_layout$Html$Style$top('0')
										]))),
									function () {
									var _v1 = A2(
										$elm$core$Dict$get,
										_Utils_Tuple2(x, y),
										game.floor);
									if ((_v1.$ === 'Just') && (_v1.a.$ === 'CrateInLava')) {
										var _v2 = _v1.a;
										return $author$project$View$Cell$crateInLava(
											_List_fromArray(
												[
													$Orasund$elm_layout$Html$Style$positionAbsolute,
													$Orasund$elm_layout$Html$Style$top('0')
												]));
									} else {
										return $Orasund$elm_layout$Layout$none;
									}
								}(),
									A2(
									$elm$core$Maybe$withDefault,
									$Orasund$elm_layout$Layout$none,
									A2(
										$elm$core$Maybe$map,
										function (item) {
											return A2(
												$author$project$View$Cell$item,
												_List_fromArray(
													[
														$Orasund$elm_layout$Html$Style$positionAbsolute,
														$Orasund$elm_layout$Html$Style$top('0')
													]),
												item);
										},
										A2(
											$elm$core$Dict$get,
											_Utils_Tuple2(x, y),
											game.items))),
									A2(
									$elm$core$Maybe$withDefault,
									$Orasund$elm_layout$Layout$none,
									A2(
										$elm$core$Maybe$map,
										function (particle) {
											return A2(
												$author$project$View$Cell$particle,
												_List_fromArray(
													[
														$Orasund$elm_layout$Html$Style$positionAbsolute,
														$Orasund$elm_layout$Html$Style$top('0')
													]),
												particle);
										},
										A2(
											$elm$core$Dict$get,
											_Utils_Tuple2(x, y),
											game.particles)))
								]),
							(!_Utils_eq(
								A2(
									$elm$core$Dict$get,
									_Utils_Tuple2(x, y),
									game.floor),
								$elm$core$Maybe$Just($author$project$Entity$Ground))) ? A2(
								$author$project$View$Cell$borders,
								_Utils_Tuple2(x, y),
								game) : _List_Nil)));
			},
			$author$project$Position$asGrid(
				{columns: $author$project$Config$roomSize, rows: $author$project$Config$roomSize}));
	});
var $author$project$View$Screen$world = F2(
	function (args, game) {
		return A3(
			$elm$html$Html$Keyed$node,
			'div',
			_List_fromArray(
				[
					A2($elm$html$Html$Attributes$style, 'position', 'relative'),
					A2(
					$elm$html$Html$Attributes$style,
					'width',
					$elm$core$String$fromFloat($author$project$Config$cellSize * $author$project$Config$roomSize) + 'px'),
					A2(
					$elm$html$Html$Attributes$style,
					'height',
					$elm$core$String$fromFloat($author$project$Config$cellSize * $author$project$Config$roomSize) + 'px'),
					A2($elm$html$Html$Attributes$style, 'border', '4px solid white')
				]),
			A2(
				$elm$core$List$sortBy,
				$elm$core$Tuple$first,
				_Utils_ap(
					A2($author$project$View$Screen$viewDoorFloors, '0', game),
					_Utils_ap(
						A2($author$project$View$Screen$viewFloorAndItems, '1', game),
						_Utils_ap(
							A3($author$project$View$Screen$viewEntity, '2', args, game),
							A2($author$project$View$Screen$viewDoors, '3', game))))));
	});
var $author$project$Main$view = function (model) {
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$Orasund$elm_layout$Layout$column,
				_Utils_ap(
					_List_fromArray(
						[
							A2($elm$html$Html$Attributes$style, 'width', '400px'),
							A2(
							$elm$html$Html$Attributes$style,
							'padding',
							$elm$core$String$fromInt($author$project$Config$cellSize) + 'px 0'),
							$Orasund$elm_layout$Layout$gap(16)
						]),
					$Orasund$elm_layout$Layout$centered),
				_List_fromArray(
					[
						A2(
						$Orasund$elm_layout$Layout$el,
						_Utils_ap(
							_List_fromArray(
								[
									A2($elm$html$Html$Attributes$style, 'width', '400px'),
									A2($elm$html$Html$Attributes$style, 'height', '400px')
								]),
							$Orasund$elm_layout$Layout$centered),
						function () {
							var _v0 = model.overlay;
							if (_v0.$ === 'Nothing') {
								return A2(
									$author$project$View$Screen$world,
									{frame: model.frame},
									model.game);
							} else {
								switch (_v0.a.$) {
									case 'WorldMap':
										var _v1 = _v0.a;
										return A2($author$project$View$World$toHtml, _List_Nil, model.world);
									case 'Menu':
										var _v2 = _v0.a;
										return A2(
											$author$project$View$Screen$menu,
											_List_Nil,
											{
												frame: model.frame,
												onClick: $author$project$Main$Input($author$project$Input$InputActivate)
											});
									default:
										var _v3 = _v0.a;
										return $author$project$View$Screen$gameWon;
								}
							}
						}()),
						$author$project$View$Controls$toHtml(
						{
							isLevelSelect: !_Utils_eq(model.overlay, $elm$core$Maybe$Nothing),
							item: model.game.item,
							onInput: $author$project$Main$Input
						})
					]))
			]));
};
var $author$project$Main$main = $elm$browser$Browser$element(
	{init: $author$project$Main$init, subscriptions: $author$project$Main$subscriptions, update: $author$project$Main$update, view: $author$project$Main$view});
_Platform_export({'Main':{'init':$author$project$Main$main(
	$elm$json$Json$Decode$succeed(
		{}))(0)}});}(this));