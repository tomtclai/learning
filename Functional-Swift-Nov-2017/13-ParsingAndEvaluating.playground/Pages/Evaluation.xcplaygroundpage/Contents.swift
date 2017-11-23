/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Evaluation

*/

// --- (Hidden code block) ---
indirect enum Expression {
    case int(Int)
    case reference(String, Int)
    case infix(Expression, String, Expression)
    case function(String, Expression)
}
// ---------------------------
/*:
In the evaluation step, we want to transform an `Expression` tree into an actual
result. To start with, we define a `Result` type:

*/

enum Result {
    case int(Int)
    case list([Result])
    case error(String)
}

/*:
The `Result` type has three different cases:

  - `int` is used for expressions that evaluate to an integer, like `"2*3"` or
    `"SUM(A1:A3)"` (assuming we have valid values in cells A1 to A3).

  - `list` is for expressions that evaluate to multiple results. In our example,
    this only occurs with expressions like `"A1:A3"` that are used as arguments
    for functions like `"SUM"` and `"MIN"`.

  - `error` indicates that something went wrong during evaluation, with a more
    detailed description stored in the associated value.

To evaluate an `Expression` value, we add an `evaluate` method in an extension:

``` swift-example
extension Expression {
    func evaluate(context: [Expression?]) -> Result {
        switch (self) {
        // ...
        default:
            return .error("Couldn't evaluate expression \(self)")
        }
    }
}
```

The `context` parameter is an array of all the other expressions in the
spreadsheet column in order to be able to resolve references like `A2`. For
simplicity's sake, we're limiting the spreadsheet to work only with one column
so that we can represent the other expressions as a simple array.

Now we just have to go over the different cases of `Expression` and return the
corresponding `Result` value. Here's the complete code of the `evaluate` method,
which we'll discuss below step by step:

*/

extension Expression {
    func evaluate(context: [Expression?]) -> Result {
        switch (self) {
        case let .int(x):
            return .int(x)
        case let .reference("A", row):
            return context[row]?.evaluate(context: context)
                ?? .error("Invalid reference \(self)")
        case .function:
            return self.evaluateFunction(context: context)
                ?? .error("Invalid function call \(self)")
        case let .infix(l, op, r):
            return self.evaluateArithmetic(context: context)
                ?? self.evaluateList(context: context)
                ?? .error("Invalid operator \(op) for operands \(l, r)")
        default:
            return .error("Couldn't evaluate expression \(self)")
        }
    }
}

/*:
The first case, `.int`, is very simple. The associated value of an `.int`
expression is already an integer, so we can simply extract that and return an
`.int` result value.

The second case, `.reference`, is a bit more complicated. We only match on
references with the column `"A"` since our spreadsheet is limited to one column
(as mentioned above), and bind the second associated value to the variable
`row`. This is the row index of the referenced cell. We look up the expression
for this cell using the `context` parameter and recursively call `evaluate` on
the expression. In case it doesn't exist, we return an `.error` result value.

The third case, `.function`, just forwards the evaluation task to another method
on `Expression` called `evaluateFunction`. We could've inlined this code as
well, but to avoid overly long methods, we decided to pull it out, especially
considering the book format. `evaluateFunction` looks like this:

*/

extension Expression {
    func evaluateFunction(context: [Expression?]) -> Result? {
        guard
            case let .function(name, parameter) = self,
            case let .list(list) = parameter.evaluate(context: context)
            else { return nil }
        switch name {
        case "SUM":
            return list.reduce(.int(0), lift(+))
        case "MIN":
            return list.reduce(.int(Int.max), lift { min($0, $1) })
        default:
            return .error("Unknown function \(name)")
        }
    }
}

