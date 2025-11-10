# Datomic REST API - how to use Datomic from Python (or PHP, or Ruby, or Go)

Believe it or not I have to write this up for myself, for future reference.

Biggest complaint about Clojure is its DX(developer experience)/ecosystem, basically a lack of work towards making things noob friendly.

I won't go into that matter itself but an unfortunate fact is - the same applies to Datomic.

## What is Datomic?

Datomic is a database system, it stores a record of immutable facts.

So you say Alice and Bob are people and Alice works some job  in some company in some city and at that job she sells something to various buyers and wouldn't you know it one of the companies in some other city is a company which Bob works in and he's the one handling procurement.

Thanks to Datomic and its variations/siblings you have a way to write a program which you can use to ask questions such as

- how many units of X has Bob bought from Alice's company?
- what are the most common products that Bob buys?
- what are the most common products that Alice sells?
- what are the most common products, per company, per city, that Alice sells?

If you had facts about shipping routes as well you could do all kinds of crazy optimizations and whatnot. But I won't bore you with these, you get the picture.

Of course you could accomplish the same with any other data store (things like Neo4j are best suited for graphs, even SQL can be of use) but if you're reading this blog post you're probably the type of person to understand how much of a pain it would be to programatically obtain such information with SQL.

## How Datomic works in the wild

Datomic works best when used in Clojure, of course, you'd add it as a project dependency and you've got a ready-to-use client. You can connect it to their Datomic Cloud or you can run your own transactor against your own database.

Then you write Clojure code to manage the schema (not akin to SQL table schema, more like type definitions for various types of data you're working with (a :user/username is :db.type/string and so on)) and you write Clojure code to write/read the data.

That's it, effectively.

Internally Datomic is backend agnostic and exposes the same interface no matter if it's pointed at a Postgres database, an in-memory JDBC datastore (for development), or other SQL  /NoSQL datastores.

More info [here](https://docs.datomic.com/operation/storage.html)

## How Datomic (can) work with programming languages other than Clojure

Datomic ships with a REST API. This means you can use it for  basically everything you'd want to use it for with Clojure, but with Python for example.

You can [download Datomic from here](https://docs.datomic.com/setup/pro-setup.html#get-datomic) and start its REST server like so (example uses Postgres):

```
./bin/rest -p $SOME_PORT $DATOMIC_DB 'datomic:sql://$DATOMIC_DB?jdbc:postgresql://$PG_HOST:$PG_PORT/$PG_DB?user=$PG_USR&password=$PG_PWD'
```

where - obviously - the environment variables are substituted with appropriate data. Two caveates with this info:

1. Not yet sure if there's a way to avoid passing credentials in the connection query string
2. Will double check but I might've mistaken the places where `$DATOMIC_DB` and `$PG_DB` go (I gave them both the same name but they're two different things -_-), if it doesn't work for you and I haven't double checked it yet try switching them around until the connection gets properly established

It might seem odd at first and it was a major hurdle for me: the REST program will start succesfully and you can talk to it however you will keep getting errors.

It won't be immediately obvious (and yes the [download page](https://docs.datomic.com/setup/pro-setup.html#run-a-transactor) has got a section mentioning it right below the download link) but you need to start the transactor as well.

Think of the transactor as of a centralized Datomic gate, IIRC it's basically a chokepoint in order to guarantee ACID compliance.

Run the transactor via

```
./bin/transactor config/samples/sql-transactor-template.properties
```

I think the sample originally targets the in-memory store, copy the dot-properties file somewhere and edit (comment out?) the lines pointing to the protocol, host, port, sql-url, sql-user, sql-password.

## More errors

<iframe src="https://microads.ftp.sh/api/ads/delivery-node/random?nonce=abc123"></iframe>

After configuring and starting these services you will ... face more errors :) because Datomic doesn't autoconfigure the storage, it's up to you to do it.

For Postgres there's a dot-sql script file in `./bin/sql/postgres-table.sql` which you can run directly against your Postgres instance. It will create a `datomic_kvs` table which Datomic operates in.

After doing this you will finally be able to write facts to your Datomic datastore via Datomic HTTP REST API... but only about the Database itself (writing :db/doc facts).

> Sidenote, check out https://pypi.org/project/edn-format/ for json<->edn conversion with Python

## Even more errors

So Datomic won't let you persist facts/datums without declaring your fact schemas? What's a programmer to do?

At this point we go into options & opinions territory but I'd concluded that for my project's needs, [conformity](https://github.com/qtrfeast/conformity) is more than enough.

I'd set up an initializer type of microservice (in Clojure) which my main Python program depends on, and the idea is that on every start/restart the sidecar will start and transform the schema to the desired structure.

---

This effectively concludes the little crash course. I've gotten to this point and haven't (so far) discovered any additional obstacles to using Datomic from Python/etc.

[[Next: immortal software manifesto](immortal-software-manifesto.html)]