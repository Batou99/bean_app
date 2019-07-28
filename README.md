# BeanApp

This application is a proof of concept of how to match transactions with a list of known merchants via elasticsearch.

## Data flow
![BeanAppDiagram](https://user-images.githubusercontent.com/419903/62005271-24c64c00-b131-11e9-846d-20d6e77697ac.png)

## Reindex transactions with unknown merchants

To fix `Unknown` merchants we have to:

1. Add a new merchant to the DB via `Merchant.save(name)`
2. Call `Transaction.reindex_unknowns`

That will copy all transaction descriptions that are matched with the `Unknown` merchant to the transactions queue for rematching.
The `Classifier` job will then try to match each queued transaction with any of the current merchants.
If the new added merchant matches any of these transactions, it will get associated with them.

## For larger datasets

With larger datasets the problem could be tackled differently. Instead of using a full text search approach we could be using supervised learning.
This would probably yield better results as more valid matches are added to the DB.
As the DB grows larger we will have more datapoints (transactions with an associated merchant) so it should be easier to infer the matching rules via ML than using a pure token matching approach.

## Installation and running

* Install dependencies: `mix deps.get`
* Start elasticsearch: `./scripts/start_es`
* Run app: `iex -S mix`
* Optionally use console to interact with modules

## Tests

Run `mix test` to run the test suite.

Run `MIX_HOME="." mix dializer` to check the typespecs.
