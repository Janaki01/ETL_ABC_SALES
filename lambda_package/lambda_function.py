import json
import os
import pg8000.dbapi as pg
import boto3
from io import StringIO
import csv

def get_db_secret():
    Client = boto3.client("secretsmanager")
    response = Client.get_secret_value(
        SecretsId="etl/postgres/credentials"
    )
    secret = json.loads(response["SecretString"])
    return secret
secret = get_db_secret()
host= secret["DB_HOST"]
port = int(secret["DB_PORT"])
db = secret["DB_NAME"]
user = secret["DB_USER"]
password = secret["DB_PASSWORD"]

 # Connect to PostgreSQL (RDS)
conn = pg.connect(
    host=host,
    port=port,
    database=db,
    user=user,
    password=password
)

def lambda_handler(event, context):
    cursor = conn.cursor()
    # Read environment variables
    # host = os.environ['DB_HOST']
    # port = int(os.environ['DB_PORT'])
    # db   = os.environ['DB_NAME']
    # user = os.environ['DB_USER']
    # password = os.environ['DB_PASSWORD']
    # bucket = os.environ['S3_BUCKET']
 
 
    # Your business query
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
 
    cursor.execute(query)
    rows = cursor.fetchall()
 
    # Create CSV in memory
    output = StringIO()
    writer = csv.writer(output)
 
    # Header
    writer.writerow([
        "orderid", "customername", "productname",
        "quantity", "rate", "amount", "totalamount", "createdon"
    ])
 
    # Data
    for row in rows:
        writer.writerow(row)
 
    # Upload to S3
    s3 = boto3.client("s3")
    s3.put_object(
        Bucket=bucket,
        Key="etl_report.csv",
        Body=output.getvalue()
    )
 
    cursor.close()
    conn.close()
 
    return {
        "status": "success",
        "message": "ETL completed and CSV uploaded to S3",
        "rows": len(rows)
    }