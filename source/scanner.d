module scanner;
import std.conv;
import token_class;
import token_type;
import std.string;
import std.array;
import std.algorithm.searching;
import error;

class Scanner
{
    private
    {
        string source;
        Token[] tokens;

        int start = 0,
        current = 0,
        line = 0;

        immutable TokenType[string] keywords;
    }

    this(string source)
    {
        this.source = source;

        keywords =
        [
            "if":      TokenType.conditionIf,
            "elif":    TokenType.conditionElif,
            "else":    TokenType.conditionElse,
            "case":    TokenType.conditionCase,
            "when":    TokenType.conditionWhen,
            "while":   TokenType.loopWhile,
            "until":   TokenType.loopUntil,
            "for":     TokenType.loopForEach,
            "forever": TokenType.loopForEver,
            "break":   TokenType.loopBreak,
            "cont":    TokenType.loopContinue,
            "then":    TokenType.beginEndThen,
            "do":      TokenType.beginDo,
            "od":      TokenType.endDo,
            "int":     TokenType.typeInt,
            "real":    TokenType.typeReal,
            "string":  TokenType.typeString,
            "char":    TokenType.typeChar,
            "byte":    TokenType.typeByte,
            "bool":    TokenType.typeBoolean,
            "bits":    TokenType.typeBits,
            "void":    TokenType.typeVoid,
            "short":   TokenType.modifierShort,
            "long":    TokenType.modifierLong,
            "ref":     TokenType.modifierRef,
            "flex":    TokenType.modifierFlex,
            "struct":  TokenType.complexStruct,
            "union":   TokenType.complexUnion,
            "proc":    TokenType.procedure,
            "func":    TokenType.pureProcedure,
            "mode":    TokenType.mode,
            "true":    TokenType.booleanTrue,
            "false":   TokenType.booleanFalse,
        ];
    }

    auto scanTokens()
    {
        while (!isAtEnd)
        {
            start = current;
            scanToken;
        }

        tokens ~= new Token(TokenType.endOfFile, "", "", line);
        return tokens;
    }

