-- A list of CREATE TABLE statements to implement schema
DROP TABLE Orders
DROP TABLE Performance
DROP TABLE Play
DROP TABLE Production
DROP TABLE Actor
DROP TABLE Venue
DROP TABLE Seats
DROP TABLE Account
DROP TABLE Played


CREATE TABLE Play (
    genre VARCHAR(MAX),
    title VARCHAR(100),
    author VARCHAR(50),
    published_date DATE,
    PRIMARY KEY (title, author)
)

INSERT INTO Play (genre, title, author, published_date) VALUES ('Comedy', 'Labour of Love', 'James Graham', '2017'),
                                                               ('Romantic', 'Romeo and Juliet', 'William Shakespeare', '1597'),
                                                               ('Tragedy', 'Hamlet', 'William Shakespeare', '1603'),
                                                               ('Realism', 'Look Back In Anger', 'John Osborne', '1956'),
                                                               ('Fantasy Fiction', 'Wicked', 'Winnie Holzman', '2003');

CREATE TABLE Production (
    prod_id VARCHAR(100),
    director VARCHAR(MAX),
    starting_date DATE,
    company VARCHAR(50),
    title VARCHAR(100),
    author VARCHAR(50),
    FOREIGN KEY (title, author) REFERENCES Play (title, author),
    PRIMARY KEY (prod_id)
)

INSERT INTO Production (prod_id, title, author, director, starting_date, company) VALUES ('P1', 'Labour of Love', 'James Graham', 'John Smith', '2018', 'Sony'),
                                                                                  ('P2','Labour of Love', 'James Graham', 'Jane Doe', '2019', 'Universal'),
                                                                                  ('P3','Hamlet', 'William Shakespeare', 'Emīlija Bogdan Deschamps', '2020', 'Sony'),
                                                                                  ('P4','Romeo and Juliet', 'William Shakespeare', 'Cardea Ambroise Kos', '2010', 'Jiggy'),
                                                                                  ('P5','Wicked', 'Winnie Holzman', 'Polyxena Elisabetta Kolar', '2001', 'Universal');

CREATE TABLE Account (
    fname VARCHAR(MAX),
    lname VARCHAR(MAX),
    username VARCHAR(20),
    PRIMARY KEY (username)
)

INSERT INTO Account (fname, lname, username) VALUES ('James', 'Garfield', 'jg2202'),
                                                    ('Michael', 'Jackson', 'mjheehee'),
                                                    ('Rick', 'Sanchez', 'scientist'),
                                                    ('Thomas', 'Cat', 'meow'),
                                                    ('Jerry', 'Mouse', 'rat');

CREATE TABLE Venue (
    vname VARCHAR(50),
    venue_address VARCHAR(MAX),
    PRIMARY KEY (vname)
)

INSERT INTO Venue (vname, venue_address) VALUES ('Century Link Arena', '1 Occidental Ave, Seattle, WA, USA'),
                                                     ('University of Washington', '1400 University Way, Seattle, WA, USA'),
                                                     ('McDonald', '2730 11th Ave NE, Minneapolis, MN, USA'),
                                                     ('Allianz Arena', '1 Klaus Ave, Munich, Bavaria, Germany'),
                                                     ('Subway', '1400 Military Rd, Detroit, MI, USA');

CREATE TABLE Seats (
    vname VARCHAR(50) REFERENCES Venue(vname),
    seat_id VARCHAR(50),
    price FLOAT,
    PRIMARY KEY (vname, seat_id)
)

INSERT INTO Seats (vname, seat_id, price) VALUES ('Century Link Arena', 'A11', 75.50),
                                                    ('University of Washington', 'J5', 30.00),
                                                    ('University of Washington', 'f0', 30.00),
                                                    ('Subway', '34', 10.0),
                                                    ('Allianz Arena', '56', 0.0),
                                                    ('Century Link Arena', 'A10', 75.50),
                                                    ('Century Link Arena', 'A12', 75.50),
                                                    ('University of Washington', 'J4', 30.00),
                                                    ('University of Washington', 'j6', 30.00),
                                                    ('University of Washington', 'f1', 30.00),
                                                    ('University of Washington', 'f2', 30.00),
                                                    ('Allianz Arena', '54', 10.0),
                                                    ('Allianz Arena', '57', 0.0);
                                                                                    
CREATE TABLE Performance (
    id VARCHAR(100),
    prod_id VARCHAR(100) REFERENCES Production(prod_id),
    starting_date DATE,
    cost INT,
    vname VARCHAR(50) REFERENCES Venue (vname),
    PRIMARY KEY (id)
)

INSERT INTO Performance (id, prod_id, starting_date, cost, vname) VALUES ('A1', 'P1', '2018',  100000, 'Century Link Arena'),
                                                                    ('A2', 'P2', '2001',  200000, 'University of Washington'),
                                                                    ('A3', 'P3', '2019',  30400, 'McDonald'),
                                                                    ('A4', 'P3', '2010',  239734, 'Allianz Arena'),
                                                                    ('A5', 'P4', '2018',  200000, 'Subway');

CREATE TABLE Orders (
    id VARCHAR(100),
    username VARCHAR(20) REFERENCES Account (username),
    perf_id VARCHAR(100) REFERENCES Performance (id),
    vname VARCHAR(50),
    seat_id VARCHAR(50),
    purchase_date DATE,
    FOREIGN KEY (vname, seat_id) REFERENCES Seats(vname, seat_id),
    PRIMARY KEY (id, username)
)

INSERT INTO Orders (id, username, perf_id, vname, seat_id, purchase_date) VALUES ('00001', 'meow', 'A1', 'Century Link Arena', 'A11', '2018-06-22'),
                                                                             ('00002', 'rat', 'A1', 'University of Washington', 'J5', '2019-07-12'),
                                                                             ('00003', 'scientist', 'A3', 'University of Washington', 'J5', '2020-05-02'),
                                                                             ('00004', 'mjheehee', 'A2', 'University of Washington', 'f0', '2010-06-22'),
                                                                             ('00005', 'jg2202', 'A4', 'Allianz Arena', '56','2001-01-19');

CREATE TABLE Actor (
    fname VARCHAR(100),
    lname VARCHAR(100),
    dob DATE,
    nationality VARCHAR(MAX),
    PRIMARY KEY (fname, lname)
)

INSERT INTO Actor (fname, lname, dob, nationality) VALUES ('Roland', 'Senft', '1970-12-25', 'Portugese'),
                                                          ('Milica', 'Bumgarner', '1984-06-23', 'German'),
                                                          ('Juozapas', 'Kohl', '1992-10-30', 'German'),
                                                          ('Christoph', 'York', '1969-04-20', 'American'),
                                                          ('Cuimin', 'Novacek', '1966-06-06', 'Czechian');

CREATE TABLE Played (
    perf_id VARCHAR(100) REFERENCES Performance(id),
    fname VARCHAR(100),
    lname VARCHAR(100),
    FOREIGN KEY(fname, lname) REFERENCES Actor(fname, lname),
    PRIMARY KEY(perf_id, fname, lname)
)

INSERT INTO Played (perf_id, fname, lname) VALUES ('A1', 'Roland', 'Senft'),
                                                    ('A1', 'Milica', 'Bumgarner'),
                                                    ('A2', 'Roland', 'Senft'),
                                                    ('A3', 'Roland', 'Senft'),
                                                    ('A4', 'Cuimin', 'Novacek')
