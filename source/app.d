import std.stdio;
import std.file;
import std.string;

void main(string[] args)
{
    if (args.length >= 2)
    {
        foreach (file; args[1..$-1])
    }

    else "usage: dew <file(s)>".writeln;
}
