import token_class;
import std.stdio;
import std.file;
import scanner;
import std.string;

auto tokenize (string source)
{
    auto scanner = new Scanner(source);
    return scanner.scanTokens;
}

auto tokenizeFile(string path)
{
    scope (failure)
        "the system encountered a problem with the file".writeln;

    return path.readText.tokenize;
}

void main(string[] args)
{
    if (args.length >= 2)
    {
        Token[] tokens;
        
        for (size_t i = 1; i < args.length; ++i) 
            tokens ~= args[i].tokenizeFile;
            
        foreach (t; tokens)
            t.writeln;
    }
    
    else "usage: dew <file(s)>".writeln;
}
