/*1*/
SELECT Suppliers.Phone
FROM Suppliers
WHERE SUBSTRING(Suppliers.ContactName, 1, 1) = 'S'

/*2*/
SELECT E.FirstName
FROM Employees E
WHERE (
SELECT COUNT(*)
FROM Orders O
WHERE e.EmployeeID = O.EmployeeID
) > 3

/*3*/
Select E.lastname , DATEDIFF(YEAR, E.BirthDate, E.HireDate) as Age
FROM Employees E
WHERE E.Title != 'Sales Representative'

/*4*/
Select C.Address, C.ContactName
FROM Customers C
WHERE(
SELECT SUM(O_D.UnitPrice*O_D.Quantity)
FROM Orders as O, [Order Details] as O_D
WHERE O_D.OrderID = O.OrderID AND C.CustomerID = O.CustomerID
) > 6000

/*5*/
SELECT SUM(O_D.Quantity) as Q
FROM Orders O , [Order Details] as O_D , Products as P
WHERE O_D.OrderID = O.OrderID AND O_D.ProductID = p.ProductID AND O.ShipCountry = 'France'