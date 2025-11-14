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

## Some errors

You are likely to face an `unsupported protocol: sql` error at this point, and its cause would be that Clojure (read Java) underneath Datomic doesn't know what Postgres is nor that it's a SQL database.

To teach your Datomic installation (read Java) about Postgres you will have to `cd $WHEREVER_YOU_EXTRACT_AKA_INSTALL_DATOMIC` then `mvn install` (more info [here](https://www.marcobehler.com/guides/mvn-clean-install-a-short-guide-to-maven))

It might just so happen your `mvn install` run fails as well, something about PGP and keys and whatnot:

## Some more errors

If at this point you're facing a GPG key error of some kind it would mean you also have to tell your Datomic (read Java) installation about an identity.

> Sidenote: This (I think) is part of the proprietary DNA that got carried over to the free version of Datomic where you sign your subscription with your secure keypair in order to be able to completely install Datomic.

PGP and GPG are a rabbit hole on their own but the basic idea is you can install GPG [more info](https://en.wikipedia.org/wiki/Pretty_Good_Privacy) and run its key generator to create yourself a keypair and maven will then use your public keys to (I think) sign the installation of Datomic's core dependencies.

## No more errors, or ...?

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

## On conformity - when do the errors stop?

Since this is an article inteded for prople who are generally not used to the impenetrable Clojure ecosystem and adopting a schema in order to do transactions is actually necessary, we will proceed into Clojure-only territory - that is - managing the Datomic schema with Conformity.

In the project's README you will find an example of how it is supposed to be used and while last commit was in 2020. it's still valid, Clojure ecosystem is as stable as it is impenetrable (case in point: while researching this section I'd noticed that clojure.org has literally 0 mentions of either the word "install" or "download").
It does not, however, explain how exactly are we supposed to run it against a system running on Postgres - the examples are all about the in-memory Datomic store.

To run conformity in a Clojure project you will need the following:

1. https://clojure.org/guides/install_clojure
2. a directory for your Datomic schema project - best to put this into a separate repository and touch only when necessary (or use [this template  I made](https://github.com/lukal-x/datomic-schema-postgres/) and skip the following points)
3. cd into your schema dir/repo
4. `touch deps.edn`
5. add the following to `deps.edn`
```
{:paths ["src" "resources"]
 :deps {org.clojure/clojure {:mvn/version "1.12.3"}
        io.rkn/conformity {:mvn/version "0.5.4"}
        org.postgresql/postgresql {:mvn/version "42.7.7"}
        com.datomic/peer {:mvn/version "1.0.7469"}}}
```

6. `mkdir resources && touch resources/myschema.edn`
7. specify your schema in `resources/myschema.edn` (more info [here](https://docs.datomic.com/schema/schema-reference.html))
8. then `mkdir src/myproj && touch src/myproj/main.clj`
9. add the exact same clojure code as in examples from [conformity's README](https://github.com/qtrfeast/conformity?tab=readme-ov-file#srcmy_projectsomethingclj) but change the connection uri to `datomic:sql://myprojdb?jdbc:postgresql://localhost:5432/myprojpgdb?user=myprojuser&password=myprojpwd`

then in repo root run

`clj -M -m myproj.main`

and clojure will download conformity, postgresql driver, and a datomic peer (provides the `datomic.api` that you see being imported in the example (plus conformity uses it internally I think)). 

Conformity should run without error, print out the new state of Datomic after ensuring the schema, and hang. I force stopped the command I ran and called it a day.

[[Next: immortal software manifesto](immortal-software-manifesto.html)]