CREATE OR REPLACE FUNCTION fn_calc_lineitem_amount()
RETURNS TRIGGER AS $$
DECLARE
    v_rate NUMERIC;
BEGIN
    -- Get rate from product
    SELECT rate INTO v_rate
    FROM product
    WHERE productid = NEW.productid;
 
    -- Set rate and amount
    NEW.rate := v_rate;
    NEW.amount := NEW.quantity * v_rate;
 
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
 
 
CREATE TRIGGER trg_calc_lineitem_amount
BEFORE INSERT ON orderlineitems
FOR EACH ROW
EXECUTE FUNCTION fn_calc_lineitem_amount();
 
CREATE OR REPLACE FUNCTION fn_recalc_order_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE ordertransaction
    SET totalamount = (
        SELECT COALESCE(SUM(amount),0)
        FROM orderlineitems
        WHERE orderid = NEW.orderid
    )
    WHERE orderid = NEW.orderid;
 
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
 
 
CREATE TRIGGER trg_recalc_order_total
AFTER INSERT OR UPDATE OR DELETE ON orderlineitems
FOR EACH ROW
EXECUTE FUNCTION fn_recalc_order_total();
 