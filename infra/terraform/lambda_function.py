query = """
SELECT
    o.orderid,
    c.customername,
    p.productname,
    oli.quantity,
    oli.rate,
    oli.amount,
    o.totalamount,
    o.createdon
FROM public.ordertransaction o
JOIN public.customer c ON o.customerid = c.customerid
JOIN public.orderlineitems oli ON o.orderid = oli.orderid
JOIN public.product p ON oli.productid = p.productid
ORDER BY o.orderid;
"""