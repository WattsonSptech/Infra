resource "aws_iot_thing" "thing_wattson" {
  name = "thing-wattson"
}

resource "aws_iot_certificate" "cert_thing_wattson" {
  active = true
}

resource "aws_iot_policy" "policy_wattson" {
  name   = "sensor-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow", 
        Action   = [
          "iot:Connect",
          "iot:Publish",
          "iot:Subscribe",
          "iot:Receive"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iot_policy_attachment" "cert_attach" {
  policy = aws_iot_policy.policy_wattson.name
  target = aws_iot_certificate.cert_thing_wattson.arn
}

resource "aws_iot_thing_principal_attachment" "thing_attach" {
  thing     = aws_iot_thing.thing_wattson.name
  principal = aws_iot_certificate.cert_thing_wattson.arn
}

resource "aws_iot_topic_rule" "dynamodb_rule" {
  name        = "rule_sensor_to_lambda"
  description = "Enviar arquivo com dados dos sensores para lambda DO DynamoDB"
  enabled     = true
  sql         = "SELECT * FROM 'wattson/sensors/energy'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = var.lmb_data_dynamodb_arn
  }
}

resource "aws_lambda_permission" "allow_dynamodb_iot" {
  statement_id  = "AllowExecutionFromIoT"
  action        = "lambda:InvokeFunction"
  function_name = var.lmb_data_dynamodb_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.dynamodb_rule.arn
}

resource "aws_iot_topic_rule" "s3_rule" {
  name        = "rule_sensor_to_s3"
  description = "Enviar arquivo com dados dos sensores para a lambda do S3"
  enabled     = true
  sql         = "SELECT * FROM 'wattson/sensors/energy'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = var.lbd_data_s3_arn
  }
}

resource "aws_lambda_permission" "allow_s3_iot" {
  statement_id  = "AllowExecutionFromIoT"
  action        = "lambda:InvokeFunction"
  function_name = var.lbd_data_s3_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.s3_rule.arn
}

resource "local_file" "certificate_file" {
  content = aws_iot_certificate.cert_thing_wattson.certificate_pem
  filename = "cert/iot-certificate.pem.crt"
}

resource "local_file" "key_file" {
  content = aws_iot_certificate.cert_thing_wattson.private_key
  filename = "cert/iot-private-key.pem.crt"
}
