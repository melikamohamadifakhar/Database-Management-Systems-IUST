/*1*/
SELECT T.title , T.type
FROM titles as T
WHERE(T.type != 'mod_cook' AND
	  17 < T.price AND
	  T.price<21) 
 
/*2*/
SELECT A.au_id , A.phone , CONCAT(au_fname, ' ', au_lname) AS Fullname
FROM authors A
WHERE ( A.city = 'Oakland')
 
/*3*/
SELECT *
FROM employee E
WHERE(
SELECT min(YEAR(EMP.hire_date)) 
FROM employee as EMP
) = YEAR(E.hire_date)

/*4*/
SELECT *
FROM titles T
WHERE (DATEDIFF(YEAR, T.pubdate, getdate()) > 30)

/*5*/
Select COUNT(*), A.au_fname, A.au_lname, A.address
from authors A, sales S,titles T,titleauthor TA
WHERE A.au_id = TA.au_id AND
	  TA.title_id = T.title_id AND 
	  TA.title_id = S.title_id
Group by A.au_id, A.address, A.au_fname, A.au_lname
