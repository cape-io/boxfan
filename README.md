# boxfan

You send boxfan two arguments. The first argument is an array of objects or a single object. The second argument is an object with one or more of the following properties
`must, must_not, should`.

Boxfan is currently about exact matches. Use `*` as a wildcard to match anything. The asterisk feature will be supplemented with `hasFields` soon. The asterisk checks for a value where `hasFields` checks if not undefined.