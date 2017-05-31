# The Honda Civic Index
The Honda Civic Index (HCI) uses the ubiquity and longevity of Honda Civics to compare used car markets across Canada. It consists of a scraper to get Kijiji data using Yahoo YQL, and some R scripts to clean up the data sets and present results.

## Cities
The criteria for cities are that they (a) have an NHL team, and (b) primarily use Kijiji over Craigslist. Vancouver primarily uses Craigslist, so it's (currently) not on the list.

- `mtl` - Montreal
- `tor` - Toronto
- `ott` - Ottawa
- `wpg` - Winnipeg
- `cgy` - Calgary
- `edm` - Edmonton

## Metrics
- Market volume
- Market cap (sort of...see footnote 1)
- Distributions of price, model year, and kilometers on the car
- Price as a function of model year
- Price as a function of kilometers
- Prices of different "reference Civics"
    + 2005 model with 260k ±10% kms
    + 2010 model with 160k ±10% kms
    + 2015 model with 60k ±10% kms

## Results
![mtl][mtl]
![tor][tor]
![ott][ott]
![wpg][wpg]
![cgy][cgy]
![edm][edm]

## Footnotes
1. These aren't actually the prices the vehicles sell for, just what they're listed for. With this definition of market cap, I could list a Civic for $1B, and it would add $1B to a city's "market cap", but we assume that people are listing their Civics for roughly what they think they'll sell for.

[mtl]: https://cdn.rawgit.com/prollynomial/honda-civic-index/master/output/mtl/market.mtl.svg
[tor]: https://cdn.rawgit.com/prollynomial/honda-civic-index/master/output/tor/market.tor.svg
[ott]: https://cdn.rawgit.com/prollynomial/honda-civic-index/master/output/ott/market.ott.svg
[wpg]: https://cdn.rawgit.com/prollynomial/honda-civic-index/master/output/wpg/market.wpg.svg
[cgy]: https://cdn.rawgit.com/prollynomial/honda-civic-index/master/output/cgy/market.cgy.svg
[edm]: https://cdn.rawgit.com/prollynomial/honda-civic-index/master/output/edm/market.edm.svg
