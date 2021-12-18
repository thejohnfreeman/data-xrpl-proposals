Over the past few weeks, we've seen peculiar behavior on the XRP ledger:

- "Small" ledgers of just one to four dozen transactions are being validated while validator transaction queues sit full with 2000 transactions.
- [Escalated fees][1] on every validator.
- Transactions queues are over 95% full of transactions offering 12-drop fees, but ledgers very rarely include even one such transaction.

Transactions are being submitted much faster than they are being evacuated from transaction queues, which means transaction queues will never empty.
We were left asking a few questions about what might be slowing down the pipeline between transaction queues and validated ledgers:

- How many transactions are validators trying to remove from their queues with each ledger, i.e. how big are their first proposals? Are there validators who only propose small transaction sets?
- Are there any validators who only propose high fee transactions? Is fee escalation effectively excluding all 12-drop transactions?
- Is there just too little overlap among small-fee transactions in first proposals for any of them to clear that first hurdle of 50% support before reaching consensus?

With these questions in mind, I set out to find answers.

## How did we gather and analyze the data?

To answer these questions, we needed to see what transactions validators were including in their proposals.
Proposals aren't stored in [rippled][] databases, and don't seem to be stored in any [public datasets][2].
A proposal includes a node ID and a transaction set ID, but not the individual transactions.
Those must be requested separately using the transaction set ID.
[peermon][] logs incoming proposals, but does not request or see any transaction sets.

Instead, I edited rippled to [log][3] both proposals and transaction sets.
From there, I [wrote][4] a couple [AWK][] scripts to extract the data to [CSV][], and a [Jupyter][] Python notebook to analyze it with the help of [pandas][].

## Why can we trust the quality of the data?

I recorded XRPL proposals and transaction sets between the approximate hours of 0500 and 1400 UTC on December 7, which was overnight in my central US time zone.
I was able to catch all transactions in all observed proposals for 7606 ledgers.
Those ledgers may not be consecutive, but a representative sample of recent activity is all that matters.
At that time, there were 34 validators on my UNL.
Each is well-represented in the data:
I recorded at least 7474 first proposals for all 34 validators.

## What answers did we get?


[1]: https://github.com/ripple/rippled/blob/release/src/ripple/app/misc/FeeEscalation.md	
[rippled]: https://github.com/ripple/rippled
[2]: https://github.com/WietseWind/fetch-xrpl-transactions
[peermon]: https://github.com/RichardAH/xrpl-peermon
[3]: https://github.com/thejohnfreeman/rippled/commit/9b0b2c9f71698aee90a2ac47487614a6c91aad56
[AWK]: https://en.wikipedia.org/wiki/AWK
[CSV]: https://en.wikipedia.org/wiki/Comma-separated_values
[4]: https://github.com/thejohnfreeman/data-xrpl-proposals
[Jupyter]: https://jupyter.org/
[pandas]: https://pypi.org/project/pandas/

---
	
- what answers did we get?
- where do we go from here?
	- deterministic txn queue ordering
		- may need deep planning to design an order that cannot be gamed to consistently jump to the head of the queue (without paying a higher fee)
		- only need to order within a fee level
	- make it easier for submitters to know expected time horizons for different fee levels, so they can pick the lowest fee level that is likely to get their txn in by an acceptable time
	- might need to start monitoring proposals to get better visibility into network health
