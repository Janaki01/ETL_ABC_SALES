import json
import boto3
import pg8000
# import pandas as pd
import io 
import csv
from datetime import datetime
 
 
# 🔐 Get DB credentials from Secrets Manager
def get_db_secret():
    client = boto3.client("secretsmanager", region_name="ap-south-1")
    response = client.get_secret_value(
        SecretId="etl/postgres/credentials"
    )
    return json.loads(response["SecretString"])
 
 
def lambda_handler(event, context):
    try:
        # 1️⃣ Fetch secret
        secret = get_db_secret()
 
        # 2️⃣ Connect to PostgreSQL
        conn = pg8000.connect(
            user=secret["db_user"],
            password=secret["db_password"],
            host=secret["endpoint"],
            port=int(secret["db_port"]),
            database=secret["database"]
        )
 
        cursor = conn.cursor()
 
        # 3️⃣ SQL Query
        query = """
        SELECT
            o.orderid,
            c.customername,
            p.productname,
            oli.quantity,
            oli.rate,
            oli.amount,
            o.totalamount
        FROM ordertransaction o
        JOIN customer c ON o.customerid = c.customerid
        JOIN orderlineitems oli ON o.orderid = oli.orderid
        JOIN product p ON oli.productid = p.productid
        ORDER BY o.orderid;
        """
 
        cursor.execute(query)
 
        # 4️⃣ Fetch data
        rows = cursor.fetchall()
        columns = [desc[0] for desc in cursor.description]
 
        # # 5️⃣ Convert to DataFrame
        # df = pd.DataFrame(rows, columns=columns)
        # print(f"Total rows fetched: {len(df)}")
 
        # 6️⃣ Convert DataFrame → CSV (in memory)
        csv_buffer = io.StringIO()
        writer = csv.writer(csv_buffer)
        writer.writerow(columns)
        writer.writerows(rows)
         
        BUCKET_NAME = "etl-report-bucket-janaki"
        file_name = f"sales_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"

        # 7️⃣ Upload to S3
        s3_client = boto3.client("s3")
        s3_client.put_object(
        Bucket = BUCKET_NAME,
        Key=f"reports/{file_name}",
        Body=csv_buffer.getvalue()

        )
 
        # 8️⃣ Close DB
        cursor.close()
        conn.close()
 
        return {
            "status": "success",
            "message": "ETL completed and CSV uploaded to S3",
            "rows": len(rows)
        }
 
    except Exception as e:
        print("ERROR:", str(e))
        return {
            "statusCode": 500,
            "body": str(e)
        }
 
# import sys
# print("PYTHON PATH:", sys.path)

# def lambda_handler (event, context):
#     return {"status":"ok"}