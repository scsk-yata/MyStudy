import std.stdio;

void fizzbuzz(int num)
{
    //   -- (*1)  
    foreach(e; 1 .. num + 1)
    {
        if (e % 15 == 0)
        {
            writeln("FizzBuzz");
        }else if (e % 3 == 0)
        {
            writeln("Fizz");
        }else if (e % 5 == 0)
        {
            writeln("Buzz");
        }else{
            writeln(e);
        }
    }
}

// -- (*2)
void main()
{
    fizzbuzz(100);
}
