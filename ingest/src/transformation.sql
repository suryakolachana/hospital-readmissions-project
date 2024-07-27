CREATE OR REPLACE TABLE {project_id}.{transformed_dataset}.{transformed_table}
PARTITION BY start_date AS 
SELECT
    facility_name,
    CAST(facility_id AS INT64) AS facility_id,
    state,
    measure_name,
    CAST(number_of_discharges AS INT64) AS number_of_discharges,
    footnote,
    CAST(excess_readmission_ratio AS FLOAT64) AS excess_readmission_ratio,
    CAST(predicted_readmission_rate AS FLOAT64) AS predicted_readmission_rate,
    CAST(expected_readmission_rate AS FLOAT64) AS expected_readmission_rate,
    CAST(number_of_readmissions AS INT64) AS number_of_readmissions,
    PARSE_DATE('%m/%d/%Y', start_date) AS start_date,
    PARSE_DATE('%m/%d/%Y', end_date) AS end_date
FROM {project_id}.{staging_dataset}.{staging_table}
WHERE number_of_discharges NOT IN ('0','N/A');