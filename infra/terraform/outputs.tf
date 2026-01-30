output "rds_endpoint" {
  value = aws_db_instance.etl_db.endpoint
}
 
output "lambda_name" {
  value = aws_lambda_function.etl_lambda.function_name
}