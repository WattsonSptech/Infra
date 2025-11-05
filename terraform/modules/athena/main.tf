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
  bac1 INT,
  data_reclamacao DATE,
  hora_minuto_reclamacao STRING,
  reclamacao_status STRING,
  reclamacao_categoria STRING,
  tipo_produto STRING,
  tipo_problema STRING,
  reclamacao_sentimento STRING,
  data_hora_reclamacao TIMESTAMP
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'field.delim'=';',
  'serialization.format'=';'
)
LOCATION 's3://bkt-wattson-client-${local.id_conta}/reclamacao_cliente'
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
  bac INT,
  tipo_consumo STRING,
  numero_consumidores INT,
  consumo INT,
  ano_mes_coleta STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'field.delim'=';',
  'serialization.format'=';'
)
LOCATION 's3://bkt-wattson-client-${local.id_conta}/consumo/'
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
  bac INT,
  data_geracao DATE,
  hora_minuto_geracao STRING,
  ano_mes_geracao STRING,
  zona_geracao STRING,
  data_hora_geracao TIMESTAMP,
  tensao_valor DECIMAL(4,1),
  tensao_severidade BOOLEAN,
  clima_temperatura INT,
  clima_chuva DECIMAL(3,1),
  clima_vento DECIMAL(3,1),
  clima_severidade BOOLEAN,
  clima_evento STRING,
  indice_aprovacao DECIMAL(2,1)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'field.delim'=';',
  'serialization.format'=';'
)
LOCATION 's3://bkt-wattson-client-${local.id_conta}/tensao_clima/'
TBLPROPERTIES (
  'skip.header.line.count'='1'
);

EOF
}