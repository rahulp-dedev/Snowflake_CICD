CREATE OR REPLACE STAGE BRONZE_LAYER.gcs_realtime_stage
  URL = 'gcs://snowflake-realtime-ds-pipeline/'
  STORAGE_INTEGRATION = GCS_INT
  FILE_FORMAT = BRONZE_LAYER.CSV_FORMAT;