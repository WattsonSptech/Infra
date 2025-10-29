resource "aws_athena_workgroup" "wattson-workgroup" {
  name = "wattson-workgroup"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${var.bkt_athena_results_wattson}/"
    }
  }
}

resource "aws_athena_database" "wattson_db" {
  name   = "wattson_db"
  bucket = var.bkt_athena_results_wattson
}

resource "aws_athena_named_query" "create_reclamacao_cliente" {
  name        = "reclamacao_cliente"
  database    = aws_athena_database.wattson_db.name
  workgroup   = aws_athena_workgroup.wattson-workgroup.name
  description = "Cria a tabela fato de reclamacao_cliente"

  query = <<EOF
CREATE EXTERNAL TABLE IF NOT EXISTS wattson_db.reclamacao_cliente (
  hora_minuto_reclamacao STRING,
  reclamacao_data DATE,
  reclamacao_ano_mes STRING,
  reclamacao_status STRING,
  reclamacao_problema STRING,
  reclamacao_categoria STRING,
  reclamacao_tipo_produto STRING,
  reclamacao_sentimento STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '"'
)
LOCATION 's3://bkt-wattson-raw-716961619224/'
TBLPROPERTIES (
  'skip.header.line.count'='1'
);
EOF
}

resource "aws_athena_named_query" "create_consumo" {
  name        = "consumo"
  database    = aws_athena_database.wattson_db.name
  workgroup   = aws_athena_workgroup.wattson-workgroup.name
  description = "Cria a tabela fato_consumo"

  query = <<EOF
CREATE EXTERNAL TABLE IF NOT EXISTS wattson_db.consumo (
  ano_mes_coleta STRING,
  numero_consumidores INT,
  numero_consumo INT,
  tipo_consumo STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '"'
)
LOCATION 's3://bkt-wattson-raw-716961619224/'
TBLPROPERTIES (
  'skip.header.line.count'='1'
);
EOF
}

resource "aws_athena_named_query" "create_tensao_clima" {
  name        = "tensao_clima"
  database    = aws_athena_database.wattson_db.name
  workgroup   = aws_athena_workgroup.wattson-workgroup.name
  description = "Cria a tabela fato tensao_clima"

  query = <<EOF
CREATE EXTERNAL TABLE IF NOT EXISTS wattson_db.tensao_clima (
  hora_minuto_geracao string,
  data_geracao DATE,
  ano_mes_geracao STRING,
  zona_geracao STRING,
  tensao_valor DECIMAL(3,1),
  tensao_severidade BOOLEAN,
  clima_temperatura INT,
  clima_chuva DECIMAL(3,1),
  clima_vento DECIMAL(3,1),
  clima_severidade BOOLEAN,
  clima_evento STRING,
  indice_aprovacao DECIMAL(2,1)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar' = '"'
)
LOCATION 's3://bkt-wattson-raw-716961619224/'
TBLPROPERTIES (
  'skip.header.line.count'='1'
);

EOF
}