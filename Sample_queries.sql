-- Sample queries using the database

-- How many tickets in total were purchased by each customer? (Customer, Manager, Analyst)
SELECT A.username, COUNT(O.id) as number_of_tickets
FROM Account as A, Orders as O
WHERE A.username = O.username
GROUP BY A.username;


-- Which director has the most tickets sold for any of their productions?
SELECT TOP 1 Production.director, COUNT(O.id) as Total_sale
FROM Production, Orders as O, Performance
WHERE O.perf_id = Performance.id
    AND Production.prod_id = Performance.prod_id
GROUP BY Production.director
ORDER BY Total_sale DESC


-- What is the rank of average gross profit of plays?
SELECT Play.title, Play.author, SUM(S.price) AS profit
FROM Production, Play, Performance, Seats as S, Orders as O
WHERE Production.title = Play.title
    AND Production.author = Play.author
    AND Performance.prod_id = Production.prod_id
    AND O.perf_id = Performance.id
    AND S.seat_id = O.seat_id
GROUP BY Play.title, Play.author
ORDER BY profit DESC

-- What is the percentage of seats filled for a given performance? (Manager)
WITH total_seat as(
    SELECT COUNT(S.seat_id) as total, S.vname as vname, P.id as pid
    FROM Seats as S, Performance as P
    WHERE P.vname = S.vname
    GROUP BY S.vname, P.id
), FILTERED as (
    SELECT COUNT(O.seat_id)as seat_count, O.vname as vname, P.id as pid
    FROM Orders as O, Performance as P
    WHERE P.vname = O.vname
    GROUP BY O.vname, P.id
)
SELECT T.pid, (CAST(F.seat_count as float)/T.total)*100 as 'percentage'
From total_seat as T LEFT OUTER JOIN FILTERED as F ON T.vname = F.vname
ORDER BY (CAST(F.seat_count as float)/T.total)

-- What genre of play is the most popular given a venue? 
-- Find the genre with the most number of tickets sold for each venues
WITH af AS (
    SELECT O.vname, COUNT(O.id) as Total_sale, play.genre
    FROM Production, Play, Performance, Orders as O
    WHERE O.perf_id = Performance.id
        AND Production.prod_id = Performance.prod_id
        AND Play.title = Production.title
        And Play.author = Production.author
    GROUP BY O.vname, play.genre
)
SELECT af.vname, af.genre
FROM af, (
	SELECT af.vname, max(af.total_sale) as max_sale
	FROM af
	GROUP BY af.vname
) as maxaf
WHERE af.vname = maxaf.vname
	and af.total_sale = maxaf.max_sale 

-- Which day of the week would attract the most visitors for all performances?
SELECT TOP 1 DATENAME(dw,P.starting_date) as most_visitors
FROM Orders as O, Performance as P
GROUP BY DATENAME(dw, P.starting_date)
ORDER BY COUNT(O.id)

-- Who is the highest grossing actor? (Analyst)
WITH Perform AS (
    SELECT SUM(s.price) as 'revenue', o.perf_id
    FROM Orders o
    LEFT JOIN Seats s ON o.seat_id = s.seat_id
    GROUP BY o.perf_id
)
SELECT TOP 1 SUM(pf.revenue) as 'gross', fname, lname
FROM Played pl
LEFT JOIN Perform pf ON pl.perf_id = pf.perf_id
GROUP BY fname, lname
ORDER BY gross DESC

-- What is the most amount of money someone has spent on performances within a year? (Analyst)
SELECT o.username, SUM(s.price) as money_spent
FROM Orders o
LEFT JOIN Seats s ON o.seat_id = s.seat_id
GROUP BY o.username

-- note:
-- Need left join orders on seats (not the other way around) because
-- if seats is merged on orders, then all possible seats are returned, including unfilled seats.
-- Target: each order and the associated price with it

-- How many tickets were sold for each production?
SELECT P.title as production_name, COUNT(O.id) as total_tickets
FROM Production as P, Orders as O, Performance as P2
WHERE O.perf_id = P2.id
    AND P2.prod_id = P.prod_id
GROUP BY P.prod_id, P.title

-- For each play, what is the average performance cost?
SELECT prod.title, prod.author, company, AVG(pf.cost) as avg_cost
FROM Performance pf, Production prod
WHERE prod.prod_id = pf.prod_id
GROUP BY prod.title, prod.author, prod.company;


-- Demo 1 What is the percentage of seats filled for a given performance?
WITH total_seat as(
    SELECT COUNT(S.seat_id) as total, S.vname as vname, P.id as pid
    FROM Seats as S, Performance as P
    WHERE P.vname = S.vname
    GROUP BY S.vname, P.id
), FILTERED as (
    SELECT COUNT(O.seat_id)as seat_count, O.vname as vname, P.id as pid
    FROM Orders as O, Performance as P
    WHERE P.vname = O.vname
    GROUP BY O.vname, P.id
)
SELECT T.pid, (CAST(F.seat_count as float)/T.total)*100 as 'percentage'
From total_seat as T LEFT OUTER JOIN FILTERED as F ON T.vname = F.vname
ORDER BY (CAST(F.seat_count as float)/T.total)

-- Demo 2 Who is the highest grossing actor
WITH Perform AS (
    SELECT SUM(s.price) as 'revenue', o.perf_id
    FROM Orders o
    LEFT JOIN Seats s ON o.seat_id = s.seat_id
    GROUP BY o.perf_id
)
SELECT TOP 1 SUM(pf.revenue) as 'gross', fname, lname
FROM Played pl
LEFT JOIN Perform pf ON pl.perf_id = pf.perf_id
GROUP BY fname, lname
ORDER BY gross DESC

-- Demo 3 Which day of the week would attract the most visitors?
SELECT TOP 1 DATENAME(dw,P.starting_date) as most_visitors
FROM Orders as O, Performance as P
GROUP BY DATENAME(dw, P.starting_date)
ORDER BY COUNT(O.id)

-- Demo 4 Which director has the most tickets sold for any of their productions?
SELECT TOP 1 Production.director, COUNT(O.id) as Total_sale
FROM Production, Orders as O, Performance
WHERE O.perf_id = Performance.id
    AND Production.prod_id = Performance.prod_id
GROUP BY Production.director
ORDER BY Total_sale DESC 