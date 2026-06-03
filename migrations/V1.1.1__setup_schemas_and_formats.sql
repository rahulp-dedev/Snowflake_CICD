-- =========================================================
-- V1.1.1 - Schemas, file formats, warehouses
-- =========================================================

CREATE DATABASE IF NOT EXISTS ECOMMERCE_DB COMMENT = 'E-commerce analytics platform';

CREATE SCHEMA IF NOT EXISTS BRONZE_LAYER     COMMENT = 'RAW DATA';
CREATE SCHEMA IF NOT EXISTS STAGING_SCHEMA   COMMENT = 'Stream landing / staging';
CREATE SCHEMA IF NOT EXISTS SILVER_LAYER     COMMENT = 'Cleansed, deduplicated, typed data';
CREATE SCHEMA IF NOT EXISTS GOLD_LAYER       COMMENT = 'Business-level aggregations and metrics';
CREATE SCHEMA IF NOT EXISTS DATA_QUALITY     COMMENT = 'DMFs, custom checks, monitoring';
CREATE SCHEMA IF NOT EXISTS MONITORING       COMMENT = 'Operational monitoring views';
CREATE SCHEMA IF NOT EXISTS SCHEMACHANGE     COMMENT = 'schemachange change-history tracking';

-- File formats for ingestion
CREATE OR REPLACE FILE FORMAT BRONZE_LAYER.CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL','null','')
    EMPTY_FIELD_AS_NULL = TRUE;

CREATE OR REPLACE FILE FORMAT BRONZE_LAYER.JSON_FORMAT
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = TRUE;

CREATE OR REPLACE STAGE BRONZE_LAYER.gcs_realtime_stage
  URL = 'gcs://snowflake-realtime-ds-pipeline/'
  STORAGE_INTEGRATION = GCS_INT
  FILE_FORMAT = BRONZE_LAYER.CSV_FORMAT;

-- Governance tag used across gold layer for column-level privacy classification
CREATE TAG IF NOT EXISTS PUBLIC.PRIVACY_LEVEL
    ALLOWED_VALUES 'HIGH','MEDIUM','LOW'
    COMMENT = 'Column-level privacy classification';