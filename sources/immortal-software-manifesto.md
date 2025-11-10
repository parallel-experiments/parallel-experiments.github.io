# Immortal software manifesto

> Modern programming scares me in many respects, where they will just build layer after layer after layer that does nothing except translate.
>
> \- Ken Thompson.
>
> [https://oh4.co/site/ken-thompson.html](https://oh4.co/site/ken-thompson.html)

Refusal to accept reality on reality's terms comes at a cost.

## Why

Reality is an electrical current, flowing through circuits, directed by repeatable instructions, and those instructions get combined together to move about representations of information. Data. Various repeatabe combinations of these data movements are called algorithms.

That is the physical reality of software.
That's where it ends.

There many more layers on top of it but the physical reality ends there.

## Software comes and goes but hardware is forever


It is time to challenge the harmful yet foundational belief in development, one that software can be developed in reverse - starting with the application goal then working in reverse to wrestle and arrange bits and bytes into a desired (or close enough) shape which is incidentally completely arbitrary and subjective.

If your end goal is completely divorced from reality so will be your costs, your results, and your experience.

**This proposal is to start guaranteeing longevity and reliability with the software you deliver to your customers and/or users.**

By doing this we can alleviate pressure on software users and move it onto the software producers. In order to stay reputable/profitable, those who distribute/sell/rent software will have to deliver drastically higher quality or convenience than their competition. Much like any other business.

Benefits of this are self evident.

## Values

1. Software SHOULD be built as implementation of falsifiable goals - algorithms and protocols - first, and its applications should be discoverable, not "invented". This makes reimplementation extremely easy, and the service the software performs becomes as durable as the data it operates on.


2. Software built as an implementation of falsifiable goals becomes verifiable and certifiable which means it MUST be treated as a finished (repairable and upgradable but still finished) product.


3. Software built this way is supposed to be dramatically more maintainble meaning it MUST be sold/rented in a much more reliable manner.

## Principles and practicality

Just as a vehicle is engineered, manufactured, and sold/rented, so should software.

There's a reason why there's no such thing as Vehicle-as-a-Service and no, this does not mean renting, a VaaS business - as a parallel to a SaaS - would provide you with a helicopter one day and a bicycle the very next, and would be out of business next month.

A software product that is engineered, manufactured, and sold/rented consists of a core algorithm, usually a hybrid/complex one, which is in charge of handling the data it is given. This core algorithm is the centerpoint of the software product and it always behaves predictably, always does the same thing given the same input. The core algorithm is surrounded, is interfaced with, by various (usually one) user interfaces which make use of the algorithm and the data it handles.

### An example

One example is you create and sell/rent (or freeware, doesn't matter) some kind of video editing software. While your implementation can be as proprietary as it gets, it should be reproducible from a document describing what the core algorithm is and what standards/protocols/systems are used to handle the data.

You can make it as complicated as you want but if you give a reasonably competent programmer a document describing the core algorithm and standars/protocols used and they can't remake it in a reasonable amount of time, you have an unreliable product on your hands.

You can do this as a test and advertise your product with it: "certified as reliable by 1, 10, 100 programmers" or "certified as reliable by Linus Torvalds, Dennis Ritchie, Yukihiro Matsumoto".

## Comments

<iframe src="https://microads.ftp.sh/api/ads/delivery-node/random?nonce=abc123"></iframe>

There are of course other unavoiadable concerns that are common to building a software service (e.g. where are user accounts stored, how are sessions handled et cetera) that this does not cover however there are always more and less reliable approaches to handling said concerns.

## Criticism

None so far.

## Errata

Been brewing this idea for a while but wrote the document in one Sunday morning so I expect to get corrected on quite a few things :)

[[Next: how to put Django into a Polylith](django-apps-in-a-polylith.html)]