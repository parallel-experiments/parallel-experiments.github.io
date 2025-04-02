# Unknown tool: tools

Commonly presents as an error during an attempt to add Sean Corfield's "new" like so

```
clojure -Ttools install com.github.seancorfield/clj-new '{:git/tag "v1.2.381"}' :as new
```

and the error 

```Error building classpath. Unknown tool: tools```

### Solution

<iframe src="https://microads.ix.tc/api/ads/delivery-node/direct?nonce=abc123	"></iframe>

(https://clojurians-log.clojureverse.org/clj-on-windows/2022-09-01) is to create `~/.clojure/tools/tools.edn` and add in

```
{:lib io.github.clojure/tools.tools
 :coord {:git/tag "v0.2.8"
         :git/sha "9c5baa56cff02de98737a71d4dab098b268cd68b"}}

```
or newer before re-running.
