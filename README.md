# jsfl - JavaScript Flattened Language

## About

This flattens JSON from something like this:

```
{
    "best_yoshi": "purple",
    "yoshi_rank": [
        "purple",
        "green",
        "blue"
    ],
    "a \"quote\" here": "but why?!\n\"quote\"",
    "best": {
        "buy": {
            "and": [
                "bust",
                "bust",
                "bust",
                "bust",
                "bust",
                "bust!"
            ]
        }
    }
}
```

With an invocation like this:

```
$ cat test.json | ./jsfl
```

To this:

```
.best.buy.and[1]: "bust"
.best.buy.and[2]: "bust"
.best.buy.and[3]: "bust"
.best.buy.and[4]: "bust"
.best.buy.and[5]: "bust"
.best.buy.and[6]: "bust!"
.best_yoshi: "purple"
.yoshi_rank[1]: "purple"
.yoshi_rank[2]: "green"
.yoshi_rank[3]: "blue"
.a \"quote\" here: "but why?!\n\"quote\""
```

## Why?

I find myself at home looking through a lot of JSON, and so I wanted a good way
to look it over, find paths I care about, so then I can construct paths more
easily.

## Copyright

### jsfl

jsfl - convert JSON to a flattened, mostly greppable language
Copyright (C) 2023  Donny Johnson

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <https://www.gnu.org/licenses/>.

See COPYING.txt for the full text of the GNU Affero Public License.

### json.lua

json.lua is available different terms of licensing, as noted in the source
code.  However, the combined work, including the amalgamation script file, is
covered under the GNU Affero General Public License.
