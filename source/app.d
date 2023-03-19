import token_type;
import std.stdio;
import std.file;
import scanner;
import std.string;

void run (string source)
{
    auto scanner = new Scanner(source);
    auto tokens = scanner.scanTokens;

    foreach (token; tokens)
        token.toString.writeln;
}

void runFile(string path)
{
    scope (failure)
        "the system encountered a problem with the file".writeln;

    path.readText.run;
}

void main(string[] args)
{
    if (args.length == 2) args[1].runFile;
    else "usage: dew <file(s)>".writeln;
}
