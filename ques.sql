#1. How many copies of the book titled The Lost Tribe are owned by the library branch whose name is "Sharpstown"?

USE SQLAssignment
GO

SELECT Title, No_Of_Copies, BranchName
FROM [BOOK_COPIES] AS BC 
INNER JOIN [LIBRARY_BRANCH] AS LB ON BC.BranchId = LB.BranchId
INNER JOIN [BOOK] AS BK ON BC.BookId = BK.BookID
WHERE Title = 'The Lost Tribe'

#2. How many copies of the book titled The Lost Tribe are owned by each library branch?

USE SQLAssignment
GO

SELECT *
FROM [BOOK_COPIES] AS BC 
INNER JOIN [LIBRARY_BRANCH] AS LB ON BC.BranchId = LB.BranchId
INNER JOIN [BOOK] AS BK ON BC.BookId = BK.BookID
WHERE Title = 'The Lost Tribe'

#3. Retrieve the names of all borrowers who do not have any books checked out.
/*The result set is empty because there are no borrowers who do not have any books checked out. */ 

SELECT *
FROM BOOK_LOANS AS BL 
FULL OUTER JOIN BORROWER AS BW ON BL.CardNo = BW.CardNo
WHERE DateOut IS NULL

#4. For each book that is loaned out from the "Sharpstown" branch and whose 
DueDate is today, retrieve the book title, the borrower's name, and the borrower's address.

/*Assuming 'DueDate is Today' = 765 */
SELECT Title, Name, BW.Address
FROM BOOK_LOANS AS BL 
FULL OUTER JOIN BORROWER AS BW ON BL.CardNo = BW.CardNo
FULL OUTER JOIN BOOK AS BK ON BL.BookId = BK.BookID
FULL OUTER JOIN LIBRARY_BRANCH AS LB ON BL.BranchId = LB.BranchId
WHERE BranchName = 'Sharpstown'
AND DueDate = '765'

#5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT BranchName, COUNT(*) AS "Total number of books loaned"
FROM BOOK_LOANS AS BL
FULL OUTER JOIN LIBRARY_BRANCH AS LB ON BL.BranchId = LB.BranchId
WHERE BranchName IN ('Sharpstown', 'Central', 'Greens', 'Valley')
GROUP BY BranchName

#6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

SELECT Name, Address, COUNT(BL.CardNo) AS 'Checked out books'
FROM BORROWER AS BW
FULL OUTER JOIN BOOK_LOANS AS BL ON BW.CardNo = BL.CardNo
GROUP BY Name, Address
HAVING COUNT (BL.CardNo) > 5

#7. For each book authored (or co-authored) by "Stephen King", retrieve the title and the number of copies owned by the 
library branch whose name is "Central".
/*The result set is empty because there are no copies of Stephen King books at the Central Library, only at Sharpstown. */ 

SELECT Title, No_Of_Copies, BranchName
FROM BOOK AS BK
FULL OUTER JOIN BOOK_COPIES AS BC ON BK.BookID = BC.BookID
FULL OUTER JOIN LIBRARY_BRANCH AS LB ON BC.BranchId = LB.BranchId
FULL OUTER JOIN BOOK_AUTHORS AS BA ON BK.BookID = BA.BookId
WHERE BranchName = 'Central'
AND AuthorName = 'Stephen King'

#8. Create a stored procedure that will execute one or more of those queries, based on user choice.
/*Below I created a stored procedure where the end user can enter the Book Title they're interested in and see
how many copies a Branch carries it at. It will populate the book title, number of copies, branch name and 
address it is located at.*/

USE SQLAssignment
GO

CREATE PROC RetrieveCopy @BTitle nvarchar(50)
AS
SELECT Title, No_Of_Copies, BranchName, Address
FROM [BOOK_COPIES] AS BC 
INNER JOIN [LIBRARY_BRANCH] AS LB ON BC.BranchId = LB.BranchId
INNER JOIN [BOOK] AS BK ON BC.BookId = BK.BookID
WHERE Title = @BTitle

EXEC RetrieveCopy @BTitle = 'Cinderella'