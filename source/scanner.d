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
            "ref":    TokenType.reference,
            "static": TokenType.notGlobal,
            "cst":    TokenType.constant,
            "use":    TokenType.use,
            "int":    TokenType.integer,
            "unt":    TokenType.unsigned,
            "flt":    TokenType.decimal,
            "bin":    TokenType.boolean,
            "var":    TokenType.variant,
            "arr":    TokenType.variantArray,
            "map":    TokenType.variantDict,
            "fun":    TokenType.variantFunct,
            "str":    TokenType.stringType,
            "chr":    TokenType.characterType,
            "big":    TokenType.bigModifier,
            "smol":   TokenType.smolModifier,
            "if":     TokenType.ifCond,
            "elif":   TokenType.elseIf,
            "un":     TokenType.unless,
            "elun":   TokenType.elseUnless,
            "else":   TokenType.elseCond,
            "switch": TokenType.switchCond,
            "til":    TokenType.until,
            "loop":   TokenType.forever,
            "each":   TokenType.forEach,
            "for":    TokenType.forLoop,
            "while":  TokenType.whileLoop,
            "case":   TokenType.caseCond,
            "brk":    TokenType.brick,
            "true":   TokenType.tru,
            "false":  TokenType.notTru,
            "in":     TokenType.read,
            "out":    TokenType.print,
            "pop":    TokenType.popup,
            "gui":    TokenType.graphical,
            "cgi":    TokenType.webServer,
            "term":   TokenType.terminal,
            "is":     TokenType.isType,
            "err":    TokenType.error,
            "void":   TokenType.voidType,
            "pop":    TokenType.removeElement,
            "cd":     TokenType.changeDirectory,
            "ls":     TokenType.list,
            "man":    TokenType.manual,
            "mv":     TokenType.move,
            "rm":     TokenType.remove,
            "cp":     TokenType.copy,
            "mcd":    TokenType.makeChangeDirectory,
            "mk":     TokenType.createFile,
            "mkd":    TokenType.createDirectory,
            "cho":    TokenType.changeOwner,
            "chg":    TokenType.changeGroup,
            "chm":    TokenType.changeRights,
            "ed":     TokenType.edit,
            "cat":    TokenType.cat,
            "sat":    TokenType.searchCat,
            "wd":     TokenType.currentDirectory,
            "ifc":    TokenType.netInterface,
            "net":    TokenType.netStat,
            "nsl":    TokenType.lookup,
            "upt":    TokenType.uptime,
            "bro":    TokenType.broadcast,
            "mes":    TokenType.canUseWrite,
            "rn":     TokenType.rename,
            "cpu":    TokenType.cpuProcesses,
            "wu":     TokenType.whoUptime,
            "hd":     TokenType.head,
            "tl":     TokenType.tail,
            "srt":    TokenType.sort,
            "cc":     TokenType.charCount,
            "wc":     TokenType.wordCount,
            "df":     TokenType.diskSpace,
            "du":     TokenType.diskUsage,
            "lct":    TokenType.locate
        ];
    }

    Token[] scanTokens()
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
        bool isAtEnd()
        {
            return current >= source.length;
        }

        void scanToken()
        {
            switch (advance)
            {
                case '(': addToken(TokenType.leftParenthesis);  break;
                case ')': addToken(TokenType.rightParenthesis); break;
                case '{': addToken(TokenType.leftBrace);        break;
                case '}': addToken(TokenType.rightBrace);       break;
                case '[': addToken(TokenType.leftBracket);      break;
                case ']': addToken(TokenType.rightBracket);     break;
                case ';': addToken(TokenType.semiColon);        break;
                case ',': addToken(TokenType.comma);            break;

                case '+':

                    if (match('='))      addToken(TokenType.plusAssign);
                    else if (match('+')) addToken(TokenType.increment);
                    else                 addToken(TokenType.plus);

                    break;

                case '-':

                    if (match('='))      addToken(TokenType.minusAssign);
                    else if (match('+')) addToken(TokenType.decrement);
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
                    else if(match('>'))  addToken(TokenType.returnStatement);
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

                    if (match('=')) addToken(TokenType.lowerThanEqual);

                    else if (matchPair('>', '='))
                        addToken(TokenType.assignRightShift);

                    else if (match('>')) addToken(TokenType.rightShift);
                    else addToken(TokenType.lowerThan);

                    break;

                case '<':

                    if (match('=')) addToken(TokenType.greaterThanEqual);

                    else if (matchPair('<', '='))
                        addToken(TokenType.assignLeftShift);

                    else if (match('<')) addToken(TokenType.leftShift);
                    else if (match('>')) addToken(TokenType.streamfrom);
                    else addToken(TokenType.greaterThan);

                    break;

                case '?':

                    if (match('=')) addToken(TokenType.castEqual);
                    else if (match('!')) addToken(TokenType.castType);
                    else if (match('+')) addToken(TokenType.castPlus);
                    else if (match('-')) addToken(TokenType.castMinus);
                    else if (match('/')) addToken(TokenType.castDivide);
                    else if (match('*')) addToken(TokenType.castMultiply);
                    else if (match('|')) addToken(TokenType.castOr);
                    else if (match('&')) addToken(TokenType.castAnd);
                    else if (match('%')) addToken(TokenType.castModulo);
                    else if (match('~')) addToken(TokenType.castConcatenate);
                    else if (matchPair('<', '<')) addToken(TokenType.castLeftShift);
                    else if (matchPair('>', '>')) addToken(TokenType.castRightShift);
                    else addToken(TokenType.ternary);

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
                        if (matchPair("\\", "'")) continue;
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

                    value = value.replace("\\0", "\0");
                    value = value.replace("\\n", "\n");
                    value = value.replace("\\r", "\r");
                    value = value.replace("\\t", "\t");
                    value = value.replace("\\'", "\'");
                    value = value.replace("\\\\", "\\");

                    if (value.length == 1)
                        addToken(TokenType.characterType, value[0].to!string);

                    else
                        addToken(TokenType.stringType, value);

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

                    // numbers aren't immediately converted; that comes later
                    // when we know their type.

                    auto dotCount = result.count(".");

                    if (dotCount == 1)
                        addToken(TokenType.decimalNumber, result);

                    else if (dotCount > 1)
                        line.reportError("Too many dots in decimal number: %s".format(result));

                    else
                        addToken(TokenType.integerNumber, source[start..current]);

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
                    line.reportError("Unexpected character %x".format(source[current - 1]));
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