/*:
The guard statement first checks if this method actually got called on a
`.function` value, along with whether the function's parameter expression
evaluates to a `.list` result. If either of these conditions doesn't hold, we
immediately return `nil`.

The remaining switch statement is straightforward: we implement one case per
function name and calculate the result from the list of parameter values using
`reduce`.

An important detail to mention is that `list` is an array of `Result` values.
Therefore, we can't just use standard arithmetic operators like `"+"` or
functions like `min`. In order to make this work, we define a function, `lift`,
that takes any function of type `(Int, Int) -> Int` and turns it into a function
of type `(Result, Result) -> Result`:

*/

func lift(_ op: @escaping (Int, Int) -> Int) -> ((Result, Result) -> Result) {
    return { lhs, rhs in
        guard case let (.int(x), .int(y)) = (lhs, rhs) else {
            return .error("Invalid operands \(lhs, rhs) for integer operator")
        }
        return .int(op(x, y))
    }
}

/*:
Here, we first have to make sure that we're actually dealing with two
`Result.int` values — otherwise, we return an `.error` result. Once we've
extracted the two integers, we use the passed-in operator function to calculate
the result and wrap it in a `Result.int` value.

The last case in our `evaluate` method is the `.infix` case. Like in the
`.function` case, for the sake of readability we've extracted the code for
evaluating `.infix` expressions into two separate extensions on `Expression`.
The first one is `evaluateArithmetic`. This method tries to evaluate the
`.infix` expression as arithmetic expression and returns `nil` if it fails:

*/

extension Expression {
    func evaluateArithmetic(context: [Expression?]) -> Result? {
        guard case let .infix(l, op, r) = self else { return nil }
        let x = l.evaluate(context: context)
        let y = r.evaluate(context: context)
        switch (op) {
        case "+": return lift(+)(x, y)
        case "-": return lift(-)(x, y)
        case "*": return lift(*)(x, y)
        case "/": return lift(/)(x, y)
        default: return nil
        }
    }
}

/*:
Since this method could be called on any kind of `Expression`, we first check
whether we're really dealing with an `.infix` expression. We use the same guard
statement to immediately extract the associated values: the left-hand operand,
the operator, and the right-hand operand.

Then we call `evaluate` on the left-hand and right-hand side operands, and we
switch over the operator to calculate the result. Here we again use the `lift`
function to be able to, for example, add two `Result` values. Note that we don't
have to explicitly deal with the case that `x` or `y` might not be integer
results – `lift` already takes care of that for us.

The second method on `Expression` to evaluate `.infix` expressions takes care of
the list operator, e.g. `"A1:A3"`:

*/

extension Expression {
    func evaluateList(context: [Expression?]) -> Result? {
        guard
            case let .infix(l, op, r) = self,
            op == ":",
            case let .reference("A", row1) = l,
            case let .reference("A", row2) = r
            else { return nil }
        return .list((row1...row2).map
            { Expression.reference("A", $0).evaluate(context: context) })
    }
}

/*:
Again, we first check whether `evaluateList` is applicable to the `Expression`
value its called on. Within the guard statement, we check whether we're
operating on an `.infix` expression, whether the operator matches `":"`, and
whether both operands are `.reference` expressions referring to a cell within
the `"A"` column. If any of those conditions aren't met, we just return `nil`.

If those checks succeed, we return a `.list` result by mapping over the indices
from `row1` up to and including `row2` and by evaluating the result for each of
those cells.

That's all we need for `evaluate` on `Expression`. Since we always want to
evaluate a cell in the context of the other cells (we need to be able to resolve
references), we add another convenience function to evaluate an array of
expressions:

*/

func evaluate(expressions: [Expression?]) -> [Result] {
    return expressions.map { $0?.evaluate(context: expressions) ??
        .error("Invalid expression \($0)") }
}

/*:
Now we can define an array of sample expressions and try to evaluate them:

*/

let expressions: [Expression] = [
    // (1+2)*3
    .infix(.infix(.int(1), "+", .int(2)), "*", .int(3)),
    // A0*3
    .infix(.reference("A", 0), "*", .int(3)),
    // SUM(A0:A1)
    .function("SUM", .infix(.reference("A", 0), ":", .reference("A", 1)))
]

evaluate(expressions: expressions)

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
