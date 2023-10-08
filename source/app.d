import std.stdio;
import std.file;
import std.string;
import std.array;

void main(string[] args)
{
    string[string] dSourceFiles, dewSourceFiles;

    if (args.length >= 2)
    {
        foreach (file; args[1..$-1])
        {
            if (file.exists)
            {
                if (file.endsWith(".d")) dSourceFiles[file] = file.readText;
                else if (file.endsWith(".dew")) dewSourceFiles[file] = file.readText;
                else "Unrecognised file type of %d. Use only D and Dew source files.".writefln(file);
            }
        }
    }

    else "usage: dew <file(s)>".writeln;
}
