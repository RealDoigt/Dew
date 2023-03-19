module token_type;

enum TokenType
{
    // single-character tokens
    leftParenthesis,  // (
    rightParenthesis, // )
    leftBracket,      // [
    rightBracket,     // ]
    comma,            // ,
    plus,             // +
    minus,            // -
    divide,           // /
    multiply,         // *
    bitwiseOr,        // |
    bitwiseAnd,       // &
    not,              // !
    lowerThan,        // <
    greaterThan,      // >
    assign,           // =
    modulo,           // %
    castOp,           // ?
    concatenate,      // ~

    // dual-character tokens
    leftShift,         // <<
    rightShift,        // >>
    plusAssign,        // +=
    minusAssign,       // -=
    multiplyAssign,    // *=
    divideAssign,      // /=
    orAssign,          // |=
    andAssign,         // &=
    moduloAssign,      // %=
    concatenateAssign, // ~=
    castAssign,        // ?=
    equal,             // ==
    notEqual,          // !=
    lowerThanEqual,    // <=
    greaterThanEqual,  // >=
    logicalOr,         // ||
    logicalAnd,        // &&
    returnStatement,   // ->
    increment,         // ++
    decrement,         // --

    // literals
    identifier,
    decimalNumber,
    integerNumber,
    
    // keywords
    conditionIf,   // if
    conditionElif, // elif
    conditionElse, // else
    conditionCase, // case
    conditionWhen, // when
    loopWhile,     // while
    loopUntil,     // until
    loopForEach,   // for
    beginEndThen,  // then
    beginDo,       // do
    endDo,         // od     no modifier      short            long
    typeInt,       // int    32 bits integer  16 bits integer  64 bits integer
    typeReal,      // real   32 bits single   16 bits half     64 bits double
    typeString,    // string default string   ascii string     utf8 string
    typeChar,      // char   default char     ascii char       utf8 char / DCII char in retro systems
    typeByte,      // byte   unsigned 8 bits integer
    typeBoolean,   // bool   boolean
    typeBits,      // bits   bitmask
    typeVoid,      // void
    modifierShort, // short
    modifierLong,  // long
    modifierRef,   // ref
    modifierFlex,  // flex
    complexStruct, // struct
    complexUnion,  // union
    procedure,     // proc
    pureProcedure, // func
    mode,          // mode
    booleanTrue,   // true
    booleanFalse,  // false

    // others
    endOfFile
}
