module token_class;
import token_type;
import std.string;

class Token
{
    private
    {
        TokenType _type;
        string _lexeme;
        string _literal;
        int _line;
    }

    this(TokenType type, string lexeme, string literal, int line)
    {
        _type = type;
        _line = line;
        _lexeme = lexeme;
        _literal = literal;
    }

    auto type()
    {
        return _type;
    }

    auto lexeme()
    {
        return _lexeme;
    }

    auto literal()
    {
        return _literal;
    }

    int line()
    {
        return _line;
    }

    override string toString()
    {
        return "%s %s %s".format(type, lexeme, literal);
    }
}
