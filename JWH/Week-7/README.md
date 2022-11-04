# Week 7 Decode Ways

This is the solution to Medium problem [Decode Ways](https://leetcode.com/problems/decode-ways/).

The driver function is `totalCombos`, which calls `allCombos` to iterate over the string, character by character, updating the number of legal combos for each additional character.  The function that does the counting is `countCombos`.  `allCombos` seeds it with starter input `('0', 0, 1)`.

## countCombos

`countCombos`, given a previously-seen character, a breakdown of types of combinations built up to that point, and a current character, `countCombos` determines how many combinations of each type would result by adding the current character.

It assumes that there are two types of combined string - one that ends in a "detached" character and one that ends in an "attached" character.

For example, if you've seen '1' and '2' so far, you would have one of each type, since the two possible way to combine those two are '12' and '1 2':

1. '12' - "attached" ('1' and '2' are combined into a single code point)
1. '1 2' - "detached" ('1' and '2' represent separate code points)

This difference matters because in the first case there is only one way to add the new character (let's say it's '3' for an example) since code points must be less than 26 and thus can never be represented by more than two characters:

1. '12 3'

In the second, there are two ways:

1. '1 2 3'
1. '1 23'

Therefore, `countCombos` keeps track, at each iteration, of how many "attached" and "detached" combinations of the string we've seen so far exist.

If the character seen previously is '0' or greater than '2', it is only possible to return a list of "detached" patterns.  Also, adding a "detached" number on the end doesn't increase the total number of patterns seen, so you simply sum the number of "detached" and "attached" patterns to get the number of "detached" patterns seen so far and return 0 as the number of "attached" patterns.  This strategy also works when the previous character is '2' and the current one is greater than '6'.

### Example

If we've seen '1' and '3' and the new number is '2', the patterns up to this point are:

1. '1 3'
1. '13'

...which is 1 "attached" and 1 "detached".

The only thing that can be done here is to add '2' to each (since 32 is not a valid code point), so you get:

1. '1 3 2'
1. '13 2'

... which is just 2 "detached" and 0 "attached"

**Otherwise** - in cases where it's possible to "attach" the current character to any "detached" patterns, you end up with a number equal to all the previously-seen attached patterns added to *twice* the number of previously-seen detached patterns.

### Example

Extending the previous example, if the next character is again '2', it's possible to attach it to all of the detached patterns (which is all of them), so we end up with four patterns:

1. '1 3 2 2'
1. '1 3 22'
1. '13 2 2'
1. '13 22'

Which is indeed twice the number of previously-seen "detached" patterns (2) plus the number of previously-seen "attached" patterns (0) - so 0 + 2\*2 = 4, or 2 attached and 2 detached patterns.

Once `allCombos` reaches the end of the list it returns its current state (i.e. the result of the final call to `countCombos`), which is a triple representing the last character in the list, the number of attached patterns seen at that point, and the number of detached patterns.  In the previous example it would be `('2', 2, 2)`.  `totalCombos` then simply sums the attached and detached and returns 4.
