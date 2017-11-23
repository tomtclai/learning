/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## User Interface

![The user interface of our simple spreadsheet
application](artwork/spreadsheet-gui.png)

The user interface around the paring and evaluation code we've built above is
standard Cocoa code. Therefore, we're not going to show this part in the book.
However, if you're interested in the details, please take a look at the sample
project on [GitHub](__github__).

Of course this app has many limitations, and the code could be much more
efficient in many places. For example, we wouldn't have to parse and evaluate
all cells just because the user has changed one. Also, if 10 cells contain a
reference to the same cell, we evaluate this cell 10 times.

Nevertheless, it's a small working example that demonstrates that it's easy to
integrate parts of code written in a functional style with traditional
object-oriented Cocoa code.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