    private
    {
        auto isAtEnd()
        {
            return current >= source.length;
        }

        void scanToken()
        {
            switch (advance)
            {
                case '(': addToken(TokenType.leftParenthesis);  break;
                case ')': addToken(TokenType.rightParenthesis); break;
                case '[': addToken(TokenType.leftBracket);      break;
                case ']': addToken(TokenType.rightBracket);     break;
                case ',': addToken(TokenType.comma);            break;

                case '+':

                    if (match('='))      addToken(TokenType.plusAssign);
                    else if (match('+')) addToken(TokenType.increment);
                    else                 addToken(TokenType.plus);

                    break;

                case '-':

                    if (match('='))      addToken(TokenType.minusAssign);
                    else if (match('-')) addToken(TokenType.decrement);
                    else if (match('>')) addToken(TokenType.returnStatement);
                    else                 addToken(TokenType.minus);

                    break;

                case '*':

                    if (match('='))      addToken(TokenType.multiplyAssign);
                    else                 addToken(TokenType.multiply);

                    break;

                case '|':

                    if (match('='))      addToken(TokenType.orAssign);
                    else if (match('|')) addToken(TokenType.logicalOr);
                    else                 addToken(TokenType.bitwiseOr);

                    break;

                case '&':

                    if (match('='))      addToken(TokenType.andAssign);
                    else if (match('&')) addToken(TokenType.logicalAnd);
                    else                 addToken(TokenType.bitwiseAnd);

                    break;

                case '=':

                    if (match('='))      addToken(TokenType.equal);
                    else                 addToken(TokenType.assign);

                    break;

                case '!':

                    if (match('='))      addToken(TokenType.notEqual);
                    else                 addToken(TokenType.not);

                    break;

                case '%':

                    if (match('='))      addToken(TokenType.moduloAssign);
                    else                 addToken(TokenType.modulo);

                    break;

                case '~':

                    if (match('='))      addToken(TokenType.concatenateAssign);
                    else                 addToken(TokenType.concatenate);

                    break;

                case '>':

                    if (match('='))      addToken(TokenType.lowerThanEqual);
                    else if (match('>')) addToken(TokenType.rightShift);
                    else                 addToken(TokenType.lowerThan);

                    break;

                case '<':

                    if (match('='))      addToken(TokenType.greaterThanEqual);
                    else if (match('<')) addToken(TokenType.leftShift);
                    else                 addToken(TokenType.greaterThan);

                    break;

                case '?':

                    if (match('='))      addToken(TokenType.castAssign);
                    else                 addToken(TokenType.castOp);

                    break;

                case '#':

                    while (peek != '\n' && !isAtEnd)
                        advance;

                    break;

                case '/':

                    if (peek == '*')
                    {
                        auto shouldKeepGoing = true;

                        while (shouldKeepGoing)
                        {
                            if (peek == '*')
                            {
                                advance;

                                if (peek == '/')
                                {
                                    advance;
                                    shouldKeepGoing = false;
                                }
                            }

                            else advance;
                        }
                    }

                    else if (match('=')) addToken(TokenType.divideAssign);
                    else addToken(TokenType.divide);

                    break;

                case ' ', '\n', '\r', '\t': break; // we're ignoring whitespace

                case '\'':

                    // char and string here

                    while (peek != '\'' && !isAtEnd)
                    {
                        if (matchPair('*', '\'')) continue;
                        if (peek == '\n') ++line;
                        advance;
                    }

                    if (isAtEnd)
                    {
                        line.reportError("Expected \'");
                        break;
                    }

                    advance;

                    auto value = source[start + 1..current - 1];
                    
                    // temporary to prevent the algorithm to confuse 
                    // **n into *n for example
                    value = value.replace("**", "\x01");
                    
                    value = value.replace("*0", "\0");
                    value = value.replace("*n", "\n");
                    value = value.replace("*r", "\r");
                    value = value.replace("*t", "\t");
                    value = value.replace("*'", "\'");
                    value = value.replace("*a", "\a");
                    value = value.replace("*b", "\b");
                    value = value.replace("*f", "\f");
                    value = value.replace("*v", "\v");
                    
                    value = value.replace("\x01", "*");

                    if (value.length == 1)
                        addToken(TokenType.charLiteral, value[0].to!string);

                    else
                        addToken(TokenType.stringLiteral, value);

                    break;

                case '0': .. case '9': goto case;
                case '.':

                    char peekValue;

                    while(((peekValue = peek) >= '0' && peekValue <= '9') || peekValue == '.')
                        advance;

                    auto result = source[start..current];

                    // this is purposefully made so that . == 0
                    if (result.startsWith(".")) result = "0" ~ result;
                    if (result.endsWith(".")) result ~= "0";

                    auto dotCount = result.count(".");

                    if (dotCount == 1)
                        addToken(TokenType.decimalLiteral, result);

                    else if (dotCount > 1)
                        line.reportError("Too many dots in decimal number: %s".format(result));

                    else
                        addToken(TokenType.integerLiteral, source[start..current]);

                    break;

                case 'A': .. case 'Z': goto case;
                case 'a': .. case 'z': goto case;
                case '_':

                    char peekValue;

                    while
                    (
                        (peekValue = peek) == '_' ||
                        (peekValue >= '0' && peekValue <= '9') ||
                        (peekValue >= 'A' && peekValue <= 'Z') ||
                        (peekValue >= 'a' && peekValue <= 'z')
                    )
                    advance;

                    if (source[start..current] in keywords)
                        addToken(keywords[source[start..current]]);

                    else
                        addToken(TokenType.identifier, source[start..current]);

                    break;

                default:
                
                    char err = source[current - 1];
                    line.reportError("Unexpected character %x %c".format(err, err));
                    break;
            }
        }

        auto advance()
        {
            return source[current++];
        }

        void addToken(TokenType type, string litteral = "")
        {
            auto text = source[start..current];
            tokens ~= new Token(type, text, litteral, line);
        }

        auto match(char expected)
        {
            if (isAtEnd) return false;
            if (source[current] != expected) return false;

            ++current;
            return true;
        }

        auto matchPair(char expectedA, char expectedB)
        {
            if (peek == expectedA && peekNext == expectedB)
            {
                current += 2;
                return true;
            }

            return false;
        }

        auto peek()
        {
            if (isAtEnd) return '\0';
            return source[current];
        }

        auto peekNext()
        {
            if (current + 1 >= source.length) return '\0';
            return source[current + 1];
        }
    }
}
