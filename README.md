# cfdump

A speedy alternative to ColdFusion's `<cfdump>` tag

## usage

```html
<cfset myVar = {
  arr = [ 1, 2 '', 'WOW!' ],
  str = 'this is definitely a string',
  num = 303,
  bool = false,
  struct = {
    structCeption = 'A struct inside a struct!'
  }
}>

<cfoutput>
    #new cfdump(myVar)#
    #new cfdump(myVar, { expand = false })#
</cfoutput>
```

## api

### `var html = cfdump(variable, [options])`

- `variable` *any* **required** An array, struct, query, or a simple value to dump
- `options` *struct* **optional**
  - `expand` *boolean* **optional** Expanded view (defaults to true)
  - `sort` *boolean* **optional** Sort the query column names (defaults to true)
- **Returns** `html` *string*

## speed

The main reason for this project is that `<cfdump>` can be ridiculously slow.
This is easily 100x faster than `<cfdump>` on mid/large queries.
I have not yet tested the time difference for arrays and structs.

I tested the time difference with a query of 52 columns and 25 rows.

| code                   | usual time range | spiked up to |
|------------------------|------------------|--------------|
| `<cfdump var="#qry#">` |2400 ms - 2900 ms | 3800 ms      |
| `#new cfdump(qry)#`    | 3 ms - 7 ms      | 40 ms        |

I haven't tested the latest version, which added some functionality, but I expect the difference is trivial.

# license

[MIT](https://choosealicense.com/licenses/mit/)
