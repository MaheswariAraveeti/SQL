
DROP DATABASE IF EXISTS library;
CREATE DATABASE IF NOT EXISTS library;
USE library;

CREATE TABLE IF NOT EXISTS publisher(
PublisherName VARCHAR(45) NOT NULL,
PublisherAddress VARCHAR(100),
PublisherPhone VARCHAR(20),
PRIMARY KEY (PublisherName));

select * from publisher;

CREATE TABLE IF NOT EXISTS books (
BookID INT NOT NULL AUTO_INCREMENT,
Title VARCHAR(100),
PublisherName VARCHAR(100),
PRIMARY KEY (BookID),
FOREIGN KEY (PublisherName)
REFERENCES publisher (PublisherName)
ON DELETE CASCADE
ON UPDATE CASCADE);
select * from books;

CREATE TABLE IF NOT EXISTS authors(
AuthorID INT NOT NULL AUTO_INCREMENT,
BookID INT,
AuthorName VARCHAR(100),
PRIMARY KEY (AuthorID),
FOREIGN KEY (BookID)
REFERENCES books (BookID)
ON DELETE CASCADE
ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS library_branch(
BranchID INT NOT NULL AUTO_INCREMENT,
BranchName VARCHAR(100),
BranchAddress VARCHAR(100),
PRIMARY KEY (BranchID));


CREATE TABLE IF NOT EXISTS book_copies(
CopiesID INT NOT NULL AUTO_INCREMENT,
BookID INT,
BranchID INT,
No_Of_Copies INT,
PRIMARY KEY (CopiesID),
FOREIGN KEY (BookID)
REFERENCES books (BookID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (BranchID)
REFERENCES library_branch(BranchID)
ON DELETE CASCADE
ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS borrower(
CardNo INT NOT NULL AUTO_INCREMENT,
BorrowerName VARCHAR(100),
BorrowerAddress VARCHAR(100),
BorrowerPhone VARCHAR(20),
PRIMARY KEY (CardNo));

CREATE TABLE IF NOT EXISTS book_loans (
LoanID INT NOT NULL AUTO_INCREMENT,
BookID INT,
BranchID INT,
CardNo INT,
DateOut DATE,
DueDate DATE,
PRIMARY KEY (LoanID),
FOREIGN KEY (BookID)
REFERENCES books (BookID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (BranchID)
REFERENCES library_branch (BranchID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (CardNo)
REFERENCES borrower(CardNo)
ON DELETE CASCADE
ON UPDATE CASCADE);


/* 1.How many copies of the book titled "The Lost Tribe"
 are owned by the library branch whose name is "Sharpstown"?*/
 
 
 select * from books
 inner join book_copies
 on books.BookID=book_copies.BookID
 inner join library_branch
 on book_copies.BranchID=library_branch.BranchID
 where books.Title="The Lost Tribe" and library_branch.BranchName="Sharpstown";
 
 
/* 2.How many copies of the book titled "The Lost Tribe" 
are owned by each library branch?*/ 
 select books.title,books.bookid,book_copies.No_Of_Copies from books
 inner join book_copies
 on books.BookID=book_copies.BookID
 inner join library_branch
 on book_copies.BranchID=library_branch.BranchID
 where books.Title="The Lost Tribe";



/* 3.Retrieve the names of all borrowers
 who do not have any books checked out.*/
 
 select borrower.BorrowerName from book_loans
 right join borrower
 on borrower.CardNo=book_loans.CardNo
 where bookid is null;
 
 
/* 4.For each book that is loaned out from the "Sharpstown" branch and 
whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. */
select books.Title,borrower.BorrowerName,borrower.BorrowerAddress,book_loans.DueDate from books
inner join book_loans
on books.BookID=book_loans.BookID
inner join library_branch
on book_loans.BranchID=library_branch.BranchID
inner join borrower 
on borrower.CardNo = book_loans.CardNo
where BranchName="Sharpstown" and DueDate="2018-02-03";


/* 5.For each library branch, retrieve the branch name
 and the total number of books loaned out from that branch.*/
 
 select library_branch.BranchName,count(BookID) as No_of_Books from book_loans
 inner join library_branch
 on book_loans.BranchID=library_branch.BranchID
 group by library_branch.BranchName;
 
 
/* 6.Retrieve the names, addresses, and number of books 
checked out for all borrowers who have more than five books checked out.*/

select borrower.BorrowerName,count(BookID) as No_of_Books from book_loans
inner join borrower 
on book_loans.CardNo=borrower.CardNo
group by borrower.BorrowerName
having No_of_Books >5;



/* 7.For each book authored by "Stephen King", retrieve the title 
and the number of copies owned by the library branch whose name is "Central".*/

select title,No_Of_Copies,BranchName from authors
inner join books
on authors.BookID=books.BookID
inner join book_copies
on book_copies.BookID=books.BookID
inner join library_branch
on library_branch.BranchID=book_copies.BranchID
where authors.AuthorName="Stephen king" and library_branch.BranchName="Central";

select * from publisher;
select * from library_branch;
select * from borrower;
select * from book_loans;
select * from books;
select * from authors;
select * from book_copies;


