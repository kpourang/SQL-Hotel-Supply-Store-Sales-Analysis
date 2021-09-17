# SQL-Hotel-Supply-Store-Sales-Analysis

<p> Suppose you have started working as a Business Intelligence analyst for a Store that sells Hotel Supplies. In
your first week your boss requested a set of reports to understand better the sales trends.</p>
<p></p>
<p>The IT department provided a data model, the structures of each table and csv files to be loaded into the
database.</p>

<p>The IT department has defined PostgreSQL as the tool to perform the task. The list of requirements from your boss is:</p>

<ol>
  <li> Preparation: 
    <ol style="list-style-type:lower-alpha">
      <li> Install PostgreSQL; </li> 
      <li> Create a database called ProductSales; </li>
      <li> Run the scripts to create the structures (table_creation.sql); </li>
      <li> Run the scripts to load the data into the structure created; </li>
     </ol></li>
     <p></p>
  <li>Query the database to select the number of units, average, standard deviation, max and min product price by category. 
  <pre>
  SELECT category.categoryname,
         COUNT(0) AS units,
	       ROUND(AVG(product.price), 2) AS average_price,
	       ROUND(STDDEV(product.price), 2) AS std_price,
	       MAX(product.price) AS max_price,
	       MIN(product.price) AS min_price
 FROM product
 INNER JOIN category USING(categoryid)
 GROUP BY category.categoryname
 ORDER BY average_price DESC;
  </pre>
  </li>
  <p></p>
  <li> Query the database to select the top 10 best-selling products of all times. 
  <pre>
  SELECT category.categoryname,
         product.productname,
	       SUM(orderdetail.quantity) AS units_sold
  FROM orderdetail
    INNER JOIN product USING(productid)
      INNER JOIN category USING(categoryid)
  GROUP BY category.categoryname, product.productname
  ORDER BY units_sold DESC
  LIMIT 10;
  </pre>
  </li>
  <p></p>
  <li> Query the database to select the gross revenue and total tax by year. 
  <pre>
  SELECT EXTRACT(YEAR FROM orders.orderdate) AS year,
         ROUND(SUM(orderdetail.quantity * product.price * (1 - COALESCE(orderdetail.discount, 0))), 2) AS gross_revenue,
	       ROUND(SUM(orderdetail.quantity * product.price * (1 - COALESCE(orderdetail.discount, 0)) * COALESCE(category.tax, 0) / 100), 2) As tax
  FROM orderdetail
    INNER JOIN product USING(productid)
      INNER JOIN orders USING(orderid)
        INNER JOIN category USING(categoryid)
          INNER JOIN salesrep USING(salesrepid)
  GROUP BY EXTRACT(YEAR FROM orders.orderdate)
  ORDER BY gross_revenue DESC;
  </pre>
  </li>
  <p></p>
  <li> In 2014, customers that purchased more than $ 300,000 in products will be segmented as loyalty members. Discover the list of eligible customers. 
  <pre>
  SELECT customer.customername,
         ROUND(SUM(orderdetail.quantity * product.price * (1 - COALESCE(orderdetail.discount, 0))), 2) AS total_sale
  FROM orderdetail
    INNER JOIN product USING(productid)
      INNER JOIN orders USING(orderid)
        INNER JOIN customer USING(customerid)
  WHERE EXTRACT(YEAR FROM orders.orderdate) = 2014
  GROUP BY customer.customername
  HAVING SUM(orderdetail.quantity * product.price * (1 - COALESCE(orderdetail.discount, 0))) > 30000
  ORDER BY total_sale DESC;
  </pre>
  </li>
  <p></p>
  <li> The sales reps receive a 20% commission fee over the total of the sale. You must calculate the commission of each employee. Online sales should appear at the list grouped, although they don’t have a specific sales rep name. 
  <pre>
  SELECT COALESCE(salesrep.salesrepname, 'Online') AS salesrep_name,
         ROUND(SUM(orderdetail.quantity * product.price * (1 - COALESCE(orderdetail.discount, 0 )) * 0.2), 2) AS comission
  FROM orderdetail
    INNER JOIN orders USING(orderid)
      INNER JOIN product USING(productid)
        LEFT JOIN salesrep USING(salesrepid)
          INNER JOIN category USING(categoryid)
  GROUP BY salesrep.salesrepname
  ORDER BY comission DESC;
  </pre>
  </li>
  <p></p>
  <li> The Sales Department decided to deduce the amount of discount granted in each order from the commission of sales reps. And decided to give an extra $ 200 bonus for each member of the website team if the commission of the online sales is placed within the top 3 commissions. Did the website team earned their bonus? 
  <pre>
  SELECT COALESCE(salesrep.salesrepname, 'Online') AS salesrep_name,
         ROUND(SUM(orderdetail.quantity * product.price * (1 - COALESCE(orderdetail.discount, 0)) * 0.2) - 
			   SUM(orderdetail.quantity * product.price * COALESCE(orderdetail.discount, 0)), 2) AS comission
  FROM orderdetail
    INNER JOIN orders USING(orderid)
      INNER JOIN product USING(productid)
        LEFT JOIN salesrep USING(salesrepid)
          INNER JOIN category USING(categoryid)
  GROUP BY salesrep.salesrepname
  ORDER BY comission DESC;
  </pre>
  </li>
    </ol>
