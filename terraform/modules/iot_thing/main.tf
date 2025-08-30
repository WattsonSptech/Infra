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
        Action   = ["iot:*"],
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

resource "aws_iot_topic_rule" "rule" {
  name        = "rule_sensor_to_lambda"
  description = "Enviar arquivo com dados dos sensores para lambda"
  enabled     = true
  sql         = "SELECT * FROM 'wattson/sensors/energy'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = var.lbd_data_dynamodb_arn
  }
}

resource "aws_lambda_permission" "allow_iot" {
  statement_id  = "AllowExecutionFromIoT"
  action        = "lambda:InvokeFunction"
  function_name = var.lbd_data_dynamodb_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.rule.arn
}
