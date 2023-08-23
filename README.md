# Playbill

## Business Scenario
This database is for the theatre industry. The data is from [Playbill](https://www.playbill.com/grosses) and [open source data sets](https://www.kaggle.com/jessemostipak/broadway-weekly-grosses?select=synopses.cs
v).

## Typical users
Analysts will a typical users. They would need to interact with the data to determine which shows are
profitable, which have the lowest priced tickets, and which genre brings in the biggest
crowd. Analysts would then report to managers. 

## Representative questions
- What is the number of tickets sold?
- Which show is/was performing?
- Which theatre is that show performing in? Is the show currently running?
- What does the trend for genres look like?
- Which actors form the main cast?
- Total weekly gross of the show?
- All time gross of the show?
- Percent of seats filled?

## Anticipated volume of reads, inserts, and updates
The data would be updated once a week for all of the theaters: daily seats sold (7 entries per show), weekly grosses (1 entry per show). Every once in a while (worst case: every few months, best case: every few years) which show is running in which theater and whether a show is currently running or not would need to be updated. Considering that the analysts will likely need the data to update producers as to which shows are performing better / are profitable enough to keep running and which need an update or a shutdown, queries will probably need to be made on a biweekly basis (every two weeks) to determine if slumps/boosts are temporary or a long-term thing.

## Where will performance matter?
Performance would matter for the total gross and the percentage of seats filled. These will probably be the most important values for the analysts to examine and would be updated most frequently.
