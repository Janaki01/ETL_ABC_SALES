data "archive_file" "etl_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda_package"
  output_path = "${path.module}/../../etl_lambda.zip"
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "lambda_role" {
  name = "etl-lambda-role-${var.env}"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = { Service = "lambda.amazonaws.com" }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
resource "aws_iam_role_policy" "lambda_secrets_policy" {
  name = "etl-lambda-secrets-${var.env}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = "arn:aws:secretsmanager:ap-south-1:124355643919:secret:etl/postgres/credentials*"
    }]
  })
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "etl-lambda-s3-${var.env}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject"]
      Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
    }]
  })
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_lambda_function" "etl_lambda" {
  function_name = "etl_automation_lambda-${var.env}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
#   filename = "${path.module}/etl_lambda.zip"
#   source_code_hash = filebase64sha256("${path.module}/etl_lambda.zip")
  filename         = data.archive_file.etl_lambda_zip.output_path
  source_code_hash = data.archive_file.etl_lambda_zip.output_base64sha256

  timeout     = 300
  memory_size = 512

  environment {
    variables = {
      DB_HOST   = aws_db_instance.etl_db.address
      DB_PORT   = "5432"
      DB_NAME   = var.db_name
      DB_USER   = var.db_user
      DB_PASS   = var.db_master_password
      S3_BUCKET = var.s3_bucket_name
    }
  }
  lifecycle {
    prevent_destroy = true
    # ignore_changes  = [
    #     filename,
    #     source_code_hash,
    #     architectures,
    #     layers,
    #     environment,
    #     logging_config,
    #     tracing_config,
    #     ephemeral_storage
    # ]
  }
}
resource "aws_iam_policy" "lambda_secrets_policy" {
  name = "lambda-secrets-access-${var.env}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement =[ 
      {
        Effect= "Allow"
        Action = [ "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
  lifecycle {
    prevent_destroy = true
    ignore_changes = all
  }

}