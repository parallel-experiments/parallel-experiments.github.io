# Solana mental model

This post, like most others, is primarily a note to self so I don't forget again.

See I'm doing a hobby project which interacts with Solana and it's sizeable enough for a single developer to work on one part of it for quite a while before moving to another part. Recently I finished some things and came back to the parts of the project which talk to Solana...

Solana information landscape is, well, good enough. Like anything else it will take some time to get acquainted with how Solana behaves and how you should behave when interfacing with it. If you're used to this - to you - it doesn't seem like a big deal.

HOWEVER the developer documentation and all the surrounding information like guides and tutorials didn't really help me rediscover all the concepts I'd already learned and understood like half a year ago.

> Note: Keep in mind it might be just that my capacity is limited, or perhaps I didn't really understand the concepts and I just got it to work good enough™

## Solana is instructions and instructions are interfaces

It's just bags of interfaces, and more nuanced concepts/abstractions are just shortcuts to groups of these interfaces;

1. you could call them functions if you want to draw a parallel with a library of some kind or with an ABI
2. you could call them statements if you want to draw a parallel to SQL
3. you could call them endpoints if you want to draw a parallel with an http API

and in a way the parallels will work.

Some of these sometimes also provide some kind of support for putting a group of interfacings (noun, plural) together - be it function calls (pt 1), statements (pt 2), or endpoints(pt 3)* - into a single "transaction" to be executed (and rolled back on failure).

Same with Solana interfacings (instructions).

Interfacings/instructions to handle tokens are provided by the SPL Token program, for example, and executing a series of transactions with instructions to tell the chain that some token exists and some wallet has control of it is how tokens are create.

But you can write your own also. More on this later.