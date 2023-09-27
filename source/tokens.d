module dew.tokens;

class Idiot
{
  static immutable
  {
    auto keyWordMap =
    [
        "and"     : "&&",
        "or"      : "||",
        "eor"     : "fn leor(%s, %s)",
        "nand"    : "fn lnand(%s, %s)",
        "nor"     : "fn lnor(%s, %s)",
        "eand"    : "fn leand(%s, %s)",
        "is"      : "fn lis(%s, %s)",
        "isnt"    : "fn !lis(%s, %s)",
        "do"      : "{",
        "od"      : "}",
        "then"    : "ex { %s; }",
        "as"      : "{",
        "sa"      : "}",
        "such"    : "ex { %s; }",
        "proc"    : "",
        "func"    : "",
        "actn"    : "",
        "meth"    : "",
        "real"    : "float",
        "inf"     : "auto",
        "ints"    : "int[]",
        "reals"   : "float[]",
        "strings" : "string[]",
        "flex"    : "",
        "un"      : "cf if (!(%s))",
        "elif"    : "else if",
        "elun"    : "cf else if (!(%s))",
        "until"   : "cf while (!(%s))",
        "next"    : "continue",
        "this"    : "",
        "sub"     : "",
        "record"  : "struct"
    ];

    auto operatorMap =
    [
        "||" : "^",
        "!|" : "bnor(%s, %s)",
        "!&" : "bnand(%s, %s)",
        "&&" : "beand(%s, %s)",
        "~~" : "repeat(%s, %s)",
        "!~" : "remove(%s, %s)",
        ":=" : "=",
        "!!" : "[0..$-2]",
        "@"  : "%s.length",
        "="  : "==",
        "<>" : "!=",
        "#"  : "//",
        "><" : "return",
        "->" : "return",
        "?"  : "ex cast(%s)(%s)"
    ];
  }
}
